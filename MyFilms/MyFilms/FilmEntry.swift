//
//  FilmEntry.swift
//  MyFilms
//
//  Created by Jon Phipps on 08/03/2019.
//  Copyright © 2019 Jon Phipps. All rights reserved.
//

import UIKit

class FilmEntry:NSObject, NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(filmTitle, forKey:PropertyKey.title)
        aCoder.encode(filmYear, forKey:PropertyKey.year)
        aCoder.encode(filmRating, forKey:PropertyKey.rating)
        aCoder.encode(filmImage, forKey:PropertyKey.image)
        aCoder.encode(filmAgeRating, forKey:PropertyKey.ageRating)
        aCoder.encode(filmGenre, forKey:PropertyKey.genre)
        aCoder.encode(filmComments, forKey:PropertyKey.comments)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey:PropertyKey.title) as? String else{
            print("Unable to decode the film title")
            return nil
        }
        guard let year = aDecoder.decodeObject(forKey:PropertyKey.year) as? String else{
            print("Unable to decode the film year")
            return nil
        }
        guard let rating = aDecoder.decodeObject(forKey:PropertyKey.rating) as? String else{
            print("Unable to decode the film rating")
            return nil
        }
        let photo = aDecoder.decodeObject(forKey:PropertyKey.image) as? UIImage
        let ageRating = aDecoder.decodeObject(forKey:PropertyKey.ageRating) as? String
        let genre = aDecoder.decodeObject(forKey:PropertyKey.genre) as? String
        let comments = aDecoder.decodeObject(forKey:PropertyKey.comments) as? String
        
        self.init(title:title, year:year, rating:rating, photo:photo, ageRating:ageRating, genre:genre, comments:comments)
    }
    
    var filmTitle:String
    var filmYear:String
    var filmRating:String
    var filmImage:UIImage?
    var filmAgeRating:String?
    var filmGenre:String?
    var filmComments:String?
    
    init?(title:String, year:String, rating:String, photo:UIImage?, ageRating:String?, genre:String?, comments:String?){
        if(title.isEmpty || year.isEmpty || rating.isEmpty){
            return nil
        }
        
        self.filmTitle = title
        self.filmYear = year
        self.filmRating = rating
        self.filmImage = photo
        self.filmAgeRating = ageRating
        self.filmGenre = genre
        self.filmComments = comments
    }
    
    struct PropertyKey{
        static let title = "title"
        static let year = "year"
        static let rating = "rating"
        static let image = "image"
        static let ageRating = "ageRating"
        static let genre = "genre"
        static let comments = "comments"
    }
    
    static let DocumentsDirectory = FileManager().urls(for:.documentDirectory, in:.userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("filmEntries")
}
