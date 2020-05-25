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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: ListCollectionView!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    private let disposeBag = DisposeBag()
    private var artistsObservable: Observable<[Artist]>!
    
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
                    self.presenter.showArtist(index: 1)
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
            return MainSectionController()
        }
        return MainSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeViewController: HomeViewProtocol{
    // MARK: - Handle Presenter Output
    func handlePresenterOutput(_ output: HomePresenterOutput) {
        switch output {
        case .showArtists(let artistArray):
            self.artistArray = artistArray
        }
    }
}
