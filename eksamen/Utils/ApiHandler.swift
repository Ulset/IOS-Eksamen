//
//  ApiHandler.swift
//  eksamen
//
//  Created by Sander Ulset on 27/10/2021.
//

import Foundation
import UIKit
import CoreData

struct PersonApiRespose: Decodable {
    //This is just for the API call, since it returns a list
    let results: [Person]
}

struct ApiHandler { 
    func getPersonsFromApi(finished: (([Person])->Void)?){
        let defaults = UserDefaults.standard
        let seed = defaults.string(forKey: "seed") ?? "ios"
        let url = URL(string: "https://randomuser.me/api/?results=100&seed=\(seed)&nat=no")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            print("Data henting")
            if let data = data {
                if let personResponse = try? JSONDecoder().decode(PersonApiRespose.self, from: data) {
                    print("Ferdig")
                    finished?(personResponse.results)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        })
        task.resume()
    }
    
    static private func getImageFromCache(url: String, context: NSManagedObjectContext) -> UIImage?{
        let fetchReq = PictureCache.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "url = %@", url)
        let cachedImage = try! context.fetch(fetchReq)
        return cachedImage.count>0 ? UIImage(data: cachedImage[0].pictureData!) : nil
    }
    
    static private func setImageCache(url: String, data: Data, context: NSManagedObjectContext) {
        DispatchQueue.global().async {
            let newCache = PictureCache(context: context)
            newCache.url = url
            newCache.pictureData = data
            context.perform {
                // Ensure context saves in the correct thread
                try? context.save()
            }
        }
    }
    
    static func getImageFromURL(url: String, finished: ((UIImage) -> Void)?){
        // Checks if the image is already in cache, if not tries to download it.
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        DispatchQueue.global().async {
            let url_format = URL(string: url)
            let image: UIImage
            if let cachedImage = self.getImageFromCache(url: url, context: context) {
                image = cachedImage
            }else if let data = try? Data(contentsOf: url_format!), let imageFromApi = UIImage(data: data){
                image = imageFromApi
                self.setImageCache(url: url, data: data, context: context)
            } else {
                // If miss on cache and cant download for any reason give back a standard image.
                // This proboably shouldt be handled here, but im just fetching profilepictures in this app anyway.
                image = UIImage(named: "profilePicture")!
            }
            
            DispatchQueue.main.async {
                finished?(image)
            }
        }
    }
}
