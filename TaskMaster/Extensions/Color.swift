//
//  Color.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

extension Color {
    static let paletteDeepRed = Color(hex: "#780000")
    static let paletteVibrantRed = Color(hex: "#C1121F")
    static let paletteCream = Color(hex: "#FDF0D5")
    static let paletteNavy = Color(hex: "#003049")
    static let paletteSoftBlue = Color(hex: "#669BBC")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
