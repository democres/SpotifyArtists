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
    
    @IBOutlet private weak var collectionView: ListCollectionView!

    @IBOutlet weak var favoritesButtonImg: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var allArtistsIcon: UIImageView!
    @IBOutlet weak var allArtistsLabel: UILabel!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private let disposeBag = DisposeBag()
    
    var artistArray: [Artist]?{
        didSet{
            self.adapter.performUpdates(animated: true)
        }
    }
    var showFavorites = false
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

        var counter = 0
        Timer.scheduledTimer(withTimeInterval: 1.0,repeats: true) {
            timerInstance in
            if App.bearerToken != "" {
                self.presenter.showArtists()
                self.removeSpinner()
                timerInstance.invalidate()
            }
            counter += 1
            if counter == 3 {
                let alert = UIAlertController(title: "No Connection", message: "There is a problem with your connection, you are using the offline cache now", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.presenter.showArtists()
                self.removeSpinner()
                timerInstance.invalidate()
            }
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func favoritesTap(_ sender: Any) {
        showFavorites = true
        self.adapter.performUpdates(animated: true)
        favoritesButtonImg.tintColor = .black
        favoritesLabel.textColor = .black
        allArtistsIcon.tintColor = .lightGray
        allArtistsLabel.textColor = .lightGray
    }
    
    @IBAction func allArtistsTap(_ sender: Any) {
        showFavorites = false
        self.adapter.performUpdates(animated: true)
        favoritesButtonImg.tintColor = .lightGray
        favoritesLabel.textColor = .lightGray
        allArtistsIcon.tintColor = .black
        allArtistsLabel.textColor = .black
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if showFavorites {
            return presenter.getFavorites()
        }
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
