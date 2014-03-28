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
#import "FDGraphView.h"
#import "FDGraphScrollView.h"
#import "MWWindow.h"
//#import "MWViewController.h"


#define TABLE_HEIGHT 80
#define kWindowHeaderHeight 80

@interface FitGuiderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MWWindow *nextWindow;

@property (nonatomic, retain) NSMutableArray* arrayForPlaces;
@property (nonatomic, strong) ADTickerLabel *firstTickerLabel;
@property (nonatomic, strong) ADTickerLabel *secondTickerLabel;
@property (nonatomic, strong) NSArray *numbersArray;
@property (nonatomic, unsafe_unretained) NSInteger currentIndex;
@property(nonatomic) NSInteger weight;


@end
@interface FitGuiderViewController ()


@end

@implementation FitGuiderViewController

NSInteger installOnce = 0;
-(void)updateWeightChart
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    

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
    
    [self readDict];

}

- (void)viewDidAppear:(BOOL)animated
{
    if(installOnce == 0)
    {
        
        _nextWindow = [[MWWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_nextWindow setBackgroundColor:[self randomColor]];
        _nextWindow.windowLevel = UIWindowLevelStatusBar;
        
        FitGuiderViewController *vc = [[FitGuiderViewController  alloc] initWithNibName:@"FitGuiderViewController" bundle:nil];
        //vc.view.backgroundColor = [UIColor clearColor];
        _nextWindow.rootViewController = vc;
//
        _nextWindow.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight([UIScreen mainScreen].bounds) - kWindowHeaderHeight);
//
        [_nextWindow makeKeyAndVisible];
        
        installOnce++;
    }
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}



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

/*write the weiht number in the property list
*premeter  float,the increase or decrease weight number
*property list with a dicinary include current time and weight arraylist
*weight arrylist include first time of weight,increase or dicrease number each day
*/


- (void)writeDict:(float)weightNum {
    NSDictionary *innerDict;
    NSString *name;
    NSArray *weightNumList;
    name=@"Amelie";
    NSDate *now=[NSDate date];
    weightNumList=[NSArray arrayWithObjects:[NSNumber numberWithFloat:97],[NSNumber numberWithFloat:weightNum],nil];
    NSString* plistPath_weight = [[NSBundle mainBundle] pathForResource:@"weight" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath_weight];

    innerDict = [NSDictionary dictionaryWithObjects:
                 [NSArray arrayWithObjects: name, now, weightNumList, nil]
    forKeys:[NSArray arrayWithObjects:@"Name", @"Time", @"Weight", nil]];
    //[rootObj setObject:innerDict forKey:@"Washington"];
    
    //NSInteger *weightNumStr=&weightNum;
    [data setObject:@"weightNum" forKey:@"weight"];
    [data setObject:@"now" forKey:@"date"];
    // get path
    NSString *home = NSHomeDirectory();
    NSString *documents = [home stringByAppendingPathComponent:@"Documents"];

    NSString *path = [documents stringByAppendingPathComponent:@"weight.plist"];
    
    [data writeToFile:path atomically:YES];
}

- (void)readDict {
    NSString* plistPath_weight = [[NSBundle mainBundle] pathForResource:@"weight" ofType:@"plist"];
    NSDictionary *dict_weight = [[NSDictionary alloc] initWithContentsOfFile:plistPath_weight];
    self.weight = [dict_weight objectForKey:@"weight"];
    //FDGraphScrollView
    FDGraphScrollView *scrollView = [[FDGraphScrollView alloc] initWithFrame:CGRectMake(10, 10, 200, 80)];
    scrollView.dataPoints = [dict_weight objectForKey:@"weight"];
    [self.view addSubview:scrollView];
   

}



- (IBAction)lastNumberAdd:(id)sender{
    //[self.firstTickerLabel setScrollDirection:ADTickerLabelScrollDirectionUp];
    self.currentIndex++;
    if(self.currentIndex == [self.numbersArray count])
        self.currentIndex = 0;
    self.firstTickerLabel.text = [NSString stringWithFormat:@"%@", self.numbersArray[self.currentIndex]];
   //
    // NSLog(@"weight:%ld",(long)self.weight);
   [self writeDict:self.currentIndex];
    [self readDict];
   
}



- (IBAction)lastNumberMinus:(id)sender {
    //[self.firstTickerLabel setScrollDirection:ADTickerLabelScrollDirectionDown];
    if(self.currentIndex == 0)
        self.currentIndex = [self.numbersArray count];
    self.currentIndex--;
    self.firstTickerLabel.text = [NSString stringWithFormat:@"%@", self.numbersArray[self.currentIndex]];
 //
    // NSLog(@"weight:%ld",(long)self.weight);
    [self writeDict:self.currentIndex];
    [self readDict];
   
}

@end
