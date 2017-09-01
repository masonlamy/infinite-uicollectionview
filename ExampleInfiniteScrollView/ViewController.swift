//
//  ViewController.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    fileprivate let cellItems = ["One", "Two", "Three", "Four", "Five", "Six"]
    
    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!
    {
        didSet
        {
            infiniteCollectionView.backgroundColor = UIColor.white
            infiniteCollectionView.register(UINib(nibName: "ExampleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCollectionView")
            infiniteCollectionView.infiniteDataSource = self
            infiniteCollectionView.infiniteDelegate = self
            infiniteCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

extension ViewController: InfiniteCollectionViewDataSource
{
    func numberOfItems(_ collectionView: UICollectionView) -> Int
    {
        return cellItems.count
    }
    
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath)  -> UICollectionViewCell
    {
        let cell = infiniteCollectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: dequeueIndexPath) as! ExampleCollectionViewCell
        cell.lbTitle.text = cellItems[usableIndexPath.row]
        cell.backgroundImage.image = UIImage(named: "cell-1")
        return cell
    }
}

extension ViewController: InfiniteCollectionViewDelegate
{
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, usableIndexPath: IndexPath)
    {
        print("Selected cell with name \(cellItems[usableIndexPath.row])")
    }
}
