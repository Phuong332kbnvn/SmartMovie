//
//  ListMoviesAPIFetcher.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation

protocol ListMoviesAPIFetcherProtocol {
    func fetchListMovies(type: String, page: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void)
    func fetchListMoviesSearch(query: String, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void)
    func fetchListGenres(result: @escaping (Result<ListGenresResponseEntity, NetworkServiceError>) -> Void)
    func fetchGenresDetail(id: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void)
    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, NetworkServiceError>) -> Void)
    func fetchListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, NetworkServiceError>) -> Void)
    func fetchListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void)
    func fetchTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, NetworkServiceError>) -> Void)
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, NetworkServiceError>) -> Void)
    func fetchReview(id: Int, result: @escaping (Result<ReviewResponseEntity, NetworkServiceError>) -> Void)
    func fetchMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, NetworkServiceError>) -> Void)
}

final class ListMoviesAPIFetcher: BaseAPIFetcher {
    override func apiURL(_ apiParams: String? = nil) -> URL? {
        guard let path = apiParams else {
            return nil
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(path)") else {
            return nil
        }
        
        return url
    }
}

extension ListMoviesAPIFetcher: ListMoviesAPIFetcherProtocol {
    
    
    func fetchListMovies(type: String, page: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void) {
        
        guard let url = apiURL(type) else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = ListMovieRequestEntity(apiKey: apiKey, language: "en", page: page)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListMovieResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchListMoviesSearch(query: String, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = SearchMovieRequestEntity(apiKey: apiKey, query: query, page: 1)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListMovieResponseEntity.self)
                    

                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchListGenres(result: @escaping (Result<ListGenresResponseEntity, NetworkServiceError>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = ListGenresRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListGenresResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchGenresDetail(id: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = GenreDetailRequestEntity(apiKey: apiKey, withGenres: id)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListMovieResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }

    func fetchMovieDetail(id: Int, result: @escaping (Result<MovieDetailEntity, NetworkServiceError>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = MovieDetailRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: MovieDetailEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchListCasts(id: Int, result: @escaping (Result<ListCastsResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/credits") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = ListCastsRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListCastsResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchListSimilars(id: Int, result: @escaping (Result<ListMovieResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/similar") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = ListCastsRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ListMovieResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchTrailer(id: Int, result: @escaping (Result<TrailerResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = TrailerRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: TrailerResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchCastDetail(id: Int, result: @escaping (Result<CastDetailEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(id)") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = CastDetailRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: CastDetailEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchReview(id: Int, result: @escaping (Result<ReviewResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = ReviewRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }

            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: ReviewResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
    
    func fetchMovieOfCast(id: Int, result: @escaping (Result<MovieOfCastResponseEntity, NetworkServiceError>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(id)/combined_credits") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }
        
        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        let bodyParams = MovieOfCastRequestEntity(apiKey: apiKey)
        networkService.requestAPI(info: requestInfo, params: bodyParams) { [weak self] dataResult in
            guard let self = self else {
                Logger.debug("PropertySearch API Fetcher nil before complete callback")
                return
            }
            switch dataResult {
            case .success(let data):
                print(data)
                do {
                    let responseEntity = try self.decodeData(data, type: MovieOfCastResponseEntity.self)
                    result(.success(responseEntity))
                } catch {
                    Logger.debug("Unknow error, return decode failed")
                    result(.failure(.noData))
                }
            case .failure(let networkServicesError):
                print(networkServicesError)
            }
        }
    }
}
