//
//  LabelViewModel.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

struct AttributedStringModel {
    var string: String
    var alignment: NSTextAlignment = .left
    var stringAttributes: [NSAttributedString.Key: Any]?
    var attributedTexts: [AttributedText]
}

struct AttributedText {
    var text: String
    var attributes: [NSAttributedString.Key: Any]
}

struct LabelViewModel {
    var text: String
    var attributedText: AttributedStringModel?
    var appearance: LabelAppearance
}

struct LabelAppearance {
    var font: UIFont
    var textColor: UIColor
    var textAlignment: NSTextAlignment

    init(font: UIFont,
         textColor: UIColor = .primaryText,
         textAlignment: NSTextAlignment = .natural) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}

extension UILabel {
    func setup(with viewModel: LabelViewModel) {
        text = viewModel.text
        setup(with: viewModel.appearance)

        if let attributedTexts = viewModel.attributedText {
            setup(attributedStringModel: attributedTexts, font: viewModel.appearance.font)
        }
    }

    func setup(with appearance: LabelAppearance) {
        font = appearance.font
        textColor = appearance.textColor
        textAlignment = appearance.textAlignment
    }

    private func setup(attributedStringModel: AttributedStringModel, font: UIFont) {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
//        let paragraph
        if let stringAttributes = attributedStringModel.stringAttributes {
            stringAttributes.forEach { attributes.updateValue($0.value, forKey: $0.key) }
        }

        let attributedString = NSMutableAttributedString(string: attributedStringModel.string,
                                                         attributes: attributes)
        let mainString = attributedString.mutableString
        for attributedText in attributedStringModel.attributedTexts {
            let stringRange = mainString.range(of: attributedText.text)
            attributedString.addAttributes(attributedText.attributes, range: stringRange)
        }
        attributedText = attributedString
    }
}
