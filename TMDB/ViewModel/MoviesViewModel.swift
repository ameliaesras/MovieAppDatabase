//
//  MoviesViewModel.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation

class MoviesViewModel: NSObject {
    
    private var apiService : APIServices!
    var moviesResponse : MoviesResponse! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    var videoResponse : VideoResponse! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
  
    lazy var movie : [Movie] = []
    lazy var isPaginationOn = false
    lazy var currentPage = 1
    lazy var totalPages = 1
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    var parameters: [String : Any] {
        return ["api_key": APIConstants.apiToken,
                "page": currentPage]
    }
    
    override init() {
        super.init()
        self.apiService = APIServices()
        getDiscoverMoviesData()
    }
    
    func getDiscoverMoviesData() {
        self.apiService.fetchData(urlReq: self.apiService.requestURL) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.moviesResponse = data
                self.totalPages = self.moviesResponse.totalPages
                for item in data.results {
                    self.movie.append(item)
                }
            case .failure(let error):
                print("Error to get discover movies =", error)
            }
        }
    }
    
    @discardableResult func increasePage(totalPage: Int) -> Int {
        if currentPage <= totalPages {
            currentPage += 1
            loadMoviesNextPage()
        }
        print("increasePage ==",currentPage)
        return currentPage
    }
    
    @discardableResult func decreasePage(totalPage: Int) -> Int {
        if currentPage <= totalPages {
            currentPage -= 1
            loadMoviesBeforePage()
        }
        print("decreasePage ==",currentPage)
        return currentPage
    }
    
    func loadMoviesNextPage() {
        self.apiService.fetchData(urlReq: urlLoadMoreMovies, completion: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                self.moviesResponse = data

                print("currentmoviesResponse == ",self.moviesResponse.results.count)
            case .failure(let error):
                print("Error to load more movies =", error)
            }
        })
    }
    
    func loadMoviesBeforePage() {
        self.apiService.fetchData(urlReq: urlLoadMoreMovies, completion: { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                self.moviesResponse = data

                print("currentmoviesResponse == ",self.moviesResponse.results.count)
            case .failure(let error):
                print("Error to load more movies =", error)
            }
        })
    }
    
    var urlLoadMoreMovies : URLRequest {
        let endpoint = "\(APIConstants.baseURL)\(apiService.pathDiscover)"
        var items = [URLQueryItem]()
        var urlComponents = URLComponents(string: endpoint)
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = items
        var request = URLRequest(url: urlComponents!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = self.apiService.getMethod.rawValue
        print("requestAPILoad = ",request)
        return request
    }
    
    func getLinkYoutubeTrailer(movieId: Int) {
        let endpointURL = URL(string: "\(APIConstants.baseURL)/movie/\(movieId)/videos?api_key=\(APIConstants.apiToken)")!
        print("endpointLink",endpointURL)
        var request = URLRequest(url: endpointURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = self.apiService.getMethod.rawValue
        
        self.apiService.fetchYoutubeLink(urlReq: request, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.videoResponse = data
            case .failure(let error):
                print("Error to get link youtube =", error)
            }
        })
    }
    
}
