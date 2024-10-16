//
//  AddMovieViewController.swift
//  MoviesApp
//
//  Created by Jad Rammal on 17/10/2024.
//

import UIKit

class AddMovieViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var movieYear: UITextField!
    @IBOutlet weak var movieRate: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    
    var selectedImageString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func onAddMovieButtonTap(_ sender: Any) {
        guard let title = movieTitle.text, !title.isEmpty,
              let genre = movieGenre.text, !genre.isEmpty,
              let yearText = movieYear.text,
              let year = Int(yearText),
              let rateText = movieRate.text,
              let rate = Double(rateText)
        else {
            showAlert(message: "All fields are required.")
            return
        }
        
        let movie = Movie(title: title, image: selectedImageString, genre: genre, year: year, rate: rate)
        
        data.insert(movie, at: 0)
        clearAllFields()
        
    }
    
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
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
    
    private func clearAllFields() {
        movieTitle.text = ""
        movieGenre.text = ""
        movieYear.text = ""
        movieRate.text = ""
        movieImage.image = nil
        selectedImageString = ""
    }
    
}
