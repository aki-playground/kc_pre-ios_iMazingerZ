//
//  AOAMazingerZ.m
//  iMazingerZ
//
//  Created by Akixe on 6/3/16.
//  Copyright © 2016 AOA. All rights reserved.
//

#import "AOAMazingerZ.h"

@implementation AOAMazingerZ

@synthesize coordinate = _coordinate;

-(id) init
{
    if(self = [super init]){
        _coordinate = CLLocationCoordinate2DMake(41.3827416, 1.32880926);
        //No se puede hacer self.coordinate si no intearía llamar a setCoordinate por KVO y da un error
    }
    return  self;
}

-(NSString *) title
{
    return @"Estatua de MazingerZ en Tarragona";
}

-(NSString *) subtitle
{
    return @"Imprescindible visitar este lugar si eres un poquillo friki";
}
@end
