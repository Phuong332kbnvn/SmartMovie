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
        let bodyParams = ListMovieRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06", language: "en", page: page)
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
        let bodyParams = SearchMovieRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06", query: query, page: 1)
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
        let bodyParams = ListGenresRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
        let bodyParams = GenreDetailRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06", withGenres: id)
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
        let bodyParams = MovieDetailRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
        let bodyParams = ListCastsRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
        let bodyParams = ListCastsRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
        let bodyParams = TrailerRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
//    https://api.themoviedb.org/3/person/25540?api_key=d5b97a6fad46348136d87b78895a0c06
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(id)") else {
            Logger.debug("URL nil")
            result(.failure(.noData))
            return
        }

        let requestInfo = RequestInfo(urlInfo: url, httpMethod: .get)
        // API key get from keychain
        let bodyParams = CastDetailRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
        let bodyParams = ReviewRequestEntity(apiKey: "d5b97a6fad46348136d87b78895a0c06")
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
}
