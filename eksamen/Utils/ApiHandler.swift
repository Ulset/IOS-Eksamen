//
//  ApiHandler.swift
//  eksamen
//
//  Created by Sander Ulset on 27/10/2021.
//

import Foundation
import UIKit

struct ApiHandler {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    struct PersonApiRespose: Decodable {
        //This is just for the API call, since it returns a list
        let results: [Person]
    }
    
    func getPersonsFromApi(finished: (([Person])->Void)?){
        let url = URL(string: "https://randomuser.me/api/?results=100&seed=ios&nat=NO")!
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
    
    static func getImageFromURL(url: String, finished: @escaping (UIImage) -> Void){
        DispatchQueue.global().async {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                finished(UIImage(data: data!)!)
            }
        }
    }
}
