//
//  ProductAPIModel.swift
//  CourseWork
//
//  Created by Matvei Semenov on 12/12/2022.
//

import Foundation

struct ProductApiModel: Decodable {
    let code: String
    let product: ProductDetailsApiModel
}

struct ProductDetailsApiModel: Decodable {
    let name: String
    let description: String?
    let imageUrl: URL?
}
