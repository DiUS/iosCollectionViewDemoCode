
#import "APBigGridViewFlowLayout.h"

@implementation APBigGridViewFlowLayout

#define ACTIVE_DISTANCE 700
#define ZOOM_FACTOR 0.3f


- (id)init {
  if ((self = [super init])) {
    self.itemSize = CGSizeMake(256, 420);
    self.minimumLineSpacing = 40;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  }
  return self;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
  NSArray* array = [super layoutAttributesForElementsInRect:rect];
  CGRect visibleRect;
  visibleRect.origin = self.collectionView.contentOffset;
  visibleRect.size = self.collectionView.bounds.size;

  NSMutableArray *newAttributes = [array mutableCopy];
  for (UICollectionViewLayoutAttributes* attributes in array) {

    if (CGRectIntersectsRect(attributes.frame, rect)) {
      CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
      CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
      if (ABS(distance) < ACTIVE_DISTANCE) {
        CGFloat zoom = 1.4f * (1.0f - ABS(normalizedDistance));
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        attributes.transform3D = CATransform3DTranslate(attributes.transform3D,1, 1, -(ABS(distance)-20)); // keep middle at front using z index

        CATransform3D rotationWithPerspective = CATransform3DIdentity;
        rotationWithPerspective.m34 = -1.0/400.0;
        rotationWithPerspective = CATransform3DRotate(rotationWithPerspective, -distance / 450* M_1_PI, 0, 1, 0);

        attributes.transform3D = CATransform3DConcat(attributes.transform3D, rotationWithPerspective);
      }
    }
  }
  return newAttributes;
}



- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
  //snap scroll to a center cell
  CGFloat offsetAdjustment = MAXFLOAT;
  CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds)/2);

  CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
  NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];

  for (UICollectionViewLayoutAttributes * attributes in attrs) {
    CGFloat itemCenter = attributes.center.x;
    if (ABS(itemCenter - horizontalCenter) < ABS(offsetAdjustment)) {
      offsetAdjustment = itemCenter - horizontalCenter;
    }
  }

  return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
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
