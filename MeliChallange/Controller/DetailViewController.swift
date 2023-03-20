//
//  DetailViewController.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 10/3/23.
//

import UIKit


class DetailViewController: UIViewController, UIScrollViewDelegate {
    enum Constants {
        static let margin = CGFloat(10)
    }
    
    private var contentView: UIView = {
        let view = UIView()
        return view
    }()
    var productTitle = UILabel()
    var productPrice = UILabel()
    var productInstallments = UILabel()
    var productImage = UIImageView()
    var stackView = UIStackView()
    var scrollView = UIScrollView()
    
    var product: Product?
    var fullProduct: FullProduct?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemProperties()
        setUpView()
    }
    
    
    /// Function thath calls getItem() and executes an action on the view depending the result
    func getItemProperties() {
        guard let id = product?.id else {
            return
        }
        Facade.shared.getFullItem(id: id) {
            [weak self] result in
            switch result {
            case .success(let fullProduct):
                self?.fullProduct = fullProduct
                DispatchQueue.main.async {
                    self?.loadData()
                }
            case .failure(_):
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    Utils.showAlert(on: self, with: "Error", message: "Ocurrio un error al obtener el producto")
                }
            }
        }
    }
    
    /// Gets the view ready to show their items on screen
    func setUpView() {
        setUpNavBar()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(productTitle)
        scrollView.addSubview(productPrice)
        scrollView.addSubview(productImage)
        scrollView.addSubview(productInstallments)
        scrollView.addSubview(stackView)
        setScrollViewLayout()
        setTitleLayout()
        setImageLayout()
        setPriceLayout()
        setInstallmentsLayout()
        setStackViewLayout()
    }
    
    func setUpNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 1, green: 0.8667, blue: 0, alpha: 1)
        navBar?.standardAppearance = appearance;
        navBar?.scrollEdgeAppearance = navBar?.standardAppearance
    }
    
    /// Loads the product item properties on screen
    func loadData() {
        productTitle.text = product?.title
        productPrice.text = "\(Utils.priceFormatter(number: product?.price ?? 0))"
        if product?.installments?.quantity ?? 0 > 0 {
        productInstallments.text = "en \(product?.installments?.quantity ?? 0) cuotas de \(Utils.priceFormatter(number: product?.installments?.amount ?? 0))"
        } else {
            productInstallments.text = "No especifica precio de cuotas"
        }
        if let url = fullProduct?.pictures?[0].url {
            productImage.loadImage(url: url)
        } else {
            productImage.image = nil
        }
        
        var stackViewHeight = CGFloat(0)
        for attribute in fullProduct?.attributes ?? [] {
            if attribute.value_name != nil {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
                label.numberOfLines = 1
                label.textColor = .black
                label.center = CGPoint(x: 100, y: 300)
                label.textAlignment = .left
                label.font = Utils.setFont(size: 19)
                label.text = "\(attribute.name ?? ""): " + "\(attribute.value_name ?? "")"
                
                stackView.addArrangedSubview(label)
                stackViewHeight += CGFloat(40)
            }
        }
            stackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        
    }
    
    //MARK: UI items configuration
    func setScrollViewLayout() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 1.5)
        scrollView.isScrollEnabled = true
        setScrollViewConstraints()
    }
    
    func setStackViewLayout() {
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.backgroundColor = .white
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        setStackViewConstraints()
    }
    
    func setTitleLayout() {
        productTitle.textColor = .black
        productTitle.numberOfLines = 0
        productTitle.textAlignment = .left
        productTitle.font = Utils.setFont(size: 15)
        setTitleConstraints()
    }
    
    func setImageLayout() {
        productImage.contentMode = .scaleAspectFit
        setImageConstraints()
    }
    
    func setPriceLayout() {
        productPrice.textColor = .black
        productPrice.numberOfLines = 0
        productPrice.textAlignment = .left
        productPrice.font = Utils.setFont(size: 35)
        setPriceConstraints()
    }
    
    func setInstallmentsLayout() {
        productInstallments.textColor = UIColor(red: 0.1255, green: 0.5882, blue: 0, alpha: 1)
        productInstallments.numberOfLines = 0
        productInstallments.font = Utils.setFont(size: 20)
        setInstallmentsConstraints()
    }
    
    //MARK: UI items constraints
    func setScrollViewConstraints() {
        let margins = view.layoutMarginsGuide
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
    }
    
    func setTitleConstraints() {
        let margins = view.layoutMarginsGuide
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.margin).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    func setImageConstraints() {
        let margins = view.layoutMarginsGuide
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 15).isActive = true
        productImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setPriceConstraints() {
        let margins = view.layoutMarginsGuide
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        productPrice.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: Constants.margin).isActive = true
        productPrice.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        productPrice.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
    
    func setInstallmentsConstraints() {
        let margins = view.layoutMarginsGuide
        productInstallments.translatesAutoresizingMaskIntoConstraints = false
        productInstallments.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 5).isActive = true
        productInstallments.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        productInstallments.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        stackView.topAnchor.constraint(equalTo: productInstallments.bottomAnchor, constant: Constants.margin).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Constants.margin).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -Constants.margin).isActive = true
    }
}
