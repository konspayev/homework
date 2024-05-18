//
//  ViewController.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 27.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let themes = ["Popular", "Now Playing", "Upcoming", "Top Rated"]
    
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
    
    lazy var theme: UICollectionView = {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = IndexPath(item: 0, section: 0)
        collectionView(self.theme, didSelectItemAt: index)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = IndexPath(item: 0, section: 0)
        theme.selectItem(at: index, animated: false, scrollPosition: [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(labelTheme)
        view.addSubview(theme)
        view.addSubview(tableView)
        labelTheme.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        labelTheme.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        theme.topAnchor.constraint(equalTo: labelTheme.bottomAnchor, constant: 5).isActive = true
        theme.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        theme.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        theme.heightAnchor.constraint(equalToConstant: 30).isActive = true
        		
        tableView.topAnchor.constraint(equalTo: theme.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.theme.allowsMultipleSelection = false
    }
    
//    func apiRequest() {
//        guard let requestUrl = urlComponent.url else { return }
//        let task = session.dataTask(with: requestUrl) {
//            data, response, error in
//            guard let data = data else { return }
//            if let movie = try? JSONDecoder().decode(Movie.self, from: data)
//            {
//                DispatchQueue.main.async {
//                    self.movieData = movie.results
//                    self.tableView.reloadData()
//                }
//            }
//        }
//        task.resume()
//    }
}

extension ViewController {
    func apiRequests(_ path: String) {
        switch path {
        case "Popular":
            getPopular()
        case "Now Playing":
            getNowPlaying()
        case "Upcoming":
            getUpcoming()
        case "Top Rated":
            getTopRated()
        default:
            print("Error: ")
        }
    }
    
    func getPopular() {
        self.urlComponent.path = "/3/movie/popular"
        guard let requestUrl = urlComponent.url else { return }

        self.session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    print(data ?? "")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Popular.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getNowPlaying() {
        self.urlComponent.path = "/3/movie/now_playing"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(NowPlaying.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getUpcoming() {
        self.urlComponent.path = "/3/movie/upcoming"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Upcoming.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
    func getTopRated() {
        self.urlComponent.path = "/3/movie/top_rated"

        guard let requestUrl = self.urlComponent.url else { return }

        session.dataTask(with: requestUrl) { data, response, error in
            DispatchQueue.main.async(flags: .barrier) { [self] in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try JSONDecoder().decode(TopRated.self, from: data)
                    self.movieData = response.results
                    self.tableView.reloadData()
                    return
                } catch {
                    return print(error)
                }
            }
        }.resume()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.theme.dequeueReusableCell(withReuseIdentifier: MovieThemeCollectionViewCell.identifier, for: indexPath) as? MovieThemeCollectionViewCell else { return UICollectionViewCell() }
        cell.labelThemeCollectionCell.text = themes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieThemeCollectionViewCell {
            apiRequests(cell.labelThemeCollectionCell.text ?? "")
            cell.contentView.backgroundColor = .red
            cell.isSelected = true
            cell.labelThemeCollectionCell.textColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MovieThemeCollectionViewCell {
            cell.contentView.backgroundColor = .systemGray5
            cell.isSelected = false
            cell.labelThemeCollectionCell.textColor = .black
        }
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
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}



