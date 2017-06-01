//
//  ChildShopAnnotation.m
//  CarGPS
//
//  Created by Charlot on 2017/6/1.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ChildShopAnnotation.h"

@implementation ChildShopAnnotation
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
