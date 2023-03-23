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
   
    private var apiService = APIServices()
    lazy var videoKey = ""
    
    lazy var reviewModel = {
        ReviewViewModel()
    }()
    var reviews : [Reviews] = []
    
    @IBOutlet var youtubePreview: YTPlayerView!
    @IBOutlet var labelRatingNumber: UILabel!
    @IBOutlet var labelVoteCount: UILabel!
    @IBOutlet var labelReleaseDate: UILabel!
    @IBOutlet var labelTitleMovie: UILabel!
    @IBOutlet var txtVewDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
        
        print("movieId",movieId)
        getLinkYoutubeTrailer(movieId: movieId)
        setupDetailMovie()
        reviewInitViewModel()
    }

    
    //MARK: Get Link Youtube Trailer
    func getLinkYoutubeTrailer(movieId: Int) {
        let endpointURL = URL(string: "\(APIConstants.baseURL)/movie/\(movieId)/videos?api_key=\(APIConstants.apiToken)")!
       
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
    
    func playVideoTrailer(key: String){
        youtubePreview.load(withVideoId: key)
    }
    
    func setupDetailMovie(){
        labelRatingNumber.text = "\(rating)"
        labelVoteCount.text = "\(totalReview) reviews"
        labelReleaseDate.text = releaseDate
        labelTitleMovie.text = titleMovie
        txtVewDescription.text = overview
        print("descriptionDetail==",overview)
    }
   
    //MARK: Init Review View Model
    func reviewInitViewModel() {
        reviewModel.getReviews(movieId: movieId)
        reviewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                if self?.reviewModel.reviewCellViewModels.count == 0 {
                    self?.tableViewHeightConst.constant = 0
                } else {
                    self?.tableViewHeightConst.constant = 464
                }
                self?.tableView.layoutIfNeeded()
                self?.tableView.reloadData()
            }
        }
        
    }
}

extension DetailMovieController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewModel.reviewCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.identifier, for: indexPath) as? ReviewsTableViewCell else {fatalError("xib does not exists")}
        let cellVM = reviewModel.getReviewCellModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}

extension Movie {
    var rating: CGFloat {
        return CGFloat(voteAverage/2)
    }
}

