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
    @IBOutlet private weak var artistImage: UIImageView!
    @IBOutlet private weak var artistName: UILabel!
    @IBOutlet private weak var artistFollowers: UILabel!
    @IBOutlet private weak var popularity: UILabel!
    @IBOutlet private var albumImages: [UIImageView]?
    @IBOutlet private weak var topAlbumsLabel: UILabel!
    @IBOutlet private weak var topAlbumsLeadingConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private var artistsObservable: Observable<[Artist]>!
    
    @IBOutlet var albumTitleLabels: [UILabel]?
    @IBOutlet var albumDateLabels: [UILabel]?
    
    @IBOutlet private weak var addToFavorites: UIButton? {
        didSet {
            addToFavorites?.then {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 6
                let image = UIImage(named: "SectionSeparator") as UIImage?
                $0.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    var artist: Artist?
    var albums: [Album]?
    
    var presenter: SpotifyArtistPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        setupInitialPosition()
    }
    
    private func setupInitialPosition(){
        topAlbumsLabel.isHidden = true
        topAlbumsLeadingConstraint.constant = -130
        self.view.layoutIfNeeded()
    }
    
    private func animateTopAlbums(){
        topAlbumsLabel.isHidden = false
        self.topAlbumsLeadingConstraint.constant = 15
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func fetchData(){
        self.showSpinner(onView: self.view)
        self.presenter?.showAlbums(id: self.artist?.id ?? "0")
        DispatchQueue.global(qos: .userInteractive).async {
            while true {
                if self.albums != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.animateTopAlbums()
                        self.removeSpinner()
                        self.setupAlbums()
                    })
                    break
                }
            }
        }
    }
    
    private func setupAlbums(){
        guard let images = albumImages,
              let albumsArray = albums,
              let dateLabels = albumDateLabels,
              let nameLabels = albumTitleLabels else { return }
        
        for (index, image) in images.enumerated() {
            if let albumImage = albumsArray[safe: index]?.smallImage {
                CommonUtilities.setupImage(imageUrl: albumImage, imageView: image, placeholder: "square.and.arrow.down")
                image.roundedCorners()
            }
        }
        
        for (index, label) in dateLabels.enumerated() {
            if let date = albumsArray[safe: index]?.releaseDate {
                label.text = date
            }
        }
        
        for (index, label) in nameLabels.enumerated() {
            if let name = albumsArray[safe: index]?.name {
                label.text = name
            }
        }
         
        pulsate()
    }

    private func setupView(){
        artistName.text = artist?.name
        artistFollowers.text = CommonUtilities.getFollowers(number: artist?.followers ?? 0)
        popularity.text = "Popularity: \(artist?.popularity ?? 0)"
        if let item = artist{
            CommonUtilities.setupImage(imageUrl: item.fullImage ?? "", imageView: artistImage, placeholder: "square.and.arrow.down")
        }
        
        guard let artist = self.artist else { return }
        if presenter.isFavorite(artist: artist) {
            addToFavorites?.setTitle("Remove", for: .normal)
            addToFavorites?.sizeToFit()
        } else {
            addToFavorites?.setTitle("Add to Favorites", for: .normal)
            addToFavorites?.sizeToFit()
        }
    }
    
    private func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        artistImage.layer.add(pulse, forKey: "pulse")
    }
    
    // MARK: - IBActions
    @IBAction func setFavorite(_ sender: Any) {
        guard let artist = self.artist else { return }
        presenter.setAsFavorite(artist: artist)
        setupView()
    }
}

extension DetailViewController: SpotifyViewProtocol{
    // MARK: - Handle Presenter Output
    func handlePresenterOutput(_ output: SpotifyPresenterOutput) {
        switch output {
        case .showArtists(_):
            break
        case .showAlbums(let albumArray):
            self.albums = albumArray
        }
    }
}
