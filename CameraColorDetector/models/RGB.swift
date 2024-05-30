//
//  RGB.swift
//  CameraColorDetector
//
//  Created by דוד נוי on 29/05/2024.
//

import Foundation

struct RGB: Hashable {
    let red: Int
    let green: Int
    let blue: Int
    var percentage: Double = 0

    func hash(into hasher: inout Hasher) {
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
    }

    static func == (lhs: RGB, rhs: RGB) -> Bool {
        return lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue
    }
    
    // MARK: - Public func
    
    // Get the frequency
    func getFrequency() -> Float {
        
        // Find the closest color
        var closestColor: ColorRGBAndFrequency?
        var closestDistance = Double.infinity
        
        let colors = ColorRGBAndFrequency.AllColors
        
        for color in colors {
            let distance = colorDistance(color.rgb)
            if distance < closestDistance {
                closestDistance = distance
                closestColor = color
            }
        }
        
        return closestColor?.frequency ?? 8.8 // random number to indicate a problem in logs
    }
    
    // MARK: - Ptivate func
    
    // Calculate Euclidean distance between self and another RGB colors
    private func colorDistance(_ color2: RGB) -> Double {
        let rDiff = self.red - color2.red
        let gDiff = self.green - color2.green
        let bDiff = self.blue - color2.blue
        
        return sqrt(Double(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff))
    }
}
