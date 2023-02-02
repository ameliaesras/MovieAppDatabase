//
//  ViewController.swift
//  TMDB
//
//  Created by Amelia Esra S on 31/01/23.
//  Copyright © 2023 Amelia Esra S. All rights reserved.
//

import UIKit

class MoviesController: UIViewController {

    @IBOutlet var moviesCollectionView: UICollectionView!
    
    private var moviesViewModel: MoviesViewModel!
    private var movies : [Movie] = []
    lazy var sizeImage = "original"
    lazy var currentPage = 1
    lazy var totalPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI(){
        moviesCollectionView.register(UINib(nibName: "MoviesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MoviesCollectionCell")
        moviesViewModel = MoviesViewModel()
        moviesViewModel.bindMoviesViewModelToController = {
            self.movies = self.moviesViewModel.moviesResponse.results
            self.totalPages = self.moviesViewModel.moviesResponse.totalPages
            
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    func loadMoviesInNextPage(){
        moviesViewModel.increasePage(totalPage: totalPages)
    }
    
    func loadMoviesInBeforePage(){
        moviesViewModel.decreasePage(totalPage: totalPages)
    }
}

extension MoviesController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionCell", for: indexPath) as! MoviesCollectionCell
        
        item.setData(movie: movies[indexPath.item], size: sizeImage)
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (moviesCollectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMovieController = storyboard?.instantiateViewController(withIdentifier: "DetailMovieController") as! DetailMovieController
        
        detailMovieController.movieId = movies[indexPath.item].id
        detailMovieController.titleMovie = movies[indexPath.item].title ?? ""
        detailMovieController.releaseDate = movies[indexPath.item].releaseDate ?? ""
        detailMovieController.rating = movies[indexPath.item].rating
        detailMovieController.overview = movies[indexPath.item].overview ?? ""
        detailMovieController.totalReview = movies[indexPath.item].voteCount
        
        self.navigationController?.pushViewController(detailMovieController, animated: true)
    }
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        print("maximumOffset_currentOffset = ",maximumOffset - currentOffset)
        if maximumOffset - currentOffset <= 10 {
            loadMoviesInNextPage()
        }
    }
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("offsetCollection=",moviesCollectionView.contentOffset.y)
        if moviesCollectionView.contentOffset.y == 0 {
            loadMoviesInBeforePage()
        }
    }
}

