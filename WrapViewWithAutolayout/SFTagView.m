//
//  SFTagView.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "SFTagView.h"
#import "SFTag.h"

@interface SFTagView ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (assign) CGFloat intrinsicHeight;

@end

@implementation SFTagView {
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, self.intrinsicHeight);
}

- (void)addTag:(SFTag *)tag {
    self.btn = [[SFTagButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.btn.tag = tag.tag;
    self.btn.layer.masksToBounds = YES;
    if (tag.borderColor) {
        self.btn.layer.borderColor = tag.borderColor.CGColor;
    }
    self.btn.layer.borderWidth = tag.borderWidth;
    [self.btn setTitle:tag.text forState:UIControlStateNormal];
    [self.btn.titleLabel setFont:tag.font];
    [self.btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.btn setBackgroundImage:[self createImageWithColor:tag.bgColor] forState:UIControlStateNormal];
    if (tag.highlightedBgColor) {
        [self.btn setBackgroundImage:[self createImageWithColor:tag.highlightedBgColor] forState:UIControlStateHighlighted];
    }
    if (tag.selectedBgColor) {
        [self.btn setBackgroundImage:[self createImageWithColor:tag.selectedBgColor] forState:UIControlStateSelected];
    }
    [self.btn setTitleColor:tag.textColor forState:UIControlStateNormal];
    if (tag.highlightedTextColor) {
        [self.btn setTitleColor:tag.highlightedTextColor forState:UIControlStateHighlighted];
    }
    if (tag.selectedTextColor) {
        [self.btn setTitleColor:tag.selectedTextColor forState:UIControlStateSelected];
    }
    [self.btn addTarget:tag.target action:tag.action forControlEvents:UIControlEventTouchUpInside];

    CGSize size;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
#ifdef __IPHONE_7_0
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];

    NSDictionary *stringAttributes = @{NSFontAttributeName: tag.font,
                                       NSParagraphStyleAttributeName: paragraphStyle};
    size = [tag.text boundingRectWithSize:constraintSize
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:stringAttributes
                                  context:nil]
               .size;
#else
    size = [tag.text sizeWithFont:tag.font
                constrainedToSize:constraintSize
                    lineBreakMode:NSLineBreakByCharWrapping];
#endif

    CGFloat i = tag.inset;
    if (i == 0) {
        i = 5;
    }
    size.width += i * 2;
    size.height += i * 2;

    self.btn.layer.cornerRadius = tag.cornerRadius;
    [self.btn.layer setMasksToBounds:YES];

    //  CGSize size = btn.intrinsicContentSize;
    CGFloat maxWidth = self.frame.size.width - self.insets * 2;
    if (size.width > maxWidth) {
        size.width = maxWidth;
    }
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    [self.btn setFrame:r];

    [self.tags addObject:self.btn];

    [self rearrangeTags];
}

#pragma mark - Tag removal

- (void)removeTagText:(NSString *)text {
    SFTagButton *b = nil;
    for (SFTagButton *t in self.tags) {
        if ([text isEqualToString:t.titleLabel.text]) {
            b = t;
        }
    }

    if (!b) {
        return;
    }

    [b removeFromSuperview];
    [self.tags removeObject:b];
    [self rearrangeTags];
}

- (void)removeAllTags {
    for (SFTagButton *t in self.tags) {
        [t removeFromSuperview];
    }
    [self.tags removeAllObjects];
    [self rearrangeTags];
}

- (void)rearrangeTags {
    self.intrinsicHeight = 0;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    __block float maxY = self.margin.top;
    __block float maxX = self.margin.left;
    __block CGSize size;
    [self.tags enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
        size = obj.frame.size;
        [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[SFTagButton class]]) {
                maxY = MAX(maxY, obj.frame.origin.y);
            }
        }];

        [self.subviews enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[SFTagButton class]]) {
                if (obj.frame.origin.y == maxY) {
                    maxX = MAX(maxX, obj.frame.origin.x + obj.frame.size.width);
                }
            }
        }];

        // Go to a new line if the tag won't fit
        if (size.width + maxX + self.insets > (self.frame.size.width - self.margin.right)) {
            maxY += size.height + self.lineSpace;
            maxX = self.margin.left;
        }
        obj.frame = (CGRect){maxX + self.insets, maxY, size.width, size.height};
        [self addSubview:obj];
    }];

    CGRect r = self.frame;
    CGFloat n = maxY + size.height + self.margin.bottom;
    self.intrinsicHeight = n > self.intrinsicHeight ? n : self.intrinsicHeight;
    [self setFrame:CGRectMake(r.origin.x, r.origin.y, self.frame.size.width, self.intrinsicHeight)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self rearrangeTags];
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

@end
