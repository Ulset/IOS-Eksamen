

let url = URL(string: "https://randomuser.me/api/?results=5000&seed=ios")!
let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
    if let data = data {
        if let personResponse = try? JSONDecoder().decode(PersonApiRespose.self, from: data) {
            
        } else {
            print("Invalid Response")
        }
    } else if let error = error {
        print("HTTP Request Failed \(error)")
    }
})
task.resume()
