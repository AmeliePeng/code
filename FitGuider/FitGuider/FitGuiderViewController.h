//
//  FitGuiderViewController.h
//  FitGuider
//
//  Created by Amelie on 14-3-8.
//  Copyright (c) 2014年 COMP41550. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitGuiderViewController : UIViewController


@property (retain, nonatomic) IBOutlet UILabel *selectedIndex;


//Add master by Aaron Yang
- (IBAction)lastNumberAdd:(id)sender;
- (IBAction)lastNumberMinus:(id)sender;


@end
