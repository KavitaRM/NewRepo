//
//  NetworkManager.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    var dataModel: DataModel?
    
    func fetchRequest(urlRequest: URLRequest, completionHandler: @escaping (Bool, Any?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let request = urlRequest
        
        let  session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                completionHandler(false, error)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Success response.
                        completionHandler(true, data)
                    } else {
                        completionHandler(false, nil)
                    }
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    
    func getListOfPeople(callback : @escaping (DataModel?, NSString?) -> Void) {
        if let url = URL(string: "https://swapi.dev/api/people/") {

            let request = NSURLRequest(url: url)
            fetchRequest(urlRequest: request as URLRequest) { (status, response) in
                if status == true {
                    do {
                        let decoder = JSONDecoder()
                        guard let data = response as? Data else { return }
                        
                        let jsonres = try decoder.decode(DataModel.self, from: data)
                        callback(jsonres, nil)
                    } catch {
                        callback(nil, nil)
                    }
                } else {
                    callback(nil, nil)
                }
            }
        }
    }
    
    func getNextList(urlStr:String, callback : @escaping (DataModel?, NSString?) -> Void) {
//        var components = URLComponents()
//        let queryItemToken = URLQueryItem(name: "page", value: "2")
//        components.queryItems = [queryItemToken]
        
//        let endpoint: URL?
//        var urlComponents = URLComponents(string: "/api/people/\(collectionId)")
//        urlComponents?.queryItems = [URLQueryItem(name: AppModelsKeys.itemIds, value: "\(gemIds)")]
//        endpoint = urlComponents?.url
        
        
        if let url = URL(string: urlStr) {
            let request = NSURLRequest(url: url)
            fetchRequest(urlRequest: request as URLRequest) { (status, response) in
                if status == true {
                    do {
                        let decoder = JSONDecoder()
                        guard let data = response as? Data else { return }
                        
                        let jsonres = try decoder.decode(DataModel.self, from: data)
                        callback(jsonres, nil)
                    } catch {
                        callback(nil, nil)
                    }
                } else {
                    callback(nil, nil)
                }
            }
        }
    }
    
    
    func getPreviousList(callback : @escaping (DataModel?, NSString?) -> Void) {
        if let url = URL(string: dataModel?.previous ?? "http://swapi.dev/api/people/?page=1") {
            let request = NSURLRequest(url: url)
            fetchRequest(urlRequest: request as URLRequest) { (status, response) in
                if status == true {
                    do {
                        let decoder = JSONDecoder()
                        guard let data = response as? Data else { return }
                        
                        let jsonres = try decoder.decode(DataModel.self, from: data)
                        callback(jsonres, nil)
                    } catch {
                        callback(nil, nil)
                    }
                } else {
                    callback(nil, nil)
                }
            }
        }
    }
    
}
