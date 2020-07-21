//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Madi Kabdrash on 7/20/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MoviesViewModelDelegate: class {
  func onFetchFailed(with reason: Error)
}

class MovieListViewModel {
    private weak var delegate: MoviesViewModelDelegate?
    var movies:[Movie] = []
    private var movieServise = MovieService()
    var updateTableData: (() -> Void)?
    private var currentPage = 1
    var isFetchInProgress = false
    
    init(delegate: MoviesViewModelDelegate) {
      self.delegate = delegate
    }
    
    func fetchMovies(){
        guard !isFetchInProgress else {
          return
        }
        isFetchInProgress = true
        movieServise.getMovies(page: currentPage, movieType: "movie/popular") { [weak self] (result) in
            switch result {
            case .success(let movies):
                self?.isFetchInProgress = false
                self?.currentPage += 1
                self?.movies.append(contentsOf: movies)
                self?.updateTableData?()
            case .failure(let error):
                self?.isFetchInProgress = false
                self?.delegate?.onFetchFailed(with: error)
            }
        }
    }
}
