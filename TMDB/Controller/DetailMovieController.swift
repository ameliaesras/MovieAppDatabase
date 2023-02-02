//
//  DetailMovieController.swift
//  TMDB
//
//  Created by Amelia Esra S on 02/02/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import UIKit
import SwiftyJSON
import youtube_ios_player_helper

class DetailMovieController: UIViewController {
    
    lazy var movieId : Int = 0
    lazy var releaseDate = ""
    lazy var totalReview : Int = 0
    lazy var rating : Double = 0.0
    lazy var titleMovie = ""
    lazy var overview = ""
    
    private var moviesViewModel: MoviesViewModel!
    private var apiService = APIServices()
    lazy var videoKey = ""
    
    @IBOutlet var youtubePreview: YTPlayerView!
    @IBOutlet var labelRatingNumber: UILabel!
    @IBOutlet var labelVoteCount: UILabel!
    @IBOutlet var labelReleaseDate: UILabel!
    @IBOutlet var labelTitleMovie: UILabel!
    @IBOutlet var txtVewDescription: UITextView!
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                print("dataVideo",data)
                for item in data.results {
                    if item.type.lowercased() == "trailer"{
                        self.videoKey = item.key
                    }
                }
                
                DispatchQueue.main.async {
                    self.youtubePreview.load(withVideoId: self.videoKey)
                }
            case .failure(let error):
                print("Error to get link youtube =", error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("movieId",movieId)
        getLinkYoutubeTrailer(movieId: movieId)
        setupDetailMovie()
    }
    
    func playVideoTrailer(key: String){
        youtubePreview.load(withVideoId: key)
    }
    
    func setupDetailMovie(){
        labelRatingNumber.text = "\(rating)"
        labelVoteCount.text = "\(totalReview) reviews"
        labelReleaseDate.text = releaseDate
        labelTitleMovie.text = titleMovie
        txtVewDescription.text = overview
    }
}

extension Movie {
    var rating: CGFloat {
        return CGFloat(voteAverage/2)
    }
}

