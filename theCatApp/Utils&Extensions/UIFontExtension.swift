//
//  UIFontExtension.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

private extension UIFont {
    enum FontWeight: String {
        case regular = "Regular"
        case bold = "Bold"
        case light = "Light"
    }

    static func font(size: CGFloat, weight: FontWeight) -> UIFont {
        let name = "Roboto-\(weight.rawValue)"
        if let font = UIFont(name: name, size: size) {
            return font
        }

        var font: UIFont?
        if register(fontName: name) {
            font = UIFont(name: name, size: size)
        }
        return font ?? UIFont.systemFont(ofSize: size)
    }

    static func register(fontName: String) -> Bool {
        guard let path = Bundle.main.path(forResource: fontName, ofType: "ttf"),
            let data = NSData(contentsOfFile: path),
            let provider = CGDataProvider(data: data),
            let reference = CGFont(provider) else {
                return false
        }
        var errorReference: Unmanaged<CFError>?
        return !(CTFontManagerRegisterGraphicsFont(reference, &errorReference) == false)
    }
}

extension UIFont {
    static func regular(size: CGFloat) -> UIFont {
        .font(size: size, weight: .regular)
    }

    static func bold(size: CGFloat) -> UIFont {
        .font(size: size, weight: .bold)
    }

    static func light(size: CGFloat) -> UIFont {
        .font(size: size, weight: .light)
    }
}
