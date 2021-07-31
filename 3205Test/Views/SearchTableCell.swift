//
//  SearchTableCell.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import UIKit

class SearchTableCell: UITableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    
    static let reuseId = "SearchCellId"

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        configure()
    }
    
    private func configure() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
