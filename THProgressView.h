//
//  THProgressView.h
//
//  Created by Tiago Henriques on 10/22/13.
//  Copyright (c) 2013 Tiago Henriques. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface THProgressView : NSView


@property (nonatomic, strong) NSColor* progressTintColor;
@property (nonatomic, strong) NSColor* borderTintColor;
@property (nonatomic, strong) NSColor* backgroundColor;
@property (nonatomic) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end