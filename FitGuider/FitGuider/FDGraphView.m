//
//  FDGraphView.m
//  disegno
//
//  Created by Francesco Di Lorenzo on 14/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "FDGraphView.h"

@interface FDGraphView()

@property (nonatomic, strong) NSNumber *maxDataPoint;
@property (nonatomic, strong) NSNumber *minDataPoint;

@end

@implementation FDGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default values
        _edgeInsets = UIEdgeInsetsMake(10, 5, 5, 5);
        _dataPointColor = [UIColor whiteColor];
        //_dataPointStrokeColor = [UIColor blackColor];
        _dataPointStrokeColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        _linesColor = [UIColor grayColor];
        _autoresizeToFitData = YES;
        //_dataPointsXoffset = 30.0f;
        _dataPointsXoffset = 15.f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//initializtion parameter
-(NSInteger *)getWeek{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    
    return &week;
}

- (NSNumber *)maxDataPoint {
    if (_maxDataPoint) {
        return _maxDataPoint;
    } else {
        __block CGFloat max = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue > max)
                max = n.floatValue;
        }];
        return @(max);
    }
}

- (NSNumber *)minDataPoint {
    if (_minDataPoint) {
        return _minDataPoint;
    } else {
        __block CGFloat min = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue < min)
                min = n.floatValue;
        }];
        
               return @(min);
    }
}

- (CGFloat)widhtToFitData {
    CGFloat res = 0;
    
    if (self.dataPoints) {
        res += (self.dataPoints.count - 1)*self.dataPointsXoffset; // space occupied by data points
        res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    [self.linesColor setStroke];
    // lines width
    CGContextSetLineWidth(context, 1);
    
    // CALCOLO I PUNTI DEL GRAFICO
    //NSInteger count = self.dataPoints.count;
    NSInteger count = 7;
    
    NSInteger week=*(((NSInteger *)[self getWeek]));//get the weekday
    
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    __block CGFloat firstPint=((NSNumber *)self.dataPoints[0]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    
    //NSLog(@"min:%@",@(min));

    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSNumber *)self.dataPoints[i]).floatValue;
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;
            
            //calculate y
            if(max!=min){
            if((max-firstPint)>(firstPint-min))
            {
                if(dataPointValue>firstPint)
                y=rect.size.height/2-drawingHeight/2*((dataPointValue-firstPint)/(max-firstPint))+self.edgeInsets.top;
                else
                y=rect.size.height/2+drawingHeight/2*((firstPint-dataPointValue)/(max-firstPint))-self.edgeInsets.top;

            }
            else
            {
                if(dataPointValue>firstPint)
                    y=rect.size.height/2 - drawingHeight/2*((dataPointValue-firstPint)/(firstPint-min))+self.edgeInsets.bottom;
                
                else
                {
                    y=rect.size.height/2 + drawingHeight/2*((firstPint-dataPointValue)/(firstPint-min))-self.edgeInsets.bottom;

                }
            }
            }
            else
                y=rect.size.height/2;
            
            //if (max != min)
              //  y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
               // y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / min ) );
           //y=rect.size.height/2-(rect.size.height/min*dataPointValue/2)+rect.size.height/2;
          //  else // il grafico si riduce a una retta
               // y = rect.size.height/2;
           
            
            graphPoints[i] = CGPointMake(x, y);
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
    CGContextAddLines(context, graphPoints, count);
    CGContextStrokePath(context);
     //NSLog(@"week:%@",@(week));
    // DISEGNO I CERCHI NEL GRANO
    for (int i = 0; i < count; ++i) {
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-2, graphPoints[i].y-2, 4, 4);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        if(i<week)
        {
            //_dataPointStrokeColor=[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1];
            _dataPointStrokeColor=[UIColor colorWithRed:215/255.0 green:215/255.0  blue:25/255.0  alpha:1];

        }
            else
            _dataPointStrokeColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

        [_dataPointStrokeColor setStroke];
        [self.dataPointColor setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
    }
}

#pragma mark - Custom setters

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setDataPointsXoffset:(CGFloat)dataPointsXoffset {
    _dataPointsXoffset = dataPointsXoffset;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)setAutoresizeToFitData:(BOOL)autoresizeToFitData {
    _autoresizeToFitData = autoresizeToFitData;
    
    CGFloat widthToFitData = [self widhtToFitData];
    if (widthToFitData > self.frame.size.width) {
        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)setDataPoints:(NSArray *)dataPoints {
    _dataPoints = dataPoints;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

@end
