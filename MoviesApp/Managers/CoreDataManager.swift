//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by Jad Rammal on 18/10/2024.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createMovie(title: String, image: String, genre: String, year: Int32, rate: Double) -> MovieEntity {
        let movie = MovieEntity(context: context)
        movie.title = title
        movie.image = image
        movie.genre = genre
        movie.year = year
        movie.rate = rate
        movie.creationDate = Date()
        saveContext()
        return movie
    }

    
    func fetchMovies() -> [MovieEntity] {
        let fetchRequest = MovieEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    
    func editMovie(movie: MovieEntity, newTitle: String, newImage: String, newGenre: String, newYear: Int32, newRate: Double) {
        movie.title = newTitle
        movie.image = newImage
        movie.genre = newGenre
        movie.year = newYear
        movie.rate = newRate
        saveContext()
    }
    
    func removeMovie(movie: MovieEntity) {
        context.delete(movie)
        saveContext()
    }
    
    func movieExists(title: String) -> Bool {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    func addInitialMovies() {
        let initialMovies = [
            ("Sweet girl", "sweetgirl", "Action", 2021, 8.5),
            ("Annabelle", "anabelle", "Horror", 2014, 8.0),
            ("Transcendence", "transcendence", "Action", 2014, 7.0),
            ("IT", "it", "Horror", 2017, 7.5),
            ("Heart of stone", "heartofstone", "Action", 2023, 8.0),
            ("Titanic", "titanic", "Romantic", 1997, 9.5)
        ]
        
        for movie in initialMovies {
            let (title, image, genre, year, rate) = movie
            if !movieExists(title: title) {
                createMovie(title: title, image: image, genre: genre, year: Int32(year), rate: rate)
            }
        }
    }
}
