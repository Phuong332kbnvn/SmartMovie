//
//  ListMovieResponseEntity.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

// MARK: - List Movie Request Entity
struct ListMovieRequestEntity: Codable {
    let apiKey: String
    let language: String
    let page: Int
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case language
        case page
    }
}
// MARK: - Search Movie Request Entity
struct SearchMovieRequestEntity: Codable {
    let apiKey: String
    let query: String
    let page: Int

    

    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case query
        case page
    }
}
// MARK: - List Movie Response Entity
struct ListMovieResponseEntity: Codable {
    let page: Int
    let results: [MovieEntity]
}

// MARK: - Movie Entity
struct MovieEntity: Codable {
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalTitle: String
    let popularity: Double
    let overview: String
    let releaseDate: String
    let posterPath: String
    let title: String
    let voteAverage: Double
    let voteCount: Int


    private enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id = "id"
        case originalTitle = "original_title"
        case popularity
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"

    }

}

// MARK: - List Genres Request Entity
struct ListGenresRequestEntity: Codable {
    let apiKey: String

    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

// MARK: - Welcome
struct ListGenresResponseEntity: Codable {
    let genres: [GenreEntity]
}

// MARK: - Genre
struct GenreEntity: Codable {
    let id: Int
    let name: String
}

// MARK: - Genre Detail Request Entity
struct GenreDetailRequestEntity: Codable {
    let apiKey: String
    let withGenres: Int
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case withGenres = "with_genres"
    }

}

// MARK: - Movie Detail Request Entity
struct MovieDetailRequestEntity: Codable {
    let apiKey: String


    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

// MARK: - Movie Detail Entity
struct MovieDetailEntity: Codable {
    let backdropPath: String
    let genres: [GenreEntity]
    let homepage: String
    let originalTitle, overview: String
    let posterPath: String
    let id: Int
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let title: String
    let voteAverage: Double

    private enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres = "genres"
        case homepage = "homepage"
        case originalTitle = "original_title"
        case overview = "overview"
        case id = "id"
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case runtime = "runtime"
        case spokenLanguages = "spoken_languages"
        case title = "title"
        case voteAverage = "vote_average"
    }
}

// MARK: - Production Country
struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name = "name"
    }
}

// MARK: - Spoken Language
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - Casts Request Entity
struct ListCastsRequestEntity: Codable {
    let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

// MARK: - Casts Response Entity
struct ListCastsResponseEntity: Codable {
    let cast, crew: [CastEntity]
}

// MARK: - Cast Entity
struct CastEntity: Codable {
    let id: Int
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}


// MARK: - Trailer Request Entity
struct TrailerRequestEntity: Codable {
    let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

// MARK: - Trailer Response Entity
struct TrailerResponseEntity: Codable {
    let results: [TrailerEntity]
}

// MARK: - TrailerEntity
struct TrailerEntity: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}


// MARK: - Cast Detail Request Entity
struct CastDetailRequestEntity: Codable {
    let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

// MARK: - Cast Detail Entity
struct CastDetailEntity: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography, birthday: String
    let gender: Int
    let homepage: String
    let id: Int
    let imdbID, knownForDepartment, name, placeOfBirth: String
    let popularity: Double
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}


