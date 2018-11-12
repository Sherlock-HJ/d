//
//  NetTool.h
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NetBlock)(id);
@interface NetTool : NSObject
+ (instancetype)share;
+ (NSURLSessionTask*)POST:(NSString*)urlStr parameters:(NSDictionary*)params;
@property (copy, nonatomic) NetBlock resBlock;



@end

NS_ASSUME_NONNULL_END
