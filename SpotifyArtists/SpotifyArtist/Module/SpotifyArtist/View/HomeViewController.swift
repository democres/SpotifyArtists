//
//  HomeViewController.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

protocol MainSectionControllerDelegate: class {
    func showDetailViewController(artist: Artist)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: ListCollectionView!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private let disposeBag = DisposeBag()
    
    var artistArray: [Artist]?{
        didSet{
            self.adapter.performUpdates(animated: true)
        }
    }
    var presenter: SpotifyArtistPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func fetchData(){
        self.showSpinner(onView: self.view)
        DispatchQueue.global(qos: .userInteractive).async {
            while true {
                if App.bearerToken != "" {
                    self.presenter.showArtists()
                    self.removeSpinner()
                    break
                }
            }
        }
    }
    
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.artistArray ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Artist {
            let sectionController = MainSectionController()
            sectionController.delegate = self
            return sectionController
        }
        return MainSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeViewController: SpotifyViewProtocol{
    // MARK: - Handle Presenter Output
    func handlePresenterOutput(_ output: SpotifyPresenterOutput) {
        switch output {
        case .showArtists(let artistArray):
            self.artistArray = artistArray
        case .showAlbums(_):
            break
        }
    }
}

extension HomeViewController: MainSectionControllerDelegate {
    // MARK: - Handle ListSectionOutput
    func showDetailViewController(artist: Artist) {
        presenter.showDetailViewController(artist: artist)
    }
}
