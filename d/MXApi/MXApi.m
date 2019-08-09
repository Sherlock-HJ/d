//
//  MXApi.m
//  d
//
//  Created by lyt on 2018/11/19.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "MXApi.h"
#import <objc/runtime.h>

#import "HJSecurity.h"

@implementation NSString (MXApi)
- (NSString *)urlencodeAll{
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "].invertedSet];
}
- (NSString *)urlencodeKeyValue{
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end

@implementation NSDictionary (MXApi)

- (NSData*)HTTPBody{
    
    return [self.query.urlencodeKeyValue dataUsingEncoding:NSUTF8StringEncoding];
    
}

- (NSString *)query{
    NSMutableString *mutStr = [NSMutableString string];
    __block NSInteger num = 0;
    NSInteger count = self.count;
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {

        if (key.length > 0 && obj.length > 0) {
            if (count-1 > num) {
                [mutStr appendFormat:@"%@=%@&",key,obj];
            }else{
                [mutStr appendFormat:@"%@=%@",key,obj];
            }
        }
     
        num++;
    }];
    return mutStr ;
}
@end



@implementation MXObject (MXApi)

/// 获取对象的所有属性 以及属性值
- (NSDictionary *)toDictionary

{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray * props = [self getPropertiesForClass:[self class]];
    
    for (NSString* pro in props) {
        id value= [self valueForKey:pro];
        if (value) {
            if (![value isKindOfClass:[NSString class]]) {
                value = [NSString stringWithFormat:@"%@",value];
            }
            dic[pro] = value;
        }
    }
    
    return dic;
    
}
- (NSMutableArray*)getPropertiesForClass:(Class)cls{
    NSMutableArray *props = [NSMutableArray array];
    
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        [props addObject:[NSString stringWithUTF8String:char_f]];
        
    }
    free(properties);
    
    Class supcls = class_getSuperclass(cls);
    if (![supcls isEqual:[MXObject class]]) {
        [props addObjectsFromArray:[self getPropertiesForClass:supcls]];
    }
    
    return props;
}
//将字典转成当前对象
- (void)toObjectWithDictionary:(NSDictionary*)dictionary
{
    NSArray *propertys = [self getPropertiesForClass:[self class]];
    for (NSString *property in propertys) {
        id propertyValue = [dictionary valueForKey:property];
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil) {
            [self setValue:propertyValue forKey:property];
        }
        
    }
}
- (id)toResp{
    
    NSString* aClassName = NSStringFromClass([self class]);
    aClassName = [aClassName stringByReplacingOccurrencesOfString:@"Req" withString:@"Resp"];
    return [[NSClassFromString(aClassName) alloc]init];
    
}

- (id)assignmentRespFromResults:(id)results{
    if ([results isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (id result in results) {
            [self toObjectWithDictionary:result];
            [arr addObject:self];
        }
        return  arr;
    }
    if ([results isKindOfClass:[NSDictionary class]]){
        [self toObjectWithDictionary:results];
        return self;
    }
    if ([results isKindOfClass:[NSString class]]){
        return results;
    }
    return nil;
}

- (NSString *)generateSign{
    
   NSDictionary* tmpDict = self.toDictionary;
    // NOTE: 排序，得出最终请求字串
    NSArray* sortedKeyArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = nil;
        NSString *value = tmpDict[key];
        if (key.length > 0 && value.length > 0) {
            orderItem = [NSString stringWithFormat:@"%@=%@", key, value];
        }
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    NSString* plainStr = [tmpArray componentsJoinedByString:@"&"];

    NSString *sign = [HJSecurity signSHA256PlainData:[@"a=1&b=2" dataUsingEncoding:NSUTF8StringEncoding] privateKeyData:[NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/MXApi/coinapi.p12"] password:@"1111"];
    return  sign;
}

- (NSString *)urlencode{
    
    return  self.toDictionary.query.urlencodeAll;

}
@end

@interface MXApi ()

@end

@implementation MXApi
+ (NSMutableURLRequest*)mutableRequest{
    NSURL *url = [NSURL URLWithString:@"http://192.168.113.107/CoinFlow/index.php"];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return mutableRequest;
}
+ (BOOL)sendReq:(BaseReq *)req success:(void (^)(id _Nullable response))success failure:(void (^)(ErrorResp * _Nullable response))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:req.toDictionary];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *mutableRequest = [self mutableRequest];
    mutableRequest.HTTPBody = params.HTTPBody ;
    
    NSURLSessionTask * task = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && failure) {
            ErrorResp * resp = [ErrorResp response];
            resp.error_info = error.localizedDescription;
            failure(resp);
            return ;
        }
        
        id results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!results) {
            results = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        
        NSHTTPURLResponse* HTTPResponse = (NSHTTPURLResponse*)response;
        if (HTTPResponse.statusCode >=200 && HTTPResponse.statusCode < 300 ) {
            
            id resp = [req.toResp assignmentRespFromResults:results];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                if (success) {
                    success(resp);
                }
            }];
        }else{
            ErrorResp * resp = [ErrorResp response];
            id resp1 = [resp assignmentRespFromResults:results];
            if ([resp1 isKindOfClass:[NSString class]]) {
                resp.error_info = resp1;
            }
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                if (failure) {
                    failure(resp);
                }
            }];
            
        }
        
    }];
    [task resume];
    
    return YES;
}


@end
