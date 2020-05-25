//
//  NSObject+ListDiffable.swift
//  SpotifyArtist
//
//  Created by David Figueroa on 25/05/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import IGListKit

// MARK: - ListDiffable
extension NSObject: ListDiffable {
  public func diffIdentifier() -> NSObjectProtocol {
    return self
  }

  public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return isEqual(object)
  }
}
