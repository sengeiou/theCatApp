//
//  ViewController.swift
//  theCatApp
//
//  Created by Julián Granada on 5/09/20.
//  Copyright © 2020 Julián Granada. All rights reserved.
//

import UIKit

protocol BreedsView: class {
    func setupView(with viewModel: BreedsViewModel)
    func setBreedsArray(breeds: [BreedCellViewModel])
    func goToDetail(with breedModel: BreedModel)
    func showAlert(title: String, message: String)
    func showLoader()
    func hideLoader()
}

final class BreedsViewController: BaseViewController, MVPView {
    @IBOutlet private weak var breedsTable: UITableView!

    lazy var presenter: BreedsPresenterProtocol = inject()
    lazy var screenLoaderView: UIView = {
        return view.getLoadingView()
    }()
    private var breedsArray: [BreedCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.breedsTable.reloadData()
            }
        }
    }
}

extension BreedsViewController: BreedsView {
    func setupView(with viewModel: BreedsViewModel) {
        navigationItem.setup(with: viewModel.navigationItem)
        breedsTable.setup(with: viewModel.breedsTable)
        setupTableView()
    }

    func setBreedsArray(breeds: [BreedCellViewModel]) {
        breedsArray = breeds
    }

    func goToDetail(with breedModel: BreedModel) {
        let breedDetailViewController = BreedDetailViewController(breedModel: breedModel)
        navigationController?.pushViewController(breedDetailViewController, animated: true)
    }

    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.showLoadingView(self.screenLoaderView)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.hideLoadingView(self.screenLoaderView)
        }
    }

    private func setupTableView() {
        BreedTableViewCell.register(in: breedsTable)
    }
}

extension BreedsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breedsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier, for: indexPath) as? BreedTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: breedsArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onSelectCell(at: indexPath.row)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if breedsTable.contentSize.height - scrollView.frame.size.height - position <= 10 {
            breedsTable.showMoreItemsLoader()
            presenter.onLastItemShowed { [weak self] in
                self?.breedsTable.hideMoreItemsLoader()
            }
        }
    }
}
