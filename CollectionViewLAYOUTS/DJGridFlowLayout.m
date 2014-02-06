//
//  DJGridFlowLayout.m
//  CollectionViewDemo
//
//  Created by Dallas Johnson on 1/02/2014.
//  Copyright (c) 2014 Dallasj. All rights reserved.
//

#import "DJGridFlowLayout.h"
@interface DJGridFlowLayout ()
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation DJGridFlowLayout

-(id)init{
  self = [super init];
  if (self) {
    self.itemSize = CGSizeMake(50, 50);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumInteritemSpacing = 5.0f;
    self.minimumLineSpacing = 5.0f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

  }
  return self;

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *attrsList = [super layoutAttributesForElementsInRect:rect];
  [attrsList enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attr, NSUInteger idx, BOOL *stop) {
    if ([self.selectedIndexPath isEqual:attr.indexPath] ) {
      [self applySelectedCellAttributes:attr];
    }
  }];
  return attrsList;
}
/*
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
  if ([self.selectedIndexPath isEqual:attr.indexPath] ) {
    [self applySelectedCellAttributes:attr];
  }
  return attr;
}
*/
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
  return YES;
}

-(void)applySelectedCellAttributes:(UICollectionViewLayoutAttributes*)attr {
  attr.alpha =.7;
  attr.transform3D = CATransform3DScale(attr.transform3D, 5.0, 5.0, 5);
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
