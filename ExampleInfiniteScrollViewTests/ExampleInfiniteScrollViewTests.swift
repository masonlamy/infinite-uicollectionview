//
//  ExampleInfiniteScrollViewTests.swift
//  ExampleInfiniteScrollViewTests
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit
import XCTest

class mockInfiniteCollectionViewDataSource: NSObject, InfiniteCollectionViewDataSource
{
    private let cellItems = ["One", "Two", "Three", "Four", "Five", "Six"]
    private let infiniteCollectionView: InfiniteCollectionView
    
    init(view: InfiniteCollectionView)
    {
        infiniteCollectionView = view
        infiniteCollectionView.registerNib(UINib(nibName: "ExampleCollectionViewCell", bundle: NSBundle(forClass: self.dynamicType)), forCellWithReuseIdentifier: "cellCollectionView")
    }
    
    func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = infiniteCollectionView.dequeueReusableCellWithReuseIdentifier("cellCollectionView", forIndexPath: indexPath) as! ExampleCollectionViewCell
        cell.lbTitle.text = cellItems[indexPath.row]
        return cell
    }
}

class ExampleInfiniteScrollViewTests: XCTestCase
{
    var collectionView: InfiniteCollectionView!
    
    override func setUp()
    {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        let viewController = storyboard.instantiateInitialViewController() as! ViewController
        XCTAssertNotNil(viewController.view, "ViewController should be initialised already")
        collectionView = viewController.infiniteCollectionView
        let mockDataSource = mockInfiniteCollectionViewDataSource(view: collectionView)
        collectionView.infiniteDataSource = mockDataSource
    }
    
    func testInfiniteDataSourceExists()
    {
        XCTAssertFalse(collectionView.infiniteDataSource == nil, "Infinite DataSource should be set")
    }
    
    func testDataSourceGivesCorrectItemsInSection()
    {
        let numberOfItems = collectionView.infiniteDataSource!.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssert(numberOfItems == 6, "DataSource should return the correct number of cell items (6)")
    }
    
    func testCorrectedIndicesWithinBounds()
    {
        let numberOfItems = collectionView.infiniteDataSource!.collectionView(collectionView, numberOfItemsInSection: 0)
        for i in -1000...1000
        {
            let correction = collectionView.getCorrectedIndex(i)
            XCTAssert(correction >= 0 && correction < numberOfItems, "Corrected indices should always fall within array boundaries")
        }
    }
    
    func testTotalContentWidthIsNonZero()
    {
        XCTAssertFalse(collectionView.getTotalContentWidth() == 0.0, "Total content width must never be zero")
    }
    
    func testCollectionViewDataSourceExists()
    {
        XCTAssertFalse(collectionView.dataSource == nil, "DataSource should always be set")
    }
    
    func testCollectionViewDataSourceHasCorrectNumberOfCells()
    {
        let numberOfItems = collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssert(numberOfItems == (3 * 6), "DataSource should return 3 times the number of cells to allow for infinite scrolling)")
    }
    
    func testCentreIfNeededCentres()
    {
        collectionView.centreIfNeeded()
        let centreOffsetX = collectionView.getTotalContentWidth() * 3
        let distanceFromCentre = centreOffsetX - collectionView.contentOffset.x
        
        XCTAssert(distanceFromCentre == 0, "After centering, collectionView should be centered.  Distance is \(distanceFromCentre)")
    }
}
