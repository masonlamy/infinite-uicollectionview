//
//  InfiniteCollectionView.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

//
//  InfiniteCollectionView.swift
//  Word Search
//
//  Created by Mason L'Amy on 14/01/2015.
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
    var indexOffset = 0
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        registerNib(UINib(nibName: "WordCell", bundle: nil), forCellWithReuseIdentifier: "cellWord")
        registerNib(UINib(nibName: "PicWordCell", bundle: nil), forCellWithReuseIdentifier: "cellPicWord")
        dataSource = self
        backgroundColor = UIColor.grayColor()
    }
    
    func shiftWordArray(offset: Int)
    {
       /* if (offset > 0)
        {
            //Right shift
            let removeRange = words!.endIndex - offset..<words!.endIndex
            let removedElements = words![removeRange]
            words!.removeRange(removeRange)
            var i = 0
            for word in removedElements
            {
                words!.insert(word, atIndex: i)
                i++
            }
        }
        else
        {
            //Left shift
            let endIndex: Int = abs(offset)
            let removeRange = 0..<endIndex
            let removedElements = words![removeRange]
            words!.removeRange(removeRange)
            for word in removedElements
            {
                words!.append(word)
            }
        }*/
        indexOffset += offset
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
            
            // Total cells including partial cells from centre
            let cellcount = distFromCentre/(70.0+cellPadding)
            
            // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            
            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount) % 1) * (70.0+cellPadding)
            
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
            shiftWordArray(getCorrectedWordIndex(shiftCells))
            
            // Reload cells, due to data shift changes above
            reloadData()
        }
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        centreIfNeeded()
    }
    
    private func getCorrectedWordIndex(indexToCorrect: Int) -> Int
    {
        if let numberOfCells = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0)
        {
            if (indexToCorrect <= (numberOfCells - 1))
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
    
    private func getTotalContentWidth() -> CGFloat
    {
        var width: CGFloat = 0.0
        if let numberOfCells = infiniteDataSource?.collectionView(self, numberOfItemsInSection: 0)
        {
            for row in 0...numberOfCells
            {
                if let cellWidth = infiniteDataSource?.widthForCellAtIndexPath(NSIndexPath(forRow: row, inSection: 0))
                {
                    width += cellWidth + cellPadding
                }
            }
        }
        return width
    }
}

extension InfiniteCollectionView: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let numberOfItems = infiniteDataSource?.collectionView(self, numberOfItemsInSection: section)
        {
            return  3 * numberOfItems
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        return infiniteDataSource!.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: getCorrectedWordIndex(indexPath.row + indexOffset), inSection: 0))
    }
}
