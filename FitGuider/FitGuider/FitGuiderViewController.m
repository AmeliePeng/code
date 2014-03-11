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

<<<<<<< HEAD
#define TABLE_HEIGHT 80

@interface FitGuiderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray* arrayForPlaces;
=======
@interface FitGuiderViewController ()
<<<<<<< HEAD

=======
>>>>>>> 5be7c3e461e88654c9e2947c0312e51bc350749c
>>>>>>> FETCH_HEAD
@end

@implementation FitGuiderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.arrayForPlaces = [plistDict objectForKey:@"Data"];
    
	// Do any additional setup after loading the view, typically from a nib.
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

@end
