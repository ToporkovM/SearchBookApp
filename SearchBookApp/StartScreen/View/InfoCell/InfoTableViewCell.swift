//
//  InfoTableViewCell.swift
//  SearchBookApp
//
//  Created by m.toporkov on 13.03.2022.
//

import UIKit

final class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        nameLabel.text = nil
        
    }
    
    func configure(authors: [String], name: String) {
        var allAuthors = ""
        
        for author in authors {
            if let authorData = author.data(using: .utf8) {
                let encodeAuthor = String(data: authorData, encoding: .utf8)
                allAuthors += allAuthors.isEmpty ? encodeAuthor ?? "-" : ", \(encodeAuthor ?? "-")"
            }
        }
        
        if let nameData = name.data(using: .utf8) {
            let encodeName = String(data: nameData, encoding: .utf8)
            nameLabel.text = encodeName
        }
        
        authorLabel.text = allAuthors.utf8.description
        
    }
}
