//
//  ViewController.swift
//  MyFilms
//
//  Created by Jon Phipps on 08/03/2019.
//  Copyright © 2019 Jon Phipps. All rights reserved.
//

import UIKit

class FilmViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmTitleTextField: UITextField!
    @IBOutlet weak var filmYearTextField: UITextField!
    @IBOutlet weak var filmRatingTextField: UITextField!
    @IBOutlet weak var filmAgeRatingTextField: UITextField!
    @IBOutlet weak var filmGenreTextField: UITextField!
    @IBOutlet weak var filmCommentsTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var verificationMessageLabel: UILabel!
    
    var validTitle = false
    var validYear = false
    var validRating = false
    var film:FilmEntry?
    
    @IBAction func selectImageFromPhotoGallery(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image");
        }
        filmImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddFilmMode = presentingViewController is UINavigationController
        if isPresentingInAddFilmMode{
            dismiss(animated: true, completion: nil)
        }else{
            if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func filmTitleEdited(_ sender: UITextField) {
        if filmTitleTextField.text?.count ?? 0 > 0{
            validTitle = true
        } else {
            validTitle = false
        }
        updateVerificationMessage()
    }
    
    @IBAction func filmYearEdited(_ sender: UITextField) {
        let yearInt = Int(filmYearTextField.text ?? "")
        if filmYearTextField.text?.count ?? 0 == 4 && yearInt != nil {
            validYear = true
        } else {
            validYear = false
        }
        updateVerificationMessage()
    }
    
    let ratings = ["0","1","2","3","4","5"]
    @IBAction func filmRatingEdited(_ sender: UITextField) {
        if ratings.contains(filmRatingTextField.text ?? ""){
            validRating = true
        } else {
            validRating = false
        }
        updateVerificationMessage()
    }
    
    func updateVerificationMessage(){
        if !validTitle || !validYear || !validRating {
            saveButton.isEnabled = false
            
            if !validTitle && !validYear && !validRating {
                verificationMessageLabel.text = "Invalid Title, Year & Rating"
            }
            else if !validTitle && !validYear {
                verificationMessageLabel.text = "Invalid Title & Year"
            }
            else if !validTitle && !validRating {
                verificationMessageLabel.text = "Invalid Title & Rating"
            }
            else if !validYear && !validRating {
                verificationMessageLabel.text = "Invalid Year & Rating"
            }
            else if !validTitle {
                verificationMessageLabel.text = "Invalid Title"
            }
            else if !validYear {
                verificationMessageLabel.text = "Invalid Year"
            }
            else if !validRating {
                verificationMessageLabel.text = "Invaild Rating"
            }
        } else {
            verificationMessageLabel.text = ""
            saveButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let film = film{
            filmTitleTextField.text = film.filmTitle
            filmYearTextField.text = film.filmYear
            filmRatingTextField.text = film.filmRating
            filmImageView.image = film.filmImage
            filmAgeRatingTextField.text = film.filmAgeRating
            filmGenreTextField.text = film.filmGenre
            filmCommentsTextField.text = film.filmComments
            
            validTitle = true
            validYear = true
            validRating = true
            
            self.title = "Edit Film"
        }
        updateVerificationMessage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button===saveButton else{
            return
        }
        
        let title = filmTitleTextField.text ?? ""
        let year = filmYearTextField.text ?? ""
        let rating = filmRatingTextField.text ?? ""
        let photo = filmImageView.image
        let ageRating = filmAgeRatingTextField.text ?? ""
        let genre = filmGenreTextField.text ?? ""
        let comments = filmCommentsTextField.text ?? ""
        
        film = FilmEntry(title:title, year:year, rating:rating, photo:photo, ageRating:ageRating, genre:genre, comments:comments)
    }
}
