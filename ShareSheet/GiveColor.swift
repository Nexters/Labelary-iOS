//
//  GiveColor.swift
//  ShareSheet
//
//  Created by 우민지 on 2023/01/14.
//

import Foundation
import SwiftUI

func giveLabelBackgroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 232/255, green: 194/255, blue: 93/255).opacity(0.15)
    case "Red":
        return Color(red: 199/255, green: 103/255, blue: 97/255).opacity(0.15)
    case "Violet":
        return Color(red: 160/255, green: 110/255, blue: 229/255).opacity(0.15)
    case "Blue":
        return Color(red: 76/255, green: 166/255, blue: 255/255).opacity(0.15)
    case "Green":
        return Color(red: 62/255, green: 168/255, blue: 122/255).opacity(0.15)
    case "Orange":
        return Color(red: 236/255, green: 145/255, blue: 71/255).opacity(0.15)
    case "Pink":
        return Color(red: 224/255, green: 137/255, blue: 181/255).opacity(0.15)
    case "Cobalt_Blue":
        return Color(red: 101/255, green: 101/255, blue: 229/255).opacity(0.15)
    case "Peacock_Green":
        return Color(red: 82/255, green: 204/255, blue: 204/255).opacity(0.15)
    case "Gray":
        return Color(red: 123/255, green: 131/255, blue: 153/255).opacity(0.15)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.15)
    }
}

func giveTextForegroundColor(color: String) -> Color {
    switch color {
    case "Yellow":
        return Color(red: 255/255, green: 226/255, blue: 153/255)
    case "Red":
        return Color(red: 255/255, green: 167/255, blue: 153/255)
    case "Violet":
        return Color(red: 217/255, green: 194/255, blue: 255/255)
    case "Blue":
        return Color(red: 178/255, green: 217/255, blue: 255/255)
    case "Green":
        return Color(red: 177/255, green: 229/255, blue: 207/255)
    case "Orange":
        return Color(red: 255/255, green: 203/255, blue: 161/255)
    case "Pink":
        return Color(red: 255/255, green: 199/255, blue: 227/255)
    case "Cobalt_Blue":
        return Color(red: 191/255, green: 191/255, blue: 255/255)
    case "Peacock_Green":
        return Color(red: 161/255, green: 229/255, blue: 229/255)
    case "Gray":
        return Color(red: 204/255, green: 218/255, blue: 255/255)
    default:
        return Color(red: 255/255, green: 255/255, blue: 255/255)
    }
}
