//
//  DataProvider.swift
//  CourseWork
//
//  Created by Matvei Semenov on 12/12/2022.
//

import Foundation
import Alamofire
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataProvider {
    enum ProviderError: Error {
        case userNotFound
    }

    static let shared = DataProvider()

    var products: [Product] = [
        .init(barCode: "1", name: "1", imageUrl: nil, count: 3, description: "Description", category: .other),
        .init(barCode: "2", name: "2", imageUrl: nil, count: 2, description: "Description", category: .other),
        .init(barCode: "3", name: "3", imageUrl: nil, count: 1, description: "Description", category: .other)
    ]

    lazy var firestore = Firestore.firestore()
    lazy var userService = UserService.shared

    func getProduct(with barCode: String, completion: @escaping (Product?) -> Void) {
        if let product = products.first(where: { $0.barCode == barCode }) {
            completion(product)
            return
        }

        let headers: HTTPHeaders = .init(dictionaryLiteral: ("Authorization", "Bearer "))
        AF.request("https://go-upc.com/api/v1/code/\(barCode)", headers: headers).responseDecodable(of: ProductApiModel.self) { response in
            switch response.result {
            case .success(let model):
                let newProduct = Product(barCode: model.code, name: model.product.name, imageUrl: model.product.imageUrl, count: 1, description: model.product.description ?? "", category: .other)
                completion(newProduct)
            case .failure(_):
                completion(nil)
            }
        }
    }

    func setupProductListUpdatesListener(_ completion: @escaping ([Product]) -> Void) {
        guard let userId = userService.currentUser?.id else {
            completion([])
            return
        }
        firestore.collection("users")
            .document("user_\(userId)")
            .collection("productList")
            .addSnapshotListener { snapshot, error in
                guard error == nil,
                let products = snapshot?.documents.compactMap({ try? $0.data(as: Product.self) }) else {
                    completion([])
                    return
                }
                completion(products)
            }
    }

    func saveProduct(_ product: Product, completion: @escaping (Error?) -> Void) {
        guard let userId = userService.currentUser?.id else {
            completion(ProviderError.userNotFound)
            return
        }
        do {
            try firestore.collection("users")
                .document("user_\(userId)")
                .collection("productList")
                .document("code_\(product.barCode)").setData(from: product) { error in
                    completion(error)
                }
        } catch let error {
            completion(error)
        }
    }

    func removeProduct(_ product: Product, completion: @escaping (Error?) -> Void) {
        guard let userId = userService.currentUser?.id else {
            completion(ProviderError.userNotFound)
            return
        }
        firestore.collection("users")
            .document("user_\(userId)")
            .collection("productList")
            .document("code_\(product.barCode)")
            .delete() { error in
                completion(error)
            }
    }
}
