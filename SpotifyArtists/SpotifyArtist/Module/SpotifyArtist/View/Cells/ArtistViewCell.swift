//
//  ArtistViewCell.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

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
        
        self.descriptionLabel?.text = getFollowers(number: item.followers)
        
        self.setupImages(item: item)
        
    }
    
    func getFollowers(number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))
        
        return "Followers: \(formattedNumber ?? "")"
    }
    
    private func setupImages(item: Artist){
        let url = URL(string: item.profileImage ?? "")
        self.leftIconImg?.kf.setImage(
        with: url,
        placeholder: UIImage(named: "person"),
        options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ])
    }
    
    private func clearData() {
        titleLabel?.text = nil
        descriptionLabel?.text = nil
        disposeBag = DisposeBag()
    }
}

