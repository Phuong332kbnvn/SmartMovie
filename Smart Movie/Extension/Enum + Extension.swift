//
//  File.swift
//  Smart Movie
//
//  Created by Phuong on 15/03/2022.
//

import Foundation

enum Mode {
    case grid
    case list
}

final class StyleCell {
    static var mode: Mode = .grid
}

enum PageType {
    case movies
    case popular
    case topRated
    case upcomming
    case nowPlaying
}

enum ArtistCategoryType {
    case infor
    case favorite
    case recent
    case logout
}
