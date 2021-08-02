//
//  DownloadsCollectionCell.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit

class DownloadsCollectionCell: UICollectionViewCell {
    
    static let reuseId = "DownloadsCellId"
    
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryOwnerName: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        configure()
    }
    
    private func configure() {
        bgView.layer.cornerRadius = 20
    }
    
}

