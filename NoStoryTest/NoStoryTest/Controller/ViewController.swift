//
//  ViewController.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 27.04.2024.
//

import UIKit

enum Theme {
    case popular
    case nowPlaying
    case upcoming
    case topRated
    
    var title: String {
        switch self {
        case .nowPlaying: "Now Playing"
        case .popular: "Popular"
        case .upcoming: "Upcoming"
        case .topRated: "Top Rated"
        }
    }
    
    var url: String {
        switch self {
        case .popular:
            return "popular"
        case .nowPlaying:
            return "now_playing"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        }
    }
}

class ViewController: UIViewController {
    
    private let themes: [Theme] = [.popular, .upcoming, .nowPlaying, .topRated]
    
    private var currentTheme = Theme.popular {
        didSet {
            getThemeMovies(theme: currentTheme)
            themeCollectionView.reloadData()
        }
    }
    
    private lazy var labelTheme: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let session = URLSession(configuration: .default)
    lazy var urlComponent: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "ced760785529022f787ac282841dc942")
        ]
        return component
    }()
    
    lazy var themeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(MovieThemeCollectionViewCell.self, forCellWithReuseIdentifier: MovieThemeCollectionViewCell.identifier)
    
        return collection
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 500
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tableView
    }()
    
    var movieData: [List] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(labelTheme)
        view.addSubview(themeCollectionView)
        view.addSubview(tableView)
        labelTheme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        labelTheme.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        themeCollectionView.topAnchor.constraint(equalTo: labelTheme.bottomAnchor, constant: 5).isActive = true
        themeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        themeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        themeCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        		
        tableView.topAnchor.constraint(equalTo: themeCollectionView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.themeCollectionView.allowsMultipleSelection = false

        getThemeMovies(theme: currentTheme)
    }
}

extension ViewController {

    private func getThemeMovies(theme: Theme) {
        urlComponent.path = "/3/movie/\(theme.url)"
        guard let requestUrl = urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [weak self] in
                guard let data = data, error == nil else {
                    // TODO: error handling
                    print(data ?? "")
                    return
                }
                self?.handleResponse(data: data)
            }
        }.resume()
    }
    
    private func handleResponse(data: Data) {
        do {
            let response = try JSONDecoder().decode(ThemeMovie.self, from: data)
            movieData = response.results
            tableView.reloadData()
        } catch {
            // TODO: error handling
            return print(error)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.themeCollectionView.dequeueReusableCell(withReuseIdentifier: MovieThemeCollectionViewCell.identifier, for: indexPath) as? MovieThemeCollectionViewCell else { return UICollectionViewCell() }
        cell.changeTitle(title: themes[indexPath.row].title, isSelected: themes[indexPath.row] == currentTheme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentTheme != themes[indexPath.row] else {
            return
        }
        currentTheme = themes[indexPath.row]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let title = movieData[indexPath.row].title
        let urlImageString = "https://image.tmdb.org/t/p/w500" + movieData[indexPath.row].posterPath
        if let url = URL(string: urlImageString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let movie = MovieTitle(titleLabel: title, image: UIImage(data: data))
                        cell.conf(movie: movie)
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieID = movieData[indexPath.row].id
        movieDetailViewController.onScreenDismiss = { [weak self] in
            self?.currentTheme = .popular
        }
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}



