//
//  SFTagView.h
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTagButton.h"

@class SFTag;

@interface SFTagView : UIView

@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) int lineSpace;
@property (nonatomic, assign) CGFloat insets;
@property (nonatomic, strong) SFTagButton *btn;

- (void)addTag:(SFTag *)tag;

- (void)removeAllTags;

- (void)removeTagText:(NSString *)text;

@end
