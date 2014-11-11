//
//  Comment.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Comment.h"

@implementation Comment


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.author = dictionary[@"member_name"];
        self.date = [Comment dateFromNumber:dictionary[@"time"]];
        self.text = dictionary[@"comment"];
        
        self.memberID = dictionary[@"member_id"];
    }
    return self;
}

+ (NSArray *)objectsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Comment *e = [[Comment alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

+ (NSDate *) dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue] )];
    NSTimeInterval interval = [time doubleValue];
    return  [NSDate dateWithTimeIntervalSince1970:interval];
    
}

+ (void)retrieveEventWithString:(NSString *)eventID andCompletion:(void (^)(NSArray *, NSError *))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=1b4a6943b1b2d56681c436835c4073", eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               NSArray *jsonArray = [dict objectForKey:@"results"];

                               NSArray *dataArray = [Comment objectsFromArray:jsonArray];

                               complete (dataArray, connectionError);
                           }];

    
}


@end
