//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 12/10/2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            movieTitle.text = movie.title
            movieImage.image = UIImage(named: movie.image)
            movieGenre.text = movie.genre
            movieRate.text = "⭐️ \(movie.rate)"
            movieYear.text = "\(movie.year)"
        }
    }
}
