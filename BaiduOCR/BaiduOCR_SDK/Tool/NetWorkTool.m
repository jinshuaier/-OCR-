//
//  NetWorkTool.m
//  firstproject
//
//  Created by 牛新怀 on 2017/8/3.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NetWorkTool.h"
#import <AFNetworking.h>
@implementation NetWorkTool
+ (void)postNetWorkWithURL:(NSString *)url paramaters:(NSMutableDictionary *)paramatersDictionary success:(void(^)(id object))success failure:(void(^)(id failure))failure{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-www-form-urlencoded",nil];
    [manager POST:url parameters:paramatersDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSAssert(error, @"POST请求失败");
    }];

    
    
    
    
    
}


+ (void)postNetWorkWithImage:(UIImage *)image types:(CardType)types withURL:(NSString *)url paramaters:(NSMutableDictionary *)paramaters success:(void(^)(id object))success failure:(void(^)(id failure))failure{

    /*
     NSDataBase64Encoding64CharacterLineLength其作用是将生成的Base64字符串按照64个字符长度进行等分换行
     NSDataBase64Encoding76CharacterLineLength其作用是将生成的Base64字符串按照76个字符长度进行等分换行
     NSDataBase64EncodingEndLineWithCarriageReturn其作用是将生成的Base64字符串以回车结束
     NSDataBase64EncodingEndLineWithLineFeed其作用是将生成的Base64字符串以换行结束。
     */

    NSData* data = UIImagePNGRepresentation(image);
    NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    

     NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
    NSString * urlStr;
    /*
    https://aip.baidubce.com/rest/2.0/ocr/v1/driving_license  驾驶证识别，只需image
     https://aip.baidubce.com/rest/2.0/ocr/v1/vehicle_license。 行驶证识别。只需image
     */
//            urlStr = @"https://aip.baidubce.com/rest/2.0/ocr/v1/webimage_loc";// 银行卡正面识别
//            NSString *urlIamge = @"http://39.98.196.173:8081/tms/10/c4/10c47cdfcab30d2d7809169174aa2c41.png";
//
//    url = [NSString stringWithFormat:@"%@?access_token=%@",urlStr,[[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenKey]];
    
    
    urlStr = @"https://aip.baidubce.com/rest/2.0/ocr/v1/webimage_loc";// 身份证正面识别
    dictionary[@"image"] = imageStr;
    
    url = [NSString stringWithFormat:@"%@?access_token=%@",urlStr,[[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenKey]];
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-www-form-urlencoded",nil];
    [manager POST:url parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSAssert(error, @"POST请求失败");
    }];
    
    
}
    
//    NSDictionary *dic = @{@"url":urlIamge};
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 30;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-www-form-urlencoded",nil];
//    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//        NSAssert(error, @"POST请求失败");
//    }];
//
//
//}

+(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300;
    float maxWidth = 600;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
//    if (actualHeight > maxHeight || actualWidth > maxWidth)
//    {
//        if(imgRatio < maxRatio)
//        {
//            //adjust width according to maxHeight
//            imgRatio = maxHeight / actualHeight;
//            actualWidth = imgRatio * actualWidth;
//            actualHeight = maxHeight;
//        }
//        else if(imgRatio > maxRatio)
//        {
//            //adjust height according to maxWidth
//            imgRatio = maxWidth / actualWidth;
//            actualHeight = imgRatio * actualHeight;
//            actualWidth = maxWidth;
//        }
//        else
//        {
//            actualHeight = maxHeight;
//            actualWidth = maxWidth;
//        }
//    }
    
    CGRect rect = CGRectMake(0.0, 0.0, 500, 300);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}


@end
