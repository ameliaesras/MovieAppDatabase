//
//  API.swift
//  TMDB
//
//  Created by Amelia Esra S on 01/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation
import Alamofire

class APIServices {
    
    let pathDiscover = "discover/movie"
    var currentPage: Int = 1
    lazy var movie = [Movie]()
    private var endpointDiscoverMovies: URL {
        return URL(string: "\(APIConstants.baseURL)\(pathDiscover)")!
    }
    
    var getMethod: HTTPMethod {
        return .get
    }
    
    var parameters: [String : Any] {
        return ["api_key": APIConstants.apiToken,
                "page": currentPage]
    }
    
    var requestURL: URLRequest {
        var items = [URLQueryItem]()
        var urlComponents = URLComponents(string: endpointDiscoverMovies.absoluteString)
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = items
        var request = URLRequest(url: urlComponents!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = getMethod.rawValue
        print("requestAPI = ",request)
        return request
    }
   
    func fetchData(urlReq: URLRequest, completion : @escaping (Result<MoviesResponse, NetworkError>) -> Void){

        URLSession.shared.dataTask(with: urlReq) { (data, urlResponse, error) in
            print("errorGetMovies",error as Any)

            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }

            guard let httpResponse = urlResponse as? HTTPURLResponse,
                (200 ... 299).contains(httpResponse.statusCode) else {
                completion(.failure(.outOfRange))
                return
            }

            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }

            let jsonDecoder = JSONDecoder()
            let moviesData = try! jsonDecoder.decode(MoviesResponse.self, from: data)
            completion(.success(moviesData))

        }.resume()
    }
    
    func fetchYoutubeLink(urlReq: URLRequest, completion : @escaping (Result<VideoResponse, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: urlReq) { (data, urlResponse, error) in
            print("errorGetMovies",error as Any)

            if let error = error {
                completion(.failure(.apiError(error.localizedDescription)))
                return
            }

            guard let httpResponse = urlResponse as? HTTPURLResponse,
                (200 ... 299).contains(httpResponse.statusCode) else {
                completion(.failure(.outOfRange))
                return
            }

            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }

            let jsonDecoder = JSONDecoder()
            let moviesData = try! jsonDecoder.decode(VideoResponse.self, from: data)
            completion(.success(moviesData))

        }.resume()
    }
    
    //MARK: Get Movie's Review
    @discardableResult func getMovieReview(movieId: Int) async throws -> [Reviews] {
        let endpointURL = URL(string: "\(APIConstants.baseURL)/movie/\(movieId)/reviews?api_key=\(APIConstants.apiToken)")!
        let (data,_) = try await URLSession.shared.data(from: endpointURL)
        let decoded = try JSONDecoder().decode(ReviewResponse.self, from: data)
        print("ReviewResult = ",decoded.results)
        return decoded.results
    }
}
