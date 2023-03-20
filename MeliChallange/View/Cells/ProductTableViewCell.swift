//
//  ProductTableViewCell.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 12/3/23.
//

import UIKit

protocol setUpCells {
    func setUp(product: Product) -> Void
}

class ProductTableViewCell: UITableViewCell {

    private enum Constants {
        static let background = UIColor(ciColor: .white)
        static let cornerRadius = CGFloat(10)
        static let tableCellConstants = CGFloat(10)
    }
    
    var productTitle = UILabel()
    var productImage = UIImageView()
    var productDescription = UILabel()
    var postImageUrl: String? {
        didSet {
            if let url = postImageUrl {
                productImage.loadImage(url: url)
            } else {
                productImage.image = nil
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productTitle.text = ""
        productDescription.text = ""
        productImage.image = nil
    }
    
    func setUp() {
        backgroundColor = Constants.background
        addSubview(productTitle)
        addSubview(productImage)
        addSubview(productDescription)
        setTitleLayout()
        setImageLayout()
        setDescriptionLayout()
    }
    
    func setTitleLayout() {
        productTitle.numberOfLines = 0
        productTitle.font = Utils.setFont(size: 18)
        productTitle.textColor = .black
        setTitleConstraints()
    }
    
    func setDescriptionLayout() {
        productDescription.numberOfLines = 4
        productDescription.font = Utils.setFont(size: 14)
        productDescription.textColor = .gray
        setDescriptionConstraints()
    }
    
    func setImageLayout() {
        productImage.layer.cornerRadius = Constants.cornerRadius
        productImage.contentMode = .scaleAspectFit
        productImage.clipsToBounds = true
        productImage.layer.borderWidth = 1/2
        productImage.layer.borderColor = UIColor.lightGray.cgColor
        setImageConstraints()
    }
    
    func setTitleConstraints() {
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: Constants.tableCellConstants).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tableCellConstants).isActive = true
    }
    
    func setImageConstraints() {
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tableCellConstants).isActive = true
        productImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.tableCellConstants).isActive = true
        productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.tableCellConstants).isActive = true
        productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2).isActive = true
    }
    
    func setDescriptionConstraints() {
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: Constants.tableCellConstants).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: Constants.tableCellConstants).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tableCellConstants).isActive = true
    }
}

extension ProductTableViewCell: setUpCells {
    func setUp(product: Product) {
        productTitle.text = "\(Utils.priceFormatter(number: product.price))"
        productDescription.text = product.title
        postImageUrl = product.thumbnail
    }
}
