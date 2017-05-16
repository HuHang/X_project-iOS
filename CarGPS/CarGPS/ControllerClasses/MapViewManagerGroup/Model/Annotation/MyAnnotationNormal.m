//
//  MyAnnotationNormal.m
//  CarGPS
//
//  Created by Charlot on 2017/5/15.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MyAnnotationNormal.h"

@implementation MyAnnotationNormal
-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubitle;
    }
    return self;
}
@end
