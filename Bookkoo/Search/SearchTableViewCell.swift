//
//  SearchTableViewCell.swift
//  Bookkoo
//
//  Created by dwKang on 2021/03/30.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var bookAuthor: UILabel!
    @IBOutlet var bookTranslator: UILabel!
    @IBOutlet var translatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
