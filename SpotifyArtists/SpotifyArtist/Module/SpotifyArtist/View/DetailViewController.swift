//
//  DetailViewController.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var artistsObservable: Observable<[Artist]>!
    
    var artist: Artist?
    var presenter: SpotifyArtistPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
       
}
