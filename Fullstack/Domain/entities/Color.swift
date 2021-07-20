//
//  File.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/24.
//

import Foundation
import SwiftUI
enum ColorSet: VO {
    case RED(
        active: Color = Color.LABEL_RED_ACTIVE,
        deactive: Color = Color.LABEL_RED_DEACTIVE,
        text: Color = Color.TEXT_RED,
        textDark: Color = Color.TEXT_RED_DARK
    )
    case ORANGE(
        active: Color = Color.LABEL_ORANGE_ACTIVE,
        deactive: Color = Color.LABEL_ORANGE_DEACTIVE,
        text: Color = Color.TEXT_ORANGE,
        textDark: Color = Color.TEXT_ORANGE_DARK
    )
    case YELLOW(
        active: Color = Color.LABEL_YELLOW_ACTIVE,
        deactive: Color = Color.LABEL_YELLOW_DEACTIVE,
        text: Color = Color.TEXT_YELLOW,
        textDark: Color = Color.TEXT_YELLOW_DARK
    )
    case GREEN(
        active: Color = Color.LABEL_GRAY_ACTIVE,
        deactive: Color = Color.LABEL_GREEN_DEACTIVE,
        text: Color = Color.TEXT_GREEN,
        textDark: Color = Color.TEXT_GREEN_DARK
    )
    case PEACOCK_GREEN(
        active: Color = Color.LABEL_PEACOCK_GREEN_ACTIVE,
        deactive: Color = Color.LABEL_PEACOCK_GREEN_DEACTIVE,
        text: Color = Color.TEXT_PEACOCK_GREEN,
        textDark: Color = Color.TEXT_PEACOCK_GREEN_DARK
    )
    case BLUE(
        active: Color = Color.LABEL_BLUE_ACTIVE,
        deactive: Color = Color.LABEL_BLUE_DEACTIVE,
        text: Color = Color.TEXT_BLUE,
        textDark: Color = Color.TEXT_BLUE_DARK
    )
    case CONBALT_BLUE(
        active: Color = Color.LABEL_CONBALT_BLUE_ACTIVE,
        deactive: Color = Color.LABEL_CONBALT_BLUE_DEACTIVE,
        text: Color = Color.TEXT_CONBALT_BLUE,
        textDark: Color = Color.TEXT_CONBALT_BLUE_DARK
    )
    case PINK(
        active: Color = Color.LABEL_PINK_ACTIVE,
        deactive: Color = Color.LABEL_PINK_DEACTIVE,
        text: Color = Color.TEXT_PINK,
        textDark: Color = Color.TEXT_PINK_DARK
    )
    case GRAY(
        active: Color = Color.LABEL_GRAY_ACTIVE,
        deactive: Color = Color.LABEL_GRAY_DEACTIVE,
        text: Color = Color.TEXT_GRAY,
        textDark: Color = Color.TEXT_GREEN_DARK
    )
    case VIOLET(
        active: Color = Color.LABEL_VIOLET_ACTIVE,
        deactive: Color = Color.LABEL_VIOLET_DEACTIVE,
        text: Color = Color.TEXT_VIOLET,
        textDark: Color = Color.TEXT_VIOLET_DARK
    )
}

extension ColorSet {
    var active: Color {
        var color: Color
        switch self {
        case .RED(let active, _, _, _): color = active
        case .ORANGE(let active, _, _, _): color = active
        case .YELLOW(let active, _, _, _): color = active
        case .GREEN(let active, _, _, _): color = active
        case .PEACOCK_GREEN(let active, _, _, _): color = active
        case .BLUE(let active, _, _, _): color = active
        case .CONBALT_BLUE(let active, _, _, _): color = active
        case .PINK(let active, _, _, _): color = active
        case .GRAY(let active, _, _, _): color = active
        case .VIOLET(let active, _, _, _): color = active
        }
        return color
    }

    var deactive: Color {
        var color: Color
        switch self {
        case .RED(_, let deactive, _, _): color = deactive
        case .ORANGE(_, let deactive, _, _): color = deactive
        case .YELLOW(_, let deactive, _, _): color = deactive
        case .GREEN(_, let deactive, _, _): color = deactive
        case .PEACOCK_GREEN(_, let deactive, _, _): color = deactive
        case .BLUE(_, let deactive, _, _): color = deactive
        case .CONBALT_BLUE(_, let deactive, _, _): color = deactive
        case .PINK(_, let deactive, _, _): color = deactive
        case .GRAY(_, let deactive, _, _): color = deactive
        case .VIOLET(_, let deactive, _, _): color = deactive
        }
        return color
    }

    var text: Color {
        var color: Color
        switch self {
        case .RED(_, _, let text, _): color = text
        case .ORANGE(_, _, let text, _): color = text
        case .YELLOW(_, _, let text, _): color = text
        case .GREEN(_, _, let text, _): color = text
        case .PEACOCK_GREEN(_, _, let text, _): color = text
        case .BLUE(_, _, let text, _): color = text
        case .CONBALT_BLUE(_, _, let text, _): color = text
        case .PINK(_, _, let text, _): color = text
        case .GRAY(_, _, let text, _): color = text
        case .VIOLET(_, _, let text, _): color = text
        }
        return color
    }

    var textDark: Color {
        var color: Color
        switch self {
        case .RED(_, _, _, let textDark): color = textDark
        case .ORANGE(_, _, _, let textDark): color = textDark
        case .YELLOW(_, _, _, let textDark): color = textDark
        case .GREEN(_, _, _, let textDark): color = textDark
        case .PEACOCK_GREEN(_, _, _, let textDark): color = textDark
        case .BLUE(_, _, _, let textDark): color = textDark
        case .CONBALT_BLUE(_, _, _, let textDark): color = textDark
        case .PINK(_, _, _, let textDark): color = textDark
        case .GRAY(_, _, _, let textDark): color = textDark
        case .VIOLET(_, _, _, let textDark): color = textDark
        }
        return color
    }
}

extension ColorSet: RawRepresentable {
    public typealias rawValue = String

    public init?(rawValue: rawValue) {
        switch rawValue {
        case "RED": self = .RED()
        case "ORANGE": self = .ORANGE()
        case "YELLOW": self = .YELLOW()
        case "GREEN": self = .GREEN()
        case "PEACOCK_GREEN": self = .PEACOCK_GREEN()
        case "BLUE": self = .BLUE()
        case "CONBALT_BLUE": self = .CONBALT_BLUE()
        case "PINK": self = .PINK()
        case "GRAY": self = .GRAY()
        case "VIOLET": self = .VIOLET()
        default:
            return nil
        }
    }

    public var rawValue: rawValue {
        switch self {
        case .RED:
            return "RED"
        case .ORANGE:
            return "ORANGE"
        case .YELLOW:
            return "YELLOW"
        case .GREEN:
            return "GREEN"
        case .PEACOCK_GREEN:
            return "PEACOCK_GREEN"
        case .BLUE:
            return "BLUE"
        case .CONBALT_BLUE:
            return "CONBALT_BLUE"
        case .PINK:
            return "PINK"
        case .GRAY:
            return "GRAY"
        case .VIOLET:
            return "VIOLET"
        }
    }
}
