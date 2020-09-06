//
//  BreedTableViewCell.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

final class BreedTableViewCell: UITableViewCell, RegistrableTableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var temperamentLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        layoutIfNeeded()
    }

    func setup(with viewModel: BreedCellViewModel) {
        nameLabel.setup(with: viewModel.nameLabel)
        temperamentLabel.setup(with: viewModel.temperamentLabel)
    }
}
