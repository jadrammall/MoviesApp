//
//  ViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 12/10/2024.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var data: [Movie] = [
        Movie(title: "Titanic", image: "titanic", genre: "Romantic", year: 1997, rate: 9.5),
        Movie(title: "Heart of stone", image: "heartofstone", genre: "Action", year: 2023, rate: 8.0),
        Movie(title: "IT", image: "it", genre: "Horror", year: 2017, rate: 7.5),
        Movie(title: "Transcendence", image: "transcendence", genre: "Action", year: 2014, rate: 7.0),
        Movie(title: "Annabelle", image: "anabelle", genre: "Horror", year: 2014, rate: 8.0),
        Movie(title: "Sweet girl", image: "sweetgirl", genre: "Action", year: 2021, rate: 8.5)
    ]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = data[indexPath.row]
        let cell = moviesTable.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        if let imageData = Data(base64Encoded: movie.image), let decodedImage = UIImage(data: imageData) {
            cell.movieImage.image = decodedImage
        } else if let assetImage = UIImage(named: movie.image) {
            cell.movieImage.image = assetImage
        } else {
            cell.movieImage.image = UIImage(named: "placeholderImage")
        }
        cell.movieTitle.text = movie.title
        cell.movieGenre.text = movie.genre
        cell.movieRate.text = "⭐️ \(movie.rate)"
        cell.movieYear.text = "\(movie.year)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = data[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detailVC.movie = selectedMovie
            present(detailVC, animated: true)
        }
    }
    
    @IBOutlet weak var moviesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesTable.dataSource = self
        moviesTable.delegate = self
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        moviesTable.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        
        // Add observer for the "MovieAdded" notification
        NotificationCenter.default.addObserver(self, selector: #selector(onMovieAdded(_:)), name: NSNotification.Name("MovieAdded"), object: nil)
    }
    
    @objc func onMovieAdded(_ notification: Notification) {
        if let movie = notification.object as? Movie {
            data.insert(movie, at: 0)
            moviesTable.reloadData()
        }
    }
    
}

