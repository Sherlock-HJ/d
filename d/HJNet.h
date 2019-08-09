//
//  NetTool.h
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HJNetDelegate <NSObject>

- (void)responseSuccess:(id)results;
- (void)responseFailure:(id)results;

@end

@interface HJNet : NSObject

+ (NSURLSessionTask*)POST:(NSString*)urlStr parameters:(NSDictionary*)params  delegate:(id<HJNetDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
