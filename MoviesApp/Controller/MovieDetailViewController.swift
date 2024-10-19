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
    var movie: MovieEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            movieTitle.text = movie.title
            if let imageData = Data(base64Encoded: movie.image!), let decodedImage = UIImage(data: imageData) {
                movieImage.image = decodedImage
            } else if let assetImage = UIImage(named: movie.image!) {
                movieImage.image = assetImage
            } else {
                movieImage.image = UIImage(named: "placeholderImage")
            }
            movieGenre.text = movie.genre
            movieRate.text = "⭐️ \(movie.rate)"
            movieYear.text = "\(movie.year)"
        }
    }
}
