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
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistFollowers: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    private let disposeBag = DisposeBag()
    private var artistsObservable: Observable<[Artist]>!
    
    var artist: Artist?
    var presenter: SpotifyArtistPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
       
    private func setupView(){
        artistName.text = artist?.name
        artistFollowers.text = CommonUtilities.getFollowers(number: artist?.followers ?? 0)
        popularity.text = "Popularity: \(artist?.popularity ?? 0)"
        if let item = artist{
            CommonUtilities.setupImage(imageUrl: item.fullImage ?? "", imageView: artistImage, placeholder: "square.and.arrow.down")
        }
    }
}
