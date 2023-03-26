//
//  ProductTableViewCell.swift
//  CourseWork
//
//  Created by Matvei Semenov on 12/12/2022.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(with product: Product) {
        productTitleLabel.text = product.name
        countLabel.text = "\(product.count) шт"
        productImageView.sd_setImage(with: product.imageUrl)
    }
}
