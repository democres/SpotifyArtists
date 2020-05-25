//
//  MainSectionController.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import IGListKit

class MainSectionController: ListSectionController {
    var artist: Artist?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
}

// MARK: - Data Provider
extension MainSectionController {
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: ArtistViewCell = collectionContext?.dequeueReusableCell(withNibName: "ArtistViewCell", bundle: Bundle.main, for: self, at: index) as! ArtistViewCell
        
        cell.update(with: artist)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        artist = object as? Artist
    }
    
    override func didSelectItem(at index: Int) {
      collectionContext?.performBatch(animated: true, updates: { batchContext in
        batchContext.reload(self)
      }, completion: nil)
    }
}
