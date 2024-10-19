//
//  ViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 12/10/2024.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var data: [MovieEntity] = [] // Update to use MovieEntity from CoreData
    
    @IBOutlet weak var moviesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTable.dataSource = self
        moviesTable.delegate = self
        
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        moviesTable.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        
        CoreDataManager.shared.addInitialMovies()
        
        loadMovies()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMovieAdded(_:)), name: NSNotification.Name("MovieAdded"), object: nil)
    }
    
    private func loadMovies() {
        data = CoreDataManager.shared.fetchMovies()
        moviesTable.reloadData()
    }
    
    @objc func onMovieAdded(_ notification: Notification) {
        if let movie = notification.object as? MovieEntity {
            data.insert(movie, at: 0)
            moviesTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = data[indexPath.row]
        let cell = moviesTable.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        if let imageData = Data(base64Encoded: movie.image ?? ""), let decodedImage = UIImage(data: imageData) {
            cell.movieImage.image = decodedImage
        } else if let assetImage = UIImage(named: movie.image ?? "") {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieToDelete = data[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Movie", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                CoreDataManager.shared.removeMovie(movie: movieToDelete) // Delete from Core Data
                self.data.remove(at: indexPath.row) // Remove from local data array
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
}

