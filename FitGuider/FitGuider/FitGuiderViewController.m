//
//  FitGuiderViewController.m
//  FitGuider
//
//  Created by Amelie on 14-3-8.
//  Copyright (c) 2014年 COMP41550. All rights reserved.
//

#import "FitGuiderViewController.h"
#import "SampleCell.h"
#import "DetailViewController.h"
#import "ADTickerLabel.h"


<<<<<<< HEAD
@interface FitGuiderViewController ()

=======
>>>>>>> hi_man
#define TABLE_HEIGHT 80

@end
@interface FitGuiderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray* arrayForPlaces;
<<<<<<< HEAD
=======
@property (nonatomic, strong) ADTickerLabel *firstTickerLabel;
@property (nonatomic, strong) ADTickerLabel *secondTickerLabel;
@property (nonatomic, strong) NSArray *numbersArray;
@property (nonatomic, unsafe_unretained) NSInteger currentIndex;
>>>>>>> hi_man

@end
@interface FitGuiderViewController ()

<<<<<<< HEAD

=======
>>>>>>> hi_man
@end

@implementation FitGuiderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    
<<<<<<< HEAD
	// Do any additional setup after loading the view, typically from a nib.
    }
=======
//
    self.currentIndex = 0;
    self.numbersArray = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
    
    UIFont *font = [UIFont boldSystemFontOfSize: 30];
    
    self.firstTickerLabel = [[ADTickerLabel alloc] initWithFrame: CGRectMake(180, 50, 0, font.lineHeight)];
    self.firstTickerLabel.font = font;
    self.firstTickerLabel.characterWidth = 22;
    self.firstTickerLabel.changeTextAnimationDuration = 0.3;
    [self.view addSubview: self.firstTickerLabel];
    self.firstTickerLabel.text = [NSString stringWithFormat:@"%@", @"0"];
}
>>>>>>> hi_man

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayForPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:@"SampleCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    
    cell.labelForPlace.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Place"]];
    cell.labelForCountry.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Country"]];
    cell.imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    DetailViewController* detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    
    NSMutableDictionary* dict = [self.arrayForPlaces objectAtIndex:indexPath.row];
    detailViewController.dictForData = dict;
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    NSLog(@"Self:%@",self.navigationController);
    
    [self.navigationController pushViewController:detailViewController animated:NO];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal; [self presentViewController:detailViewController animated:YES completion:nil];
}

/*
*
*
*
*/
- (IBAction)lastNumberAdd:(id)sender{
    //[self.firstTickerLabel setScrollDirection:ADTickerLabelScrollDirectionUp];
    self.currentIndex++;
    if(self.currentIndex == [self.numbersArray count])
        self.currentIndex = 0;
    self.firstTickerLabel.text = [NSString stringWithFormat:@"%@", self.numbersArray[self.currentIndex]];
    
    
    
}


- (IBAction)lastNumberMinus:(id)sender {
    //[self.firstTickerLabel setScrollDirection:ADTickerLabelScrollDirectionDown];
    if(self.currentIndex == 0)
        self.currentIndex = [self.numbersArray count];
    self.currentIndex--;
    self.firstTickerLabel.text = [NSString stringWithFormat:@"%@", self.numbersArray[self.currentIndex]];
}

@end
