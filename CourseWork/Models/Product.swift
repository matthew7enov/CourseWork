//
//  Product.swift
//  CourseWork
//
//  Created by Matvei Semenov on 12/12/2022.
//

import Foundation

struct Product: Codable, Equatable {
    let barCode: String
    let name: String
    let imageUrl: URL?
    let count: Int
    let description: String
    let category: ProductCategory
}

enum ProductCategory: String, CaseIterable, Codable {
    case meat, drinks, fish, milkProducts, sweets, snacks, grocery, other

    var stringValue: String {
        switch self {
        case .meat:
            return "Мясо"
        case .drinks:
            return "Напитки"
        case .fish:
            return "Рыба"
        case .milkProducts:
            return "Молочные продукты"
        case .sweets:
            return "Сладости"
        case .snacks:
            return "Снэки"
        case .grocery:
            return "Бакалея"
        case .other:
            return "Другое"
        }
    }
    var emojiValue: String {
        switch self {
        case .meat:
            return "🥩"
        case .drinks:
            return "🥤"
        case .fish:
            return "🍣"
        case .milkProducts:
            return "🥛"
        case .sweets:
            return "🍫"
        case .snacks:
            return "🍿"
        case .grocery:
            return "🍞"
        case .other:
            return "🥥"
        }
    }
}


