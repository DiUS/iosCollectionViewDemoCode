//
//  DJLeavesLayout.m
//  CollectionViewLAYOUTS
//
//  Created by Dallas Johnson on 3/02/2014.
//  Copyright (c) 2014 Dallasj. All rights reserved.
//

#import "DJLeavesLayout.h"

@interface DJLeavesLayout ()
@property (nonatomic,strong) UIDynamicAnimator * animator;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation DJLeavesLayout


-(id)init {
  self = [super init];
  if (self) {
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.itemSize = CGSizeMake(50,50);
    self.sectionInset = UIEdgeInsetsMake(0,14, 0, 14);
    self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
  }
  return self;
}

-(void)prepareLayout {
  [super prepareLayout];
  CGSize contentSize = self.collectionView.contentSize;
  NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
  if (self.animator.behaviors.count == 0) {
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:[obj center]];

      behaviour.length = 4.0f; // Loosness between cells
      behaviour.damping = 0.25f; // continuation of bouncing
      behaviour.frequency = 0.70f; // viscosity
      [self.animator addBehavior:behaviour];
    }];
  }
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *attrs = [self.animator itemsInRect:rect];
  [attrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attr, NSUInteger idx, BOOL *stop) {
    if ([attr.indexPath isEqual:self.selectedIndexPath]) {
      [self highlightAttributes:attr];
    }
  }];
  return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath isEqual:self.selectedIndexPath]) {
    UICollectionViewLayoutAttributes *attr = [self.animator layoutAttributesForCellAtIndexPath:indexPath];
    [self highlightAttributes:attr];
    return attr;
  }
  return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

  UIScrollView *scrollView = self.collectionView;
  CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;

  CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
  //Handling the progressive affect of dragging for each cell that is further away from the pan touch point.
  [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
    CGFloat yDistFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
    CGFloat xDistFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
    CGFloat scrollRestistance = (yDistFromTouch + xDistFromTouch) / 1000.0f;
    UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
    CGPoint center = item.center;
    if (delta < 0) {
      center.y += MAX(delta, delta * scrollRestistance);
    } else {
      center.y += MIN(delta, delta * scrollRestistance);
    }
    item.center = center;
   [self.animator updateItemUsingCurrentState:item];
  }];

  return YES;

}

-(void)highlightAttributes:(UICollectionViewLayoutAttributes*) attr {

  attr.alpha =1;
  attr.transform3D = CATransform3DScale(attr.transform3D, 2.0, 2.0, 0);
  attr.zIndex = INT32_MAX;
  attr.transform = CGAffineTransformMakeScale(2, 2);
}


-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
  if (_selectedIndexPath == selectedIndexPath) {
    return;
  }
  _selectedIndexPath = selectedIndexPath;

  [self.collectionView performBatchUpdates:nil completion:nil];
}




@end
