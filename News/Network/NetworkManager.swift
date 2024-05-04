//
//  NetworkManager.swift
//  News
//
//  Created by Andrii Stetsenko on 28.02.2024.
//

import Foundation

struct Secret {
    static let apiKey: String = "dea78b835052487e9dc1b21680c1a1da"
}

struct Constants {
    static let baseURL = "https://newsapi.org/v2"
    
    static let topHeadlinesString = "\(Constants.baseURL)/top-headlines?country=ua&apiKey=\(Secret.apiKey)"
    static let topHeadlinesByPageString = "\(Constants.baseURL)/top-headlines?country=ua&apiKey=\(Secret.apiKey)&page="
    static let topHeadlinesByCategoryString = "\(Constants.baseURL)/top-headlines?country=ua&apiKey=\(Secret.apiKey)&category="
    static let uaSportsString = "\(Constants.baseURL)/top-headlines?country=ua&category=sports&apiKey=\(Secret.apiKey)"
    static let uaSportsByPageString = "\(Constants.baseURL)/top-headlines?country=ua&category=sports&apiKey=\(Secret.apiKey)&page="
    static let searchURLString =  "\(Constants.baseURL)/everything?sortBy=popularity&apiKey=\(Secret.apiKey)&q="
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    var onCompletionData: ((NewsAPIResponse) -> Void)?
    
    private init() {}
    
    
    // getMyTopStories
    public func getMyTopStories() {
        getURL(string: Constants.topHeadlinesString)
    }
    
    // getMyTopStories by page
    public func getMyTopStories(byPage: String) {
        getURL(string: Constants.topHeadlinesByPageString + byPage)
    }
    
    // getMyUaSportsStories
    public func getMyUaSportsStories() {
        getURL(string: Constants.uaSportsString)
    }
    
    // getMyUaSportsStories by page
    public func getMyUaSportsStories(byPage: String) {
        getURL(string: Constants.uaSportsByPageString + byPage)
    }
    
    // getMyCategoryStories
    public func getMyCategoryStories(by category: String) {
        getURL(string: Constants.topHeadlinesByCategoryString + category)
    }
    
    // getMyCategoryStories and page
    public func getMyCategoryStories(by category: String, andPage: String) {
        getURL(string: Constants.topHeadlinesByCategoryString + category + "&page=" + andPage)
    }
    
    // searchURLWithText
    public func searchURL(with query: String) {
        getURL(string: Constants.searchURLString + query)
    }
    
    func getURL(string: String) {
        guard let url = URL(string: string) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentData = self.parseJSON(withData: data) {
                    self.onCompletionData?(currentData)
                    //print("TEST totalResults: \(currentData.totalResults)")
                    //print("TEST status: \(currentData.status)")
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> NewsAPIResponse? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsAPIResponse.self, from: data)
            //print("totalResults: \(decodedData.totalResults)")
            return decodedData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
