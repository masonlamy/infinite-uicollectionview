# infinite-uicollectionview

InfiniteCollectionView
-------------------------

This repository aims to provide a simple way of implementing an infinite collection view.  
By infinite, we mean that as soon as a user reaches the boundary of the collection view
content, the content will then loop back to the start in a circular manner. 

Using InfiniteCollectionView
--------------------------

In order to use InfiniteCollectionView:

1. Make it the custom subclass of a UICollectionView component in your storyboard.
2. Set the infiniteDataSource (not the standard UICollectionView dataSource) and implement the required functions.

Current Support
--------------------------
You can use InfiniteCollectionView to scroll infinitely in a horizontal direction with equally sized cells

Future
--------------------------
Improvements will include vertical scroll support and support for various cell sizes.
