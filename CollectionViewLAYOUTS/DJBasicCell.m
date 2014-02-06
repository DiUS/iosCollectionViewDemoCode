//
//  DJBasicCell.m
//  CollectionViewLAYOUTS
//
//  Created by Dallas Johnson on 2/02/2014.
//  Copyright (c) 2014 Dallasj. All rights reserved.
//

#import "DJBasicCell.h"

//Simple Custom Cell For illustration purposes

@implementation DJBasicCell

-(void)prepareForReuse {
  [super prepareForReuse];
  //only called when reuring from the queue
  //Good place to reset back to init state without re-drawing whole view. eg reset colour after selection.
  [self resetCellColor];
}

-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:CGRectMake(0, 0, 50, 50)];
  if (self) {
     _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
     [self.contentView addSubview:_label];
    [self resetCellColor];
  }
  return self;
}

-(void) resetCellColor{
  self.contentView.backgroundColor = [UIColor colorWithRed:[self randomFloat] green:[self randomFloat] blue:[self randomFloat] alpha:1];

}

-(CGFloat)randomFloat{
  return (arc4random() % 100) / 100.0f;
}


@end
