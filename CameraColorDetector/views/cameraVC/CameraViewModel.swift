//
//  CameraViewModel.swift
//  CameraColorDetector
//
//  Created by דוד נוי on 29/05/2024.
//

import UIKit
import AVFoundation

class CameraViewModel {
    
    private var previousTimestamp: CFTimeInterval = 0
    private var downsampledWidth: Int = 50
    private let maxMS = 130.0 // for a fast response, it should be around this number althogh it will be higher because of the sounds
    private var emptyArriesCounter = 0
    private let maxEmptyArriesAllowed = 30
    private let player = FrequencyPlayer()
    
    // MARK: - Public func
    
    func getColors(_ sampleBuffer: CMSampleBuffer) -> [RGB] {

        // Getting the UIImage
        guard let uiImage = getUIImage(sampleBuffer) else { return [] }
        
        // Downsampling the Image:
        // Scaling
        var multi = 0.6
        if let previousWidth = uiImage.cgImage?.width, let previousHeight = uiImage.cgImage?.height, previousWidth != 0 {
            multi = Double(previousHeight) / Double(previousWidth)
        }
        let newHeight = Int(Double(downsampledWidth) * multi)
        
        // Downsampling
        guard let downsampledImage = downsample(image: uiImage, to: CGSize(width: downsampledWidth, height: newHeight)),
              let cgDownsampledImage = downsampledImage.cgImage else { return [] }
        
        // Getting the data and running on the pixels
        guard let colorsCounts = getColorsCount(for: cgDownsampledImage) else { return [] }
        
        // Sorting to get the 5 most common colors
        let top5Colors = getTop5Colors(for: colorsCounts, with: cgDownsampledImage)
        
        calculateSpeed()
        
        // Checking for general performance problems if it'll return an empty array
        if top5Colors.isEmpty {
            emptyArriesCounter += 1
        } else {
            emptyArriesCounter = 0
        }
        
        return top5Colors
    }
    
    func getAlert(for alertType: Alerts) -> UIAlertController {
        let alert = UIAlertController()
        switch alertType {
        case .changePermissionsPopUp:
            alert.title = Strings.ChangePermissionsAlertTitle
            alert.message = Strings.ChangePermissionsAlertMessage
        case .cameraError:
            alert.title = Strings.CameraErrorTitle
            alert.message = Strings.CameraErrorMessage
        case .emptyArray:
            alert.title = Strings.EmptyArrayTitle
        }
        alert.addAction(UIAlertAction(title: Strings.OK, style: .default, handler: nil))
        return alert
    }
    
    func shouldAlertOnEmptyArray() -> Bool {
        if emptyArriesCounter > maxEmptyArriesAllowed {
            return true
        } else {
            return false
        }
    }
    
    // Changing the frequency according to the color
    func changeFrequency(for oscillator: Oscillator, frequency: Float) {
        player.changeFrequency(for: oscillator, frequency: frequency)
    }
    
    // MARK: - Private func
    
    private func getUIImage(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil}
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil}
        
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
    
    private func getColorsCount(for cgDownsampledImage: CGImage) -> [RGB: Int]? {
        guard let pixelData = cgDownsampledImage.dataProvider?.data else { return nil }
        guard let data = CFDataGetBytePtr(pixelData) else { return nil }
        let bytesPerPixel = cgDownsampledImage.bitsPerPixel / 8
        let width = cgDownsampledImage.width
        let height = cgDownsampledImage.height
        
        var colorCounts: [RGB: Int] = [:]
        
        for x in 0..<width {
            for y in 0..<height {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let r = Int(data[pixelIndex])
                let g = Int(data[pixelIndex + 1])
                let b = Int(data[pixelIndex + 2])
                let color = RGB(red: r, green: g, blue: b)
                colorCounts[color, default: 0] += 1
            }
        }
        
        return colorCounts
    }
    
    private func getTop5Colors(for colorsCounts: [RGB : Int] , with cgDownsampledImage: CGImage) -> [RGB] {
        let totalPixels = cgDownsampledImage.width * cgDownsampledImage.height
        let sortedColors = colorsCounts.sorted { $0.value > $1.value }
        let top5Colors = sortedColors.prefix(5).map { (color, count) -> RGB in
            var colorWithPercentage = color
            colorWithPercentage.percentage = (Double(count) / Double(totalPixels)) * 100
            return colorWithPercentage
        }
        return top5Colors
    }
    
    private func downsample(image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let downsampledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return downsampledImage
    }
    
    // Change the downsampledWidth according to the device processing capabilities
    private func calculateSpeed() {
        let currentTimestamp = CACurrentMediaTime()
        let elapsedTime = (currentTimestamp - previousTimestamp) * 1000 // Convert to milliseconds
        
        if elapsedTime < maxMS {
            downsampledWidth += 10
        }
        print("Time since last entry: \(elapsedTime) ms \nDownsampled Width: \(downsampledWidth)")
        previousTimestamp = currentTimestamp
    }
}
