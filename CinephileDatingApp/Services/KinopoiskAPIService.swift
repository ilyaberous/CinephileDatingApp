//
//  FilmsAPIService.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.05.2024.
//

import Foundation

class KinopoiskAPIService {
    
    static var shared = KinopoiskAPIService()
    
    private init() {}
    
    let session = URLSession(configuration: .default)
    
    func getMovies(for query: String,completion:@escaping([Film]?,Error?)->Void){
        let url = URL(string: "https://api.kinopoisk.dev/v1.4/movie/search")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "page", value: "1"),
          URLQueryItem(name: "limit", value: "12"),
          URLQueryItem(name: "query", value: query),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "X-API-KEY": "KQ2FP7H-9RZ4GDX-QW8WCK6-EWNMBH0"
        ]
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG: Requeting api with : \(error.localizedDescription)")
                completion(nil,error)
            }
            if let data = data {
                do{
                    let decodedData = try JSONDecoder().decode(SearchFilmResponse.self, from: data)
                    completion(decodedData.docs, nil)
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
}
