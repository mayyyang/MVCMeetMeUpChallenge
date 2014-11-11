//
//  Member.h
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSURL *photoURL;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (void)retrieveMemberWithCompletion:(NSString *)memberID andCompletion:(void(^)(Member* member, NSError *error))complete;



//[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:member.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//    self.photoImageView.image = [UIImage imageWithData:data];
//
//



@end


