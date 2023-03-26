//
//  ProductDetailsViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 12/12/2022.
//

import UIKit
import SVProgressHUD

class ProductDetailsViewController: UIViewController {
    enum Mode {
        case add, edit
    }

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var stepper: UIStepper!
    let dataProvider = DataProvider.shared

    var mode: Mode = .add {
        didSet {
            guard isViewLoaded else { return }
            setupRightBarButton()
        }
    }
    var selectedCategory: ProductCategory?
    var product: Product?
    var didAddProduct: (() -> Void)?

    var productCount: Int = 1 {
        didSet {
            countLabel.text = "\(productCount) шт"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        productImageView.sd_setImage(with: product?.imageUrl)
        titleTextField.text = product?.name
        descriptionTextView.text = product?.description
        productCount = product?.count ?? 1
        stepper.value = Double(productCount)
        if let category = product?.category {
            categoryButton.setTitle(category.stringValue, for: .normal)
        }
        setupRightBarButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CategorySelection":
            guard let vc = segue.destination as? PickerViewController else {
                break
            }
            let values = ProductCategory.allCases
            vc.values = values.compactMap({ $0.stringValue })
            vc.didSelectAction = { [weak self] index in
                let selectedValue = values[index]
                self?.selectedCategory = selectedValue
                self?.categoryButton.setTitle(selectedValue.stringValue, for: .normal)
            }
        default:
            break
        }
    }

    private func setupRightBarButton() {
        let barItemStyle: UIBarButtonItem.SystemItem
        switch mode {
        case .add:
            barItemStyle = .add
        case .edit:
            barItemStyle = .save
        }
        let barItem = UIBarButtonItem(barButtonSystemItem: barItemStyle, target: self, action: #selector(didPressDone(_:)))
        topBar.topItem?.setRightBarButton(barItem, animated: true)
    }

    @IBAction func didChangeCount(_ sender: UIStepper) {
        productCount = Int(sender.value)
    }

    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func didPressDone(_ sender: Any) {
        guard let product = product else { return }
        let newProduct = Product(barCode: product.barCode, name: titleTextField.text ?? "", imageUrl: product.imageUrl, count: productCount, description: descriptionTextView.text, category: selectedCategory ?? .other)

        SVProgressHUD.show()
        dataProvider.saveProduct(newProduct) { [weak self] error in
            if error == nil {
                self?.didAddProduct?()
            }
            SVProgressHUD.dismiss()
            self?.dismiss(animated: true)
        }
    }
}
