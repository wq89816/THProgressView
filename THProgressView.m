//
//  THProgressView.m
//
//  Created by Tiago Henriques on 10/22/13.
//  Copyright (c) 2013 Tiago Henriques. All rights reserved.
//

#import "THProgressView.h"

#import <QuartzCore/QuartzCore.h>


static const CGFloat kBorderWidth = 2.0f;


#pragma mark -
#pragma mark THProgressView

@implementation THProgressView

@synthesize backgroundColor;
@synthesize borderTintColor;
@synthesize progressTintColor;
@synthesize progress;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self.backgroundColor set];
    NSRectFill(self.bounds);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [NSColor clearColor];
        
        [self setWantsLayer:YES];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [NSColor clearColor];
       
        [self setWantsLayer:YES];
        
    }
    return self;
}


#pragma mark Getters & Setters

- (void)setProgress:(CGFloat)progress1 animated:(BOOL)animated
{
    [self.layer removeAnimationForKey:@"progress"];
    CGFloat pinnedProgress = MIN(MAX(progress1, 0.0f), 1.0f);
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = fabsf(self.progress - pinnedProgress) + 0.1f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [self.layer addAnimation:animation forKey:@"progress"];
    }
   
    [self.layer setNeedsDisplay];
    
    [self setProgress:pinnedProgress];
}


- (void)drawRectangleInContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
    
}

#pragma mark - delegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
//    if ([layer isKindOfClass:[THProgressLayer class]]) return;
//    NSLog(@"%@",[layer class]);
    
    CGRect rect = CGRectInset(self.bounds, kBorderWidth, kBorderWidth);
    CGFloat radius = CGRectGetHeight(rect) / 2.0f;
    CGContextSetLineWidth(context, kBorderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderTintColor.CGColor);
    [self drawRectangleInContext:context inRect:rect withRadius:radius];
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
    CGRect progressRect = CGRectInset(rect, 2 * kBorderWidth, 2 * kBorderWidth);
    CGFloat progressRadius = CGRectGetHeight(progressRect) / 2.0f;
    progressRect.size.width = fmaxf(self.progress * progressRect.size.width, 2.0f * progressRadius);
    [self drawRectangleInContext:context inRect:progressRect withRadius:progressRadius];
    CGContextFillPath(context);
    
    [self setNeedsDisplay:YES];
}


@end
