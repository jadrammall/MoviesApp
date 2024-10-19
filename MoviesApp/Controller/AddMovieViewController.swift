//
//  AddMovieViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 17/10/2024.
//

import UIKit

class AddMovieViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var movieYear: UITextField!
    @IBOutlet weak var movieRate: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var addUpdateButton: UIButton!
    
    var selectedImageString: String = ""
    var movieToEdit: MovieEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(movieTitle, placeholder: "Title")
        setupTextField(movieGenre, placeholder: "Genre")
        setupTextField(movieRate, placeholder: "Rate")
        setupTextField(movieYear, placeholder: "Year")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(tapGesture)
        
        let tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapOutsideGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideGesture)
        
        if let movie = movieToEdit {
                movieTitle.text = movie.title
                movieGenre.text = movie.genre
                movieRate.text = "\(movie.rate)"
                movieYear.text = "\(movie.year)"
                
                if let imageData = movie.image, !imageData.isEmpty {
                    if let decodedImageData = Data(base64Encoded: imageData),
                       let decodedImage = UIImage(data: decodedImageData) {
                        movieImage.image = decodedImage
                    } else if let assetImage = UIImage(named: imageData) {
                        movieImage.image = assetImage
                    } else {
                        movieImage.image = UIImage(systemName: "photo.badge.plus")
                    }
                } else {
                    movieImage.image = UIImage(systemName: "photo.badge.plus")
                }
                
                addUpdateButton.setTitle("Update Movie", for: .normal)
            } else {
                addUpdateButton.setTitle("Add Movie", for: .normal)
            }
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    @IBAction func onAddUpdateButtonTap(_ sender: Any) {
        guard let title = movieTitle.text, !title.isEmpty,
              let genre = movieGenre.text, !genre.isEmpty,
              let yearText = movieYear.text,
              let year = Int32(yearText),
              let rateText = movieRate.text,
              let rate = Double(rateText)
        else {
            showAlert(message: "All fields are required.")
            return
        }
        
        if let movie = movieToEdit {
            CoreDataManager.shared.editMovie(movie: movie, newTitle: title, newImage: selectedImageString, newGenre: genre, newYear: year, newRate: rate)
            NotificationCenter.default.post(name: NSNotification.Name("MovieUpdated"), object: movie)
        } else {
            let newMovie = CoreDataManager.shared.createMovie(title: title, image: selectedImageString, genre: genre, year: year, rate: rate)
            NotificationCenter.default.post(name: NSNotification.Name("MovieAdded"), object: newMovie)
        }
        
        dismiss(animated: true)
    }
    
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            movieImage.image = selectedImage
            
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                selectedImageString = imageData.base64EncodedString()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
