//
//  DownloadsCollectionViewController.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit

class DownloadsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        configure()
    }
    
    private func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.12)
        collectionView.collectionViewLayout = layout
        let nibCell = UINib(nibName: "DownloadsCollectionCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: DownloadsCollectionCell.reuseId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DownloadsCollectionCell.reuseId, for: indexPath) as! DownloadsCollectionCell
        return cell
    }

}

