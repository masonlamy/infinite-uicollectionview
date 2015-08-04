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
    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!
    
    
    let cellItems = ["One", "Two", "Three", "Four", "Five", "Six"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        infiniteCollectionView.registerNib(UINib(nibName: "ExampleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCollectionView")
        infiniteCollectionView.infiniteDataSource = self
        infiniteCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: InfiniteCollectionViewDataSource
{
    func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return cellItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = infiniteCollectionView.dequeueReusableCellWithReuseIdentifier("cellCollectionView", forIndexPath: indexPath) as! ExampleCollectionViewCell
        cell.lbTitle.text = cellItems[indexPath.row]
        return cell
    }
}
