# infinite-uicollectionview

This repository aims to provide a simple way of implementing an infinite collection view.  
By infinite, we mean that as soon as a user reaches the boundary of the collection view
content, the content will then loop back to the start in a circular manner. 

Using InfiniteCollectionView
--------------------------

In order to use InfiniteCollectionView:

1. Make it the custom subclass of a UICollectionView component in your storyboard.
2. Set the infiniteDataSource (not the standard UICollectionView dataSource) and implement the required functions.

InfiniteCollectionViewDataSource
--------------------------
The custom datasource is very similar to the standard UICollectionViewDataSource.  There are 3 functions to implement:

`func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath, usableIndexPath: NSIndexPath) -> UICollectionViewCell`

This function operates exactly the same as the regular cellForItemAtIndexPath, however, you should use `dequeueIndexPath` for dequeuing your cell and `usableIndexPath` for your content.

`func numberOfItems(collectionView: UICollectionView) -> Int`

As with the standard UICollectionViewDatasource, simply return the number of cells of content you have.

`func widthForCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat`

Currently this function should return a constant, the cell size.  In future this will be used to allow widths of various sizes.

Current Support
--------------------------
You can use InfiniteCollectionView to scroll infinitely in a horizontal direction with equally sized cells.

Future
--------------------------
Improvements will include vertical scroll support and support for various cell sizes.
