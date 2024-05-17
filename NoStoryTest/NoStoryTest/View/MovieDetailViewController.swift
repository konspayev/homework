//
//  MovieDetailViewController.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 15.05.2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movieData: MovieDetail?
    var movieID = 0
    lazy var scrollMovieDetail: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var genreCollectionView: UICollectionView = {
        let collection = UICollectionView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Movie"
        apiRequest()
    }
    
    func apiRequest() {
        let session = URLSession(configuration: .default)
        lazy var urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme = "https"
            component.host = "api.themoviedb.org"
            component.path = "/3/movie/\(movieID)"
            component.queryItems = [
                URLQueryItem(name: "api_key", value: "ced760785529022f787ac282841dc942")
            ]
            return component
        }()
        
        guard let requestUrl = urlComponent.url else { return }
        let task = session.dataTask(with: requestUrl) {
            data, response, error in
            guard let data = data else { return }
            if let movie = try? JSONDecoder().decode(MovieDetail.self, from: data)
            {
                DispatchQueue.main.async {
                    self.movieData = movie
                    
                }
            }
        }
        task.resume()
    }
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieData?.genres.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
                                    
