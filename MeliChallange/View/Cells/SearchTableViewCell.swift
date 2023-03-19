//
//  SearchTableViewCell.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 17/3/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    private enum Constants {
        static let margin = CGFloat(10)
    }
    var searchText = UILabel()
    var searchIconImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchText.text = ""
        searchIconImage.image = nil
    }
    
    func setUpView() {
        addSubview(searchText)
        addSubview(searchIconImage)
        setTextLayout()
        setImageLayout()
    }
    
    func setTextLayout() {
        searchText.numberOfLines = 0
        searchText.font = Utils.setFont(size: 17)
        searchText.textColor = .black
        setTextConstraints()
    }
    
    func setImageLayout() {
        setImageConstraints()
    }
    
    func setTextConstraints() {
        searchText.translatesAutoresizingMaskIntoConstraints = false
        searchText.topAnchor.constraint(equalTo: topAnchor, constant: Constants.margin).isActive = true
        searchText.leadingAnchor.constraint(equalTo: searchIconImage.trailingAnchor, constant: Constants.margin).isActive = true
        searchText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.margin).isActive = true
    }
    
    func setImageConstraints() {
        searchIconImage.translatesAutoresizingMaskIntoConstraints = false
        searchIconImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.margin).isActive = true
        searchIconImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.margin).isActive = true
        searchIconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.margin).isActive = true
        searchIconImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
