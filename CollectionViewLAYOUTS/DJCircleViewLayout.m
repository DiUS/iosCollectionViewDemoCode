//
//  DJCircleViewLayout.m
//  CollectionViewLAYOUTS
//
//  Created by Dallas Johnson on 5/02/2014.
//  Copyright (c) 2014 Dallasj. All rights reserved.
//

#import "DJCircleViewLayout.h"

@interface DJCircleViewLayout ()
@property (nonatomic,strong) NSArray *layoutAttributes;
@property NSInteger numCells;
@property CGFloat radius;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end


@implementation DJCircleViewLayout

-(void)prepareLayout {
  _radius = (MIN(self.collectionView.frame.size.width,
                 self.collectionView.frame.size.height)
             / 2) - 50;
  _numCells = [self.collectionView numberOfItemsInSection:0];

}


-(CGSize)collectionViewContentSize {
  return self.collectionView.contentSize;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

  NSMutableArray * attrs = [NSMutableArray array];
  for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
    [attrs addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
  };
  return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
  attr.bounds = CGRectMake(0, 0, 50, 50);

  CGFloat indexFraction =  1.0f * indexPath.row / self.numCells;

  attr.center = CGPointMake(self.collectionView.center.x + (self.radius*indexFraction) * cosf( 8 * M_PI * indexFraction),
                            self.collectionView.center.y + (self.radius*indexFraction) * sinf( 8 * M_PI * indexFraction));

  // Show changes for selection of a cell

  if ([self.selectedIndexPath isEqual:attr.indexPath] ) {
    [self applySelectedCellAttributes:attr];
  }


  return attr;

}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return NO;
}

-(void)applySelectedCellAttributes:(UICollectionViewLayoutAttributes*)attr {
  attr.alpha =.7;
  attr.transform3D = CATransform3DScale(attr.transform3D, 2.0, 2.0, 2);
  attr.transform3D = CATransform3DRotate(attr.transform3D, .1 * M_PI, 0, 0, 1);
  attr.zIndex = INT32_MAX;
}

-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
  if (_selectedIndexPath == selectedIndexPath) {
    return;
  }
  _selectedIndexPath = selectedIndexPath;

  [self.collectionView performBatchUpdates:nil completion:nil];
}

@end
