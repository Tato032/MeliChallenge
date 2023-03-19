//
//  Utils.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 12/3/23.
//

import Foundation
import UIKit

class Utils {
    
    /// Method use to assign a font to an string, done to reuse code
    /// - Parameter size: font size
    /// - Returns: an specific font
    static func setFont(size: CGFloat) -> UIFont {
        let font = UIFont(name: "ArialMT", size: size)
        return font!
    }
    
    /// Method use to show an alert to the user,  used in most of cases for error scenarios
    /// - Parameters:
    ///   - vc: View controller where the alert will be shown
    ///   - title: Main specific text the alert will show
    ///   - message: A brief description of what the alert wants to communicate
    static func showAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    /// Method used to format a double in order to make it look like a price numbre
    /// - Parameter number: Double that will be converted
    /// - Returns: An String that seems to be a price number
    static func priceFormatter(number: Double) -> String {
     let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 0
        guard let number = formatter.string(for: NSNumber(value: number)) else {
            return "0"
        }
        return number
    }
    
    /// Method used to realize the decode of the search list saved on user defaults
    /// - Parameter completion: An specific block of code, that will return a success or a failure scenario
    static func getSearches(completion: (Result<[String], Error>) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "mySearches") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let searchesList = try decoder.decode([String].self, from: data)
                
                completion(.success(searchesList))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension UIImageView {
    func loadImage(url: String) {
        self.image = UIImage(named: "loading")
        Facade.shared.loadProductImage(url) { (result) in
            switch result {
            case .success(let image):
                self.image = image
            case .failure(_):
                self.image = nil
            }
        }
    }
}
