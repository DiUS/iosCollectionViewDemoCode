//
//  DJCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Dallas Johnson on 1/02/2014.
//  Copyright (c) 2014 Dallasj. All rights reserved.
//

#import "DJCollectionViewController.h"
#import "DJGridFlowLayout.h"
#import "DJLeavesLayout.h"
#import "DJBasicCell.h"
#import "DJSelectedIndexProtocol.h"
#import "APBigGridViewFlowLayout.h"
#import "DJCircleViewLayout.h"


//The main controller - the bit we are interested in

@implementation DJCollectionViewController

static NSString *CellIdentifier = @"DJBasicCellIdentifier";
static NSString *GRIDFLOW = @"Grid";
static NSString *PHYSICSFLOW = @"Physics";
static NSString *COVERFLOW = @"CoverFlow";
static NSString *CIRCLEFLOW = @"Circle";




-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    //  self.collectionView.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

-(void)viewDidAppear:(BOOL)animated {
  [self.collectionViewLayout invalidateLayout];
  self.toolbarItems =
  @[
    [[UIBarButtonItem alloc] initWithTitle:GRIDFLOW style:UIBarButtonItemStyleBordered target:self action:@selector(setLayout:)],
    [[UIBarButtonItem alloc] initWithTitle:COVERFLOW style:UIBarButtonItemStyleBordered target:self action:@selector(setLayout:)],
    [[UIBarButtonItem alloc] initWithTitle:CIRCLEFLOW style:UIBarButtonItemStyleBordered target:self action:@selector(setLayout:)],
    [[UIBarButtonItem alloc] initWithTitle:PHYSICSFLOW style:UIBarButtonItemStyleBordered target:self action:@selector(setLayout:)]
    ];

  self.navigationController.toolbarHidden = NO;
}

-(void)viewDidLoad{
  [super viewDidLoad];
  [self.collectionView registerClass:[DJBasicCell class]
          forCellWithReuseIdentifier:CellIdentifier];
  [self.navigationController setNavigationBarHidden:YES];

}

#pragma mark - DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
  return 500;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  DJBasicCell *cell = (DJBasicCell*)[collectionView
                                     dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                     forIndexPath:indexPath];
  if (!cell) {
    NSLog(@"Failed to get a cell from the queue");
  }


  cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];

  return cell;
}

//optional

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
  return nil;
}

#pragma mark - delegate methods -- all optional

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{}

- (void)collectionView:(UICollectionView *)collectionView
didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{return YES;}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{return YES;}
// called when the user taps on an already-selected item in multi-select mode

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  id<DJSelectedIndexProtocol> layout =  (UICollectionViewLayout<DJSelectedIndexProtocol>*)[collectionView collectionViewLayout];
  [layout setSelectedIndexPath:indexPath];

}
- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath{}

- (void)collectionView:(UICollectionView *)collectionView
didEndDisplayingSupplementaryView:(UICollectionReusableView *)view
      forElementOfKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath{}

// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{return YES;}

- (BOOL)collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender{return YES;}

- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender{}

// support for custom transition layout
/*
 - (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
 transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout
 newLayout:(UICollectionViewLayout *)toLayout{return nil;}
 */

#pragma mark - Change Layouts

-(void)setLayout:(UIBarButtonItem*)sender{
  if ([sender.title isEqualToString:GRIDFLOW]) {
    [self.collectionView setCollectionViewLayout:[[DJGridFlowLayout alloc] init] animated:YES];
  } else if ([sender.title isEqualToString:PHYSICSFLOW]) {
    [self.collectionView setCollectionViewLayout:[[DJLeavesLayout alloc] init] animated:YES];
  } else if ([sender.title isEqualToString:COVERFLOW]) {
    [self.collectionView setCollectionViewLayout:[[APBigGridViewFlowLayout alloc] init] animated:YES];
  } else if ([sender.title isEqualToString:CIRCLEFLOW]) {
    [self.collectionView setCollectionViewLayout:[[DJCircleViewLayout alloc] init] animated:YES];
  }
}

@end


