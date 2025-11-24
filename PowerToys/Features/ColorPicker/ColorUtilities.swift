//
//  ColorUtilities.swift
//  PowerToys
//
//  Created by Sourabh Malviya on 24/11/25.
//

import SwiftUI

extension Color {
    func toHex() -> String? {
        guard let components = cgColor?.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }

    func toRGBString() -> String? {
        guard let components = cgColor?.components, components.count >= 3 else { return nil }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return "rgb(\(r), \(g), \(b))"
    }

    func toHSLString() -> String? {
        // Simple conversion or use CoreGraphics if available
        // For brevity, using a basic calculation
        guard let components = cgColor?.components, components.count >= 3 else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        let maxVal = max(r, max(g, b))
        let minVal = min(r, min(g, b))
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        let l: CGFloat = (maxVal + minVal) / 2
        
        if maxVal != minVal {
            let d = maxVal - minVal
            s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal)
            
            if maxVal == r {
                h = (g - b) / d + (g < b ? 6 : 0)
            } else if maxVal == g {
                h = (b - r) / d + 2
            } else {
                h = (r - g) / d + 4
            }
            h /= 6
        }
        
        return String(format: "hsl(%.0f, %.0f%%, %.0f%%)", h * 360, s * 100, l * 100)
    }

    func toCMYKString() -> String? {
        guard let components = cgColor?.components, components.count >= 3 else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        let k = 1 - max(r, max(g, b))
        if k == 1 { return "cmyk(0%, 0%, 0%, 100%)" }
        
        let c = (1 - r - k) / (1 - k)
        let m = (1 - g - k) / (1 - k)
        let y = (1 - b - k) / (1 - k)
        
        return String(format: "cmyk(%.0f%%, %.0f%%, %.0f%%, %.0f%%)", c * 100, m * 100, y * 100, k * 100)
    }
    
    func lighter(by percentage: CGFloat = 0.2) -> Color {
        return adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.2) -> Color {
        return adjust(by: -abs(percentage))
    }

    func adjust(by percentage: CGFloat = 0.2) -> Color {
        guard let components = cgColor?.components, components.count >= 3 else { return self }
        
        return Color(red: min(Double(components[0] + percentage), 1.0),
                     green: min(Double(components[1] + percentage), 1.0),
                     blue: min(Double(components[2] + percentage), 1.0),
                     opacity: Double(components.count > 3 ? components[3] : 1))
    }
}
