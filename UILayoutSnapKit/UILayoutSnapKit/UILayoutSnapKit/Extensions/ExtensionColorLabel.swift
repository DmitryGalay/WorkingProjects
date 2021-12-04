//
//  ExtensionColorLabel.swift
//  UILayoutSnapKit
//
//  Created by Dima on 27.11.21.
//

import Foundation
import UIKit

extension UILabel {

    func setText(_ text: String, withColorPart colorTextPart: String, color: UIColor) {
        attributedText = nil
        let result =  NSMutableAttributedString(string: text)
        result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSString(string: text.lowercased()).range(of: colorTextPart.lowercased()))
        attributedText = result
    }
}