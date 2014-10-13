//
//  MVASIHtttpRequest.h
//  JZMarket
//
//  Created by Maple on 7/20/13.
//  Copyright (c) 2013 Apps123. All rights reserved.
//

#import "ASIHTTPRequest.h"

void(^_listener)(NSDictionary*);

@protocol MVASIHtttpRequestDelegate;
@interface MVASIHtttpRequest : NSObject<ASIHTTPRequestDelegate>{

    int encodingNum;
}

@property (nonatomic,assign) id<MVASIHtttpRequestDelegate> delegate;
@property (nonatomic,retain) ASIHTTPRequest *asiRequest;

- (void)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr serverType:(int)serverType;

- (void)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr loadString:(NSString *)loadString serverType:(int)serverType listener:(void(^)(NSDictionary *))listener;

- (void)startRequest:(NSString *)loadString;

- (void)stopRequest;
- (void)clearRequest;
@end

@protocol MVASIHtttpRequestDelegate <NSObject>

- (void)mvAsiRequestDidFinish:(id)responseObject;
- (void)mvAsiRequestDidFail:(NSError *)error;

@end
