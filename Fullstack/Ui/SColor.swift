//
//  Color.swift
//  Fullstack
//
//  Created by 김범준 on 2021/02/04.
//

import Foundation
import SwiftUI

extension Color {
    static let PRIMARY_1 = Color(hex: "F5FFFFFF")
    static let PRIMARY_2 = Color(hex: "8CFFFFFF")
    static let PRIMARY_3 = Color(hex: "4DFFFFFF")
    static let PRIMARY_4 = Color(hex: "2EFFFFFF")

    static let KEY = Color(hex: "6B9EFF")
    static let KEY_ACTIVE = Color(hex: "387CFF")
    static let KEY_INACTIVE = Color(hex: "66387CFF")

    static let DEPTH_5 = Color(hex: "000000")
    
    static let DEPTH_4_BG = Color(hex: "1B1D21")
    static let DEPTH_3 = Color(hex: "282C33")
    static let DEPTH_2 = Color(hex: "3D414C")
    static let DEPTH_1 = Color(hex: "525866")
    
    static let LABEL_RED_ACTIVE = Color(hex: "C76761")
    static let LABEL_RED_DEACTIVE = Color(hex: "30C76761")
    static let TEXT_RED = Color(hex: "FFA799")
    static let TEXT_RED_DARK = Color(hex: "2C1922")
    
    static let LABEL_ORANGE_ACTIVE = Color(hex: "EC9147")
    static let LABEL_ORANGE_DEACTIVE = Color(hex: "26EC9147")
    static let TEXT_ORANGE = Color(hex: "FFCBA1")
    static let TEXT_ORANGE_DARK = Color(hex: "2E2218")

    static let LABEL_YELLOW_ACTIVE = Color(hex: "E8C15D")
    static let LABEL_YELLOW_DEACTIVE = Color(hex: "26E8C15D")
    static let TEXT_YELLOW = Color(hex: "FFE299")
    static let TEXT_YELLOW_DARK = Color(hex: "353125")
    
    static let LABEL_GREEN_ACTIVE = Color(hex: "3EA87A")
    static let LABEL_GREEN_DEACTIVE = Color(hex: "263EA87A")
    static let TEXT_GREEN = Color(hex: "B1E5CF")
    static let TEXT_GREEN_DARK = Color(hex: "1D2A24")
    
    static let LABEL_PEACOCK_GREEN_ACTIVE = Color(hex: "52CCCC")
    static let LABEL_PEACOCK_GREEN_DEACTIVE = Color(hex: "2652CCCC")
    static let TEXT_PEACOCK_GREEN = Color(hex: "A1E5E5")
    static let TEXT_PEACOCK_GREEN_DARK = Color(hex: "182424")
    
    static let LABEL_BLUE_ACTIVE = Color(hex: "4CA6FF")
    static let LABEL_BLUE_DEACTIVE = Color(hex: "264CA6FF")
    static let TEXT_BLUE = Color(hex: "B2D9FF")
    static let TEXT_BLUE_DARK = Color(hex: "132334")
    
    static let LABEL_CONBALT_BLUE_ACTIVE = Color(hex: "6565E5")
    static let LABEL_CONBALT_BLUE_DEACTIVE = Color(hex: "266565E5")
    static let TEXT_CONBALT_BLUE = Color(hex: "BFBFFF")
    static let TEXT_CONBALT_BLUE_DARK = Color(hex: "2B2B4D")
    
    static let LABEL_VIOLET_ACTIVE = Color(hex: "A06EE5")
    static let LABEL_VIOLET_DEACTIVE = Color(hex: "26A06EE5")
    static let TEXT_VIOLET = Color(hex: "D9C2FF")
    static let TEXT_VIOLET_DARK = Color(hex: "2A1F38")
    
    static let LABEL_PINK_ACTIVE = Color(hex: "E089B5")
    static let LABEL_PINK_DEACTIVE = Color(hex: "26E089B5")
    static let TEXT_PINK = Color(hex: "FFC7E3")
    static let TEXT_PINK_DARK = Color(hex: "2D1D25")
    
    static let LABEL_GRAY_ACTIVE = Color(hex: "7B8399")
    static let LABEL_GRAY_DEACTIVE = Color(hex: "267B8399")
    static let TEXT_GRAY = Color(hex: "CCDAFF")
    static let TEXT_GRAY_DARK = Color(hex: "282A2F")
    
    static let darkBackgroundColor = Color(white: 0.0)
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        return darkBackgroundColor
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
