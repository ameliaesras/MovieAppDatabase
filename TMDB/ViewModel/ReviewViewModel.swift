//
//  ReviewViewModel.swift
//  TMDB
//
//  Created by Amelia Esra Sihombing on 22/03/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import Foundation

struct ReviewCellViewModel {
    var imagePath: String
    var name: String
    var username: String
    var content: String
}

class ReviewViewModel: NSObject {
  
    //MARK: Callback reload the table view cell
    var reloadTableView: (() -> Void)?
    
    var reviewCellViewModels = [ReviewCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //MARK: Create Review Cell Model
    func createReviewCellModel(review: Reviews) -> ReviewCellViewModel {
        let imagePath = review.authorDetails.avatarPath ?? ""
        let name = review.authorDetails.name
        let username = review.authorDetails.username
        let content = review.content
        
        return ReviewCellViewModel(imagePath: imagePath, name: name, username: username, content: content)
    }
    
    //MARK: Fetch Review Data
    func fetchReviewData(reviews: [Reviews]){
        var viewModelReview = [ReviewCellViewModel]()
        for review in reviews {
            viewModelReview.append(createReviewCellModel(review: review))
        }
        reviewCellViewModels = viewModelReview
    }
    
    //MARK: Get Review Cell Model Indexpath
    func getReviewCellModel(at indexPath: IndexPath) -> ReviewCellViewModel {
        return reviewCellViewModels[indexPath.row]
    }
    
    //MARK: Get Reviews
    func getReviews(movieId: Int){
        Task {
            do {
                let reviews = try await APIServices().getMovieReview(movieId: movieId)
                print("reviews==",reviews)
                
                self.fetchReviewData(reviews: reviews)
                
            } catch {
                print("errorGetReviews",error)
            }
        }
    }
}
