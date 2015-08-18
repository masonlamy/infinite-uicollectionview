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
    private let cellItems = ["One", "Two", "Three", "Four", "Five", "Six"]
    
    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!
    {
        didSet
        {
            infiniteCollectionView.backgroundColor = UIColor.whiteColor()
            infiniteCollectionView.registerNib(UINib(nibName: "ExampleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCollectionView")
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
    func numberOfItems(collectionView: UICollectionView) -> Int
    {
        return cellItems.count
    }
    
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath, usableIndexPath: NSIndexPath)  -> UICollectionViewCell
    {
        let cell = infiniteCollectionView.dequeueReusableCellWithReuseIdentifier("cellCollectionView", forIndexPath: dequeueIndexPath) as! ExampleCollectionViewCell
        cell.lbTitle.text = cellItems[usableIndexPath.row]
        cell.backgroundImage.image = UIImage(named: "cell-1")
        return cell
    }
}

extension ViewController: InfiniteCollectionViewDelegate
{
    func didSelectCellAtIndexPath(collectionView: UICollectionView, usableIndexPath: NSIndexPath)
    {
        println("Selected cell with name \(cellItems[usableIndexPath.row])")
    }
}
