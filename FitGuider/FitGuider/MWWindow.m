//
//  MWWindow.m
//  MultipleWindow
//
//  Created by Jeremy Templier on 2/8/14.
// Copyright (c) 2014 Jeremy Templier
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MWWindow.h"

#define kRecuriveAnimationEnabled NO
#define kWindowHeaderHeight 80

@interface MWWindow() {
    CGPoint _origin;

}
@end

@implementation MWWindow

NSInteger firstTime = 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:panGesture];
        self.layer.cornerRadius = 10.0f;
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = .5f;
    }
    return self;
}

- (UIWindow *)superWindow
{
    NSArray * windows = [UIApplication sharedApplication].windows;
    NSInteger index = [windows indexOfObject:self];
    if (index) {
        return windows[index - 1];
    }
    return nil;
}

- (UIWindow *)nextWindow
{
    NSArray * windows = [UIApplication sharedApplication].windows;
    NSInteger index = [windows indexOfObject:self];
    if (index+1 < [windows count]) {
        return windows[index + 1];
    }
    return nil;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGFloat percentage;
    CGPoint translation = [pan translationInView:self];
    //NSLog(@"%f, %f", translation.x, translation.y);
    CGPoint velocity = [pan velocityInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _origin = self.frame.origin;
            NSLog(@"_origin = self.frame.origin; %f" , _origin.y);
            break;
        case UIGestureRecognizerStateChanged:
            if (translation.y >= 0) {
                NSLog(@"%@, %f", @"What is wrong", _origin.y);
                NSLog(@"%@, %f", @"self.frame.origin.y", self.frame.origin.y);
                NSLog(@"11111111111111111");
                self.transform = CGAffineTransformTranslate(self.transform,0, translation.y/2);
                //CGRectGetMinY(self.frame) equals translation.y
                percentage = CGRectGetMinY(self.frame) /(CGRectGetHeight([UIScreen mainScreen].bounds) - kWindowHeaderHeight);
                //NSLog(@"%@, %f", @"What is wrong", CGRectGetHeight([UIScreen mainScreen].bounds));
                
                //[self updateTransitionAnimationWithPercentage:percentage];
                //[self updateNextWindowTranslationIfNeeded];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint finalOrigin = CGPointZero;
            //self.frame.origin;
            NSLog(@"velocity.y: %f", velocity.y);
            if (velocity.y >= 0)
            {
                
                finalOrigin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - kWindowHeaderHeight;
            }
            CGRect f = self.frame;
            f.origin = finalOrigin;
            if(velocity.y < 0)
            {
                f.origin.y = 200;
            }

            NSLog(@"_origin.y: %f", _origin.y);
            NSLog(@"finalOrigin: %f", finalOrigin.y);
            [UIView animateWithDuration:1 delay:0.0 options:
                            UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformIdentity;
                self.frame = f;
                if (velocity.y < 0) {
                    //if(translation.y > 50)
                    {
                        [self cancelTransition];
                        //NSLog(@"velocity.y: %f",velocity.y);
                        //NSLog(@"cancel");
                    }
                } else {
                    
                    {
                        //NSLog(@"velocity.y: %f",velocity.y);
                        //NSLog(@"complete");
                        [self completeTransition];
                    }
                }
            } completion:^(BOOL finished) {
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateTransitionAnimationWithPercentage:(CGFloat)percentage
{
    UIWindow *window = self.superWindow;
    if (window) {
        //CGFloat scale = 1.0 - .05 * (1-percentage);
        //window.transform = CGAffineTransformMakeScale(scale, scale);
        window.transform = CGAffineTransformMakeScale(percentage, percentage);
        window.alpha = percentage;
        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(updateTransitionAnimationWithPercentage:)]) {
            //[(MWWindow *)window updateTransitionAnimationWithPercentage:percentage];
        }
    }
}

- (void)cancelTransition
{
    UIWindow *window = self.superWindow;
    if (window) {
        window.transform = CGAffineTransformMakeScale(1, 1);
        window.alpha = 1;
        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(cancelTransition)]) {
            //[(MWWindow *)window cancelTransition:percentage];
        }
    }
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        nextWindow.transform = CGAffineTransformIdentity;
        nextWindow.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}

- (void)completeTransition
{
    UIWindow *window = self.superWindow;
    if (window) {
        window.transform = CGAffineTransformIdentity;
        window.alpha = 1;
//        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(completeTransition)]) {
//            [(MWWindow *)window completeTransition];
//        }
    }
    [self completeNextWindowTranslation];
}

- (void)updateNextWindowTranslationIfNeeded
{
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        CGFloat diffY = fabs(CGRectGetMinY(nextWindow.frame) - CGRectGetMinY(self.frame));
        if (diffY < kWindowHeaderHeight) {
            nextWindow.transform = CGAffineTransformMakeTranslation(0, kWindowHeaderHeight-diffY);
        }
    }
}

- (void)completeNextWindowTranslation
{
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        nextWindow.transform = CGAffineTransformMakeTranslation(0, kWindowHeaderHeight);
    }
}
@end
