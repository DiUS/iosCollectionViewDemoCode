

#import <UIKit/UIKit.h>
#import "DJSelectedIndexProtocol.h"

@interface APBigGridViewFlowLayout : UICollectionViewFlowLayout <DJSelectedIndexProtocol>
@property (nonatomic,strong) NSIndexPath * selectedIndexPath;
@end
