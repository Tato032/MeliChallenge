//
//  AttributesTableViewCell.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 18/3/23.
//

import UIKit

class AttributesTableViewCell: UITableViewCell {

    var attributeName = UILabel()
    var attributeDescription = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attributeName.text = ""
        attributeDescription.text = ""
        setNameLayout()
        setDescriptionLayout()
    }
    
    func setUp() {
        backgroundColor = .lightGray
        addSubview(attributeName)
        addSubview(attributeDescription)
        setNameLayout()
        setDescriptionLayout()
    }
    
    func setNameLayout() {
        attributeName.numberOfLines = 0
        attributeName.font = Utils.setFont(size: 20)
        attributeName.textColor = .black
        setNameConstraints()
    }
    
    func setNameConstraints() {
        attributeName.translatesAutoresizingMaskIntoConstraints = false
        attributeName.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        attributeName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        attributeName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
    }
    
    func setDescriptionLayout() {
        attributeDescription.numberOfLines = 0
        attributeDescription.font = Utils.setFont(size: 14)
        attributeDescription.textColor = .white
        setDescriptionConstraints()
    }
    
    func setDescriptionConstraints() {
        attributeDescription.translatesAutoresizingMaskIntoConstraints = false
        attributeDescription.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        attributeDescription.leadingAnchor.constraint(equalTo: attributeName.trailingAnchor, constant: 5).isActive = true
        attributeDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
        attributeDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
    }
    
    func setUp(attribute: Attributes?) {
        attributeName.text = attribute?.name
        attributeDescription.text = attribute?.value_Name
    }
}
