//
//  File.swift
//  Smart Movie
//
//  Created by Phuong on 15/03/2022.
//

import Foundation

// MARK: - Style Cell
enum Mode {
    case grid
    case list
}

final class StyleCell {
    static var mode: Mode = .grid
}

// MARK: - Page Type
enum PageType {
    case movies
    case popular
    case topRated
    case upcomming
    case nowPlaying
}

// MARK: - Artist Category Type
enum ArtistCategoryType {
    case infor
    case favorite
    case recent
    case logout
}

// MARK: - Movie Type
enum MovieType: String {
    case popular = "popular"
    case topRate = "top_rated"
    case upcomming = "upcoming"
    case nowPlaying = "now_playing"
}
