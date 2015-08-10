//
//  InfiniteCollectionView.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

protocol InfiniteCollectionViewDataSource
{
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath, usableIndexPath: NSIndexPath) -> UICollectionViewCell
    func numberOfItems(collectionView: UICollectionView) -> Int
    func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class InfiniteCollectionView: UICollectionView
{
    var infiniteDataSource: InfiniteCollectionViewDataSource?
    private let cellPadding: CGFloat = 10.0
    private var indexOffset = 0
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        dataSource = self
    }
    
    private func shiftContentArray(offset: Int)
    {
        indexOffset += offset
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        centreIfNeeded()
    }

    private func centreIfNeeded()
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
                // Total cells (including partial cells) from centre
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
    
    private func getCorrectedIndex(indexToCorrect: Int) -> Int
    {
        if let numberOfCells = infiniteDataSource?.numberOfItems(self)
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
    
    private func getTotalContentWidth() -> CGFloat
    {
        let numberOfCells = infiniteDataSource?.numberOfItems(self) ?? 0
        let cellWidth = infiniteDataSource?.widthForCellAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) ?? 0
        return CGFloat(numberOfCells) * (cellWidth + cellPadding)
    }
    
}

extension InfiniteCollectionView: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let numberOfItems = infiniteDataSource?.numberOfItems(self) ?? 0
        return  3 * numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        return infiniteDataSource!.cellForItemAtIndexPath(self, dequeueIndexPath: indexPath, usableIndexPath: NSIndexPath(forRow: getCorrectedIndex(indexPath.row - indexOffset), inSection: 0))
    }
}
