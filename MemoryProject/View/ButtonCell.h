//
//  ButtonCell.h
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCell : UICollectionViewCell
@property (nonatomic,assign) kDataType type;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
