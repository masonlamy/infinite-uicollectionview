//
//  InfiniteCollectionView.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

protocol InfiniteCollectionViewDataSource : UICollectionViewDataSource
{
    func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class InfiniteCollectionView: UICollectionView
{
    var infiniteDataSource: InfiniteCollectionViewDataSource?
    private let cellPadding: CGFloat = 10
    private var indexOffset = 0
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        dataSource = self
        backgroundColor = UIColor.grayColor()
    }
    
    func shiftContentArray(offset: Int)
    {
        indexOffset += offset
        
        if let numberOfItems = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0)
        {
            if (indexOffset >= numberOfItems)
            {
                indexOffset -= numberOfItems
            }
        }
        printCurrentContentArray()
    }
    
    func printCurrentContentArray()
    {
        var currentContent = [String]()
        if let numberOfItems = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0)
        {
            for indexRow in 0..<numberOfItems
            {
                let correctedIndex = getCorrectedIndex(indexRow + indexOffset)
                currentContent.append((infiniteDataSource!.collectionView(self, cellForItemAtIndexPath: NSIndexPath(forRow: correctedIndex, inSection: 0)) as! ExampleCollectionViewCell).lbTitle.text!)
            }
        }
        println("Current Content: \(currentContent)")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        centreIfNeeded()
    }

    func centreIfNeeded()
    {
        let currentOffset = contentOffset
        let contentWidth = getTotalContentWidth()
        
        // Calculate the centre of content X position offset and the current distance from that centre point
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x
        
        if (fabs(distFromCentre) > (contentWidth / 4))
        {
            if let cellWidth = infiniteDataSource?.widthForCellAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            {
                // Total cells including partial cells from centre
                let cellcount = distFromCentre/(cellWidth+cellPadding)
                
                // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
                let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
                
                // Amount left over to correct for
                let offsetCorrection = (abs(cellcount) % 1) * (cellWidth+cellPadding)
                
                // Scroll back to the centre of the view, offset by the correction to ensure it's not noticable
                if (contentOffset.x < centerOffsetX)
                {
                    //left scrolling
                    contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
                }
                else if (contentOffset.x > centerOffsetX)
                {
                    //right scrolling
                    contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
                }
                
                // Make content shift as per shiftCells
                shiftContentArray(getCorrectedIndex(shiftCells))
                
                // Reload cells, due to data shift changes above
                reloadData()
            }
        }
    }
    
    func getCorrectedIndex(indexToCorrect: Int) -> Int
    {
        if let numberOfCells = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0)
        {
            if (indexToCorrect < numberOfCells && indexToCorrect >= 0)
            {
                return indexToCorrect
            }
            else
            {
                let countInIndex = Float(indexToCorrect) / Float(numberOfCells)
                let flooredValue = Int(floor(countInIndex))
                let offset = numberOfCells * flooredValue
                return indexToCorrect - offset
            }
        }
        else
        {
            return 0
        }
    }
    
    func getTotalContentWidth() -> CGFloat
    {
        if let numberOfCells = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0),
        let cellWidth = infiniteDataSource?.widthForCellAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        {
            return CGFloat(numberOfCells) * (cellWidth + cellPadding)
        }
        else
        {
            return 0.0
        }
    }
}

extension InfiniteCollectionView: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let numberOfItems = infiniteDataSource?.collectionView(self, numberOfItemsInSection: section)
        {
            println("numberOfItems * 3: \(3 * numberOfItems)")
            return  3 * numberOfItems
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        println("indexPath row: \(indexPath.row)")
        return infiniteDataSource!.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: getCorrectedIndex(indexPath.row + indexOffset), inSection: 0))
    }
}
