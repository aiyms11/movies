//
//  MovieListViewController.swift
//  Movie
//
//  Created by Madi Kabdrash on 7/10/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class MovieListViewController: UIViewController {
    
    private var tableView = UITableView()
    private var viewModel: MovieListViewModel!
    private var lastContentOffset: CGFloat = 0
    private var totalCount: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        addTableView()
        viewModel = MovieListViewModel(delegate: self)
        viewModel.fetchMovies()
        viewModel.updateTableData = {
            self.totalCount = self.viewModel.movies.count
            self.tableView.reloadData()
            
        }
        
    }
    
    func addTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.frame.height + scrollView.contentOffset.y
        
        if !viewModel.isFetchInProgress && self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentSize.height == contentHeight{
            totalCount = viewModel.movies.count + 1
            viewModel.fetchMovies()
        } else {
            print("didn't move")
        }
    }

}

extension MovieListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount ?? 0//viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.accessoryType = .disclosureIndicator
        if totalCount ?? 0 != viewModel.movies.count{
            cell.configure(isLoading: true)
        } else {
            cell.configure(movie: viewModel.movies[indexPath.row])
        }
        //cell.textLabel?.text = viewModel.movies[indexPath.row].originalTitle
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = MovieDetail(movie: viewModel.movies[indexPath.row])
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension MovieListViewController: MoviesViewModelDelegate {
    func onFetchFailed(with reason: Error) {
        let title = "Warning"
        let message = "Error: \(reason)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

