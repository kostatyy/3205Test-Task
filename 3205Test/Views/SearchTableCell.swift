//
//  SearchTableCell.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import UIKit

class SearchTableCell: UITableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        configure()
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
