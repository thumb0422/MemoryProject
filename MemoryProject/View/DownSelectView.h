//
//  DownSelectView.h
//  Security
//
//  Created by chliu.brook on 24/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownSelectView;
@protocol DownSelectViewDelegate <NSObject>
@optional
- (void)downSelectedView:(DownSelectView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath;
@end

@interface DownSelectView : UIView

@property (nonatomic, weak) id <DownSelectViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *listArray;

/// 一些控件属性
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *text;


- (void)show;
- (void)close;

@end
