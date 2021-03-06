//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];
    
    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
        
    }
    return newArray;
}

+ (void)performSearchWithKeyword:(NSString *)keyword andCompletion:(void (^)(NSArray *, NSError *))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=1b4a6943b1b2d56681c436835c4073",keyword]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {

                               NSError *JSONError = nil;

                               if (!connectionError)
                               {

                                   NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&JSONError] objectForKey:@"results"];
                                   if (!JSONError)
                                   {
                                       NSArray *dataToReturnArray = [Event eventsFromArray:jsonArray];

                                       complete (dataToReturnArray, connectionError);
                                   }

                               else
                               {
                                   complete (nil, JSONError);
                               }
                               }
                               else
                               {
                                   complete (nil, connectionError);
                               }

                           }];

}

- (void)retrieveImageDataWithCompletion:(void (^)(NSData *, NSError *))complete
{

        NSURLRequest *imageReq = [NSURLRequest requestWithURL:self.photoURL];
    
        [NSURLConnection sendAsynchronousRequest:imageReq
                                           queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
            dispatch_async(dispatch_get_main_queue(), ^
        {
                if (!connectionError)
                {
                    complete (data, connectionError);
                }

                else
                {
                    complete (nil , connectionError);
                }
            });
    
    
        }];
    
}






@end


