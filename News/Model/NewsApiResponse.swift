//
//  NewsApiResponse.swift
//  News
//
//  Created by Andrii Stetsenko on 28.02.2024.
//

import Foundation

enum Section {
    case main
}

// MARK: - NewsAPIResponse
struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Hashable, Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title
    }
}

// MARK: - Source
struct Source: Codable {
    let name: String
}
