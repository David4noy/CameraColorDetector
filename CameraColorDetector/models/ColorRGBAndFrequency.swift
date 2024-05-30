//
//  ColorRGBAndFrequency.swift
//  CameraColorDetector
//
//  Created by דוד נוי on 29/05/2024.
//

import Foundation

struct ColorRGBAndFrequency {
    let name: String
    let rgb: RGB
    let frequency: Float
    
}

extension ColorRGBAndFrequency {
    static let AllColors: [ColorRGBAndFrequency] = [
        ColorRGBAndFrequency(name: "Indigo", rgb: RGB(red: 75, green: 0, blue: 130), frequency: 181.90),
        ColorRGBAndFrequency(name: "Maroon", rgb: RGB(red: 128, green: 0, blue: 0), frequency: 190.99),
        ColorRGBAndFrequency(name: "Red", rgb: RGB(red: 255, green: 0, blue: 0), frequency: 194.63),
        ColorRGBAndFrequency(name: "Pink", rgb: RGB(red: 255, green: 192, blue: 203), frequency: 195.54),
        ColorRGBAndFrequency(name: "Crimson", rgb: RGB(red: 220, green: 20, blue: 60), frequency: 214.64),
        ColorRGBAndFrequency(name: "Orange", rgb: RGB(red: 255, green: 165, blue: 0), frequency: 227.37),
        ColorRGBAndFrequency(name: "Aqua", rgb: RGB(red: 0, green: 255, blue: 255), frequency: 229.65),
        ColorRGBAndFrequency(name: "Cyan", rgb: RGB(red: 0, green: 255, blue: 255), frequency: 231.92),
        ColorRGBAndFrequency(name: "Yellow", rgb: RGB(red: 255, green: 255, blue: 0), frequency: 238.74),
        ColorRGBAndFrequency(name: "Gold", rgb: RGB(red: 255, green: 215, blue: 0), frequency: 245.56),
        ColorRGBAndFrequency(name: "Magenta", rgb: RGB(red: 255, green: 0, blue: 255), frequency: 248.29),
        ColorRGBAndFrequency(name: "Green", rgb: RGB(red: 0, green: 255, blue: 0), frequency: 249.66),
        ColorRGBAndFrequency(name: "Lime", rgb: RGB(red: 0, green: 255, blue: 0), frequency: 256.93),
        ColorRGBAndFrequency(name: "Blue", rgb: RGB(red: 0, green: 0, blue: 255), frequency: 287.86),
        ColorRGBAndFrequency(name: "Black", rgb: RGB(red: 0, green: 0, blue: 0), frequency: 40.0),
        ColorRGBAndFrequency(name: "White", rgb: RGB(red: 255, green: 255, blue: 255), frequency: 500.0),
        ColorRGBAndFrequency(name: "Brown", rgb: RGB(red: 165, green: 42, blue: 42), frequency: 60.0),
        ColorRGBAndFrequency(name: "Gray", rgb: RGB(red: 128, green: 128, blue: 128), frequency: 80.0)
    ]
    // Coomon colors with known frequency divided by 2 until the above number to give the same "note"
    // The frequencies of black, white, brown and gray were invented, and Pink were assumed for illustration purposes
}
