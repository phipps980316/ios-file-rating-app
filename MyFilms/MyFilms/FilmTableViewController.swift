//
//  FilmTableViewController.swift
//  MyFilms
//
//  Created by Jon Phipps on 08/03/2019.
//  Copyright © 2019 Jon Phipps. All rights reserved.
//

import UIKit

class FilmTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filmsArray:[FilmEntry] = []
    var filteredFilms:[FilmEntry] = []
    
    struct tableSection{
        let letter:Character
        var count:Int
    }
    var sectionsArray:[tableSection] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedFilms = loadFilms(){
            filmsArray = savedFilms
            filmsArray.sort(by: {($0.filmTitle, $0.filmYear) < ($1.filmTitle, $1.filmYear)})
            filteredFilms = filmsArray
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String) {
        if searchText.isEmpty{
            filteredFilms = filmsArray
        }else{
            filteredFilms = filmsArray.filter({film -> Bool in
                guard let text = searchBar.text else {return false}
                return film.filmTitle.lowercased().contains(text.lowercased())
            })
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        sectionsArray.removeAll()
        
        var initialCharacter:Character = " "
        for i in 0 ..< filteredFilms.count{
            if let filmFirstLetter = filteredFilms[i].filmTitle.first{
                if filmFirstLetter != initialCharacter{
                    sectionsArray.append(tableSection(letter: filmFirstLetter, count: 1))
                    initialCharacter = filmFirstLetter
                }else{
                    sectionsArray[sectionsArray.count-1].count += 1
                }
            }
        }
        return sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionsArray[section].count
    }

    func getSectionIndex(indexPath: IndexPath) -> Int {
        var cumulativeRecords = 0
        for i in 0 ..< indexPath.section{
            cumulativeRecords += sectionsArray[i].count
        }
        return cumulativeRecords+indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmEntryCell", for: indexPath) as? FilmTableViewCell else{
            fatalError("The dequeued cell is not an instance of FilmTableViewCell")
        }

        let sectionIndex = getSectionIndex(indexPath: indexPath)
        // Configure the cell...
        let film = filteredFilms[sectionIndex]
        cell.filmTitleLabel.text = "Title: " + film.filmTitle
        cell.filmYearLabel.text = "Year: " + film.filmYear
        cell.filmRatingLabel.text = "Rating: " + film.filmRating
        cell.filmImageView.image = film.filmImage

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let sectionIndex = getSectionIndex(indexPath: indexPath)
            
            let deletedFilm = filteredFilms[sectionIndex]
            filteredFilms.remove(at: sectionIndex)
            
            for i in sectionIndex ..< filmsArray.count{
                if(filmsArray[i].filmTitle == deletedFilm.filmTitle && filmsArray[i].filmYear == deletedFilm.filmYear && filmsArray[i].filmRating == deletedFilm.filmRating){
                    filmsArray.remove(at: i)
                    break
                }
            }
            
            saveFilms()
            tableView.reloadData()
        }
    }
 
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "AddFilm":
            break
        case "ViewFilm":
            guard let filmViewController = segue.destination as? FilmViewController else{
                fatalError("Unexpected Destination")
            }
            guard let indexPath = tableView.indexPathForSelectedRow else{
                fatalError("The selected cell is not being displayed by the table")
            }
            let sectionIndex = getSectionIndex(indexPath: indexPath)
            
            let selectedFilm = filteredFilms[sectionIndex]
            filmViewController.film = selectedFilm
            break
        default:
            fatalError("Unexpected Segue")
        }
    }
    
    @IBAction func unwindToFilms(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? FilmViewController, let film = sourceViewController.film{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                
                let sectionIndex = getSectionIndex(indexPath: selectedIndexPath)
                
                let selectedFilm = filteredFilms[sectionIndex]
                filteredFilms[sectionIndex] = film
                
                for i in sectionIndex ..< filmsArray.count{
                    if(filmsArray[i].filmTitle == selectedFilm.filmTitle && filmsArray[i].filmYear == selectedFilm.filmYear && filmsArray[i].filmRating == selectedFilm.filmRating){
                        filmsArray[i] = film
                        break
                    }
                }
                filmsArray.sort(by: {($0.filmTitle, $0.filmYear) < ($1.filmTitle, $1.filmYear)})
                filteredFilms = filmsArray
                tableView.reloadData()
                searchBar.text = ""
            }else{
                filmsArray.append(film)
                filteredFilms.append(film)
                filmsArray.sort(by: {($0.filmTitle, $0.filmYear) < ($1.filmTitle, $1.filmYear)})
                filteredFilms = filmsArray
                tableView.reloadData()
                searchBar.text = ""
            }
            saveFilms()
        }
    }
    
    override func tableView(_ tableView:UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sectionsArray[section]
        return String(section.letter)
    }
    
    private func saveFilms(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(filmsArray, toFile: FilmEntry.ArchiveURL.path)
        if(!isSuccessfulSave){
            print("Save Unsuccessful")
        }
    }
    
    private func loadFilms() -> [FilmEntry]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile:FilmEntry.ArchiveURL.path) as? [FilmEntry];
    }
}
