//
//  DetailCardViewController.swift
//  SearchBookApp
//
//  Created by m.toporkov on 13.03.2022.
//

import UIKit

class DetailCardViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        configure(model: model)
    }
}

private extension DetailCardViewController {
    func configure(model: Book?) {
        activityIndicator.color = .black
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var allAuthors = ""
        
        for author in model?.volumeInfo.authors ?? [] {
            if let authorData = author.data(using: .utf8) {
                let encodeAuthor = String(data: authorData, encoding: .utf8)
                allAuthors += allAuthors.isEmpty ? encodeAuthor ?? "-" : ", \(encodeAuthor ?? "-")"
            }
        }
        
        authorLabel.text = allAuthors
        
        if let title = model?.volumeInfo.title, let nameData = title.data(using: .utf8) {
            let encodeName = String(data: nameData, encoding: .utf8)
            nameLabel.text = encodeName
        }
        
        if let rating = model?.volumeInfo.averageRating {
            ratingLabel.text = "\(rating)"
        }
        
        if let urlString = model?.volumeInfo.imageLinks?.thumbnail {
            let url = URL(string: urlString)
            downloadImage(from: url)
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    func downloadImage(from url: URL?) {
        guard let url = url else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        }
        
        getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async() { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
