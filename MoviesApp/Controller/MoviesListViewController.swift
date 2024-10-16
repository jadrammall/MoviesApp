//
//  ViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 12/10/2024.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesTable.reloadData()
    }
    
}

