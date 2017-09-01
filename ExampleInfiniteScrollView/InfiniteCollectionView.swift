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
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) -> UICollectionViewCell
    func numberOfItems(_ collectionView: UICollectionView) -> Int
}

protocol InfiniteCollectionViewDelegate
{
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, usableIndexPath: IndexPath)
}

class InfiniteCollectionView: UICollectionView
{
    var infiniteDataSource: InfiniteCollectionViewDataSource?
    var infiniteDelegate: InfiniteCollectionViewDelegate?
    
    @IBInspectable var isHorizontalScroll: Bool = true
    
    fileprivate var cellPadding = CGFloat(0)
    fileprivate var cellWidth = CGFloat(0)
    fileprivate var cellHeight = CGFloat(0)
    fileprivate var indexOffset = 0
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        dataSource = self
        delegate = self
        setupCellDimensions()
    }
    
    fileprivate func setupCellDimensions()
    {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        cellPadding = layout.minimumInteritemSpacing
        cellWidth = layout.itemSize.width
        cellHeight = layout.itemSize.height
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if isHorizontalScroll{
            centreIfNeeded()
        }
        else{
            centreVerticallyIfNeeded()
        }
    }

    fileprivate func centreIfNeeded()
    {
        let currentOffset = contentOffset
        let contentWidth = getTotalContentWidth()
        
        // Calculate the centre of content X position offset and the current distance from that centre point
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x
        
        if (fabs(distFromCentre) > (contentWidth / 4))
        {
            // Total cells (including partial cells) from centre
            let cellcount = distFromCentre/(cellWidth+cellPadding)
            
            // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            
            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * (cellWidth+cellPadding)
            
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
    
    
    fileprivate func centreVerticallyIfNeeded()
    {
        let currentOffset = contentOffset
        let contentHeight = getTotalContentHeight()
        
        let centerOffsetY: CGFloat = (3 * contentHeight ) / 2//- bounds.size.height
        let distFromCentre = centerOffsetY - currentOffset.y
        
        if (fabs(distFromCentre) > (contentHeight / 4))
        {
            let cellcount = distFromCentre/(cellHeight + cellPadding)
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            
            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * (cellHeight+cellPadding)
            
            // Scroll back to the centre of the view, offset by the correction to ensure it's not noticable
            if (contentOffset.y < centerOffsetY)
            {
                //left scrolling
                contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetY - offsetCorrection)
            }
            else if (contentOffset.y > centerOffsetY)
            {
                //right scrolling
                contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetY + offsetCorrection)
            }
            
            // Make content shift as per shiftCells
            shiftContentArray(getCorrectedIndex(shiftCells))
            
            // Reload cells, due to data shift changes above
            reloadData()
        }
    }

    
    fileprivate func shiftContentArray(_ offset: Int)
    {
        indexOffset += offset
    }
    
    fileprivate func getTotalContentWidth() -> CGFloat
    {
        let numberOfCells = infiniteDataSource?.numberOfItems(self) ?? 0
        return CGFloat(numberOfCells) * (cellWidth + cellPadding)
    }
    
    fileprivate func getTotalContentHeight() -> CGFloat
    {
        let numberOfCells = infiniteDataSource?.numberOfItems(self) ?? 0
        return (CGFloat(numberOfCells) * (cellHeight + cellPadding)) - cellPadding
    }
}

extension InfiniteCollectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let numberOfItems = infiniteDataSource?.numberOfItems(self) ?? 0
        return  3 * numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return infiniteDataSource!.cellForItemAtIndexPath(self, dequeueIndexPath: indexPath, usableIndexPath: IndexPath(row: getCorrectedIndex(indexPath.row - indexOffset), section: 0))
    }
    
    fileprivate func getCorrectedIndex(_ indexToCorrect: Int) -> Int
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
}

extension InfiniteCollectionView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        infiniteDelegate?.didSelectCellAtIndexPath(self, usableIndexPath: IndexPath(row: getCorrectedIndex(indexPath.row - indexOffset), section: 0))
    }
}

extension InfiniteCollectionView
{
    override var dataSource: UICollectionViewDataSource?
    {
        didSet
        {
            if (!self.dataSource!.isEqual(self))
            {
                print("WARNING: UICollectionView DataSource must not be modified.  Set infiniteDataSource instead.")
                self.dataSource = self
            }
        }
    }
    
    override var delegate: UICollectionViewDelegate?
    {
        didSet
        {
            if (!self.delegate!.isEqual(self))
            {
                print("WARNING: UICollectionView delegate must not be modified.  Set infiniteDelegate instead.")
                self.delegate = self
            }
        }
    }
}
