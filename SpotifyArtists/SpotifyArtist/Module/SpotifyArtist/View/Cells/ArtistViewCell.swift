//
//  ArtistViewCell.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import UIKit
import RxSwift

class ArtistViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel? {
        didSet {
            titleLabel?.then {
                $0.textColor = .black
            }
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel? {
        didSet {
            descriptionLabel?.then {
                $0.textColor = .lightGray
            }
        }
    }

    @IBOutlet private weak var leftIconImg: UIImageView? {
        didSet{
            leftIconImg?.then {
                $0.makeItRounded()
                $0.backgroundColor = .lightGray
            }
        }
    }
    @IBOutlet private var genresLabels: [UILabel]?
    
    private(set) var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearData()
    }

    func update(with item: Any?) {
        guard let artist = item as? Artist else { return }
        setupWith(item: artist)
    }
    
    private func setupWith(item: Artist) {
        self.titleLabel?.text = item.name ?? ""
        self.descriptionLabel?.text = CommonUtilities.getFollowers(number: item.followers)
        
        if let image = leftIconImg {
            CommonUtilities.setupImage(imageUrl: item.profileImage ?? "", imageView: image, placeholder: "person")
        }
        
        guard let labels = genresLabels else { return }

        for (index, label) in labels.enumerated() {
            if let genre = item.genres[safe: index] {
                label.text = genre.capitalized
            } else{
                label.text = "Others"
            }
        }
    }

    private func clearData() {
        titleLabel?.text = nil
        descriptionLabel?.text = nil
        disposeBag = DisposeBag()
    }
}

