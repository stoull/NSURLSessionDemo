//
//  CCDownloadManager.m
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import "CCDownloadManager.h"


@interface CCDownloadManager()
@property NSString *resumeDataPath;


@property (nonatomic, strong) NSMutableDictionary *taskDic;
@property (nonatomic, strong) NSFileManager *fileMgr;

/**
 *创建session属性
 */
@property (nonatomic, strong) NSURLSession *downloadSession;
@property (nonatomic, strong) NSURLSession *uploadSession;


@end

@implementation CCDownloadManager
@synthesize resumeDataPath;
-(NSMutableDictionary *)taskDic
{
    if (!_taskDic) {
        _taskDic = [NSMutableDictionary dictionary];
        resumeDataPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _taskDic;
}
- (NSFileManager *)fileMgr
{
    if(!_fileMgr)
    {
        _fileMgr = [NSFileManager defaultManager];
    }
    return _fileMgr;
}

-(NSURLSession *)uploadSession
{
    if (!_uploadSession) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _uploadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self.delegate delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _uploadSession;
}


-(NSURLSession *)downloadSession
{
    if (!_downloadSession) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _downloadSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self.delegate delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _downloadSession;
}

-(void)downloadWithURL:(CCDownloadURL *)url withTaskDescription:(NSString *)taskDescription{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downLoadTask = [[NSURLSessionDownloadTask alloc] init];
    downLoadTask = [self.downloadSession downloadTaskWithRequest:request];
    downLoadTask.taskDescription = taskDescription;
    [self.taskDic setObject:downLoadTask forKey:taskDescription];

    [downLoadTask resume];
}

-(void)downloadWithFileID:(NSInteger)fileID withTaskDescription:(NSString *)taskDescription{
    
    
//    /apiLogin.action?username=username&password=password
    NSString *logIn = @"http://demo.linkapp.cn/apiLogin.action?username=chencc&password=linkapp2015";
    NSURLRequest *requ = [NSURLRequest requestWithURL:[NSURL URLWithString:logIn]];
    [NSURLConnection sendAsynchronousRequest:requ queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *downFileString = [NSString stringWithFormat:@"http://demo.linkapp.cn/disk/download.action?id=%ld",fileID];
        
        //    NSString *host = @"http://demo.linkapp.cn/";
        NSString *userid =@"chencc";
        NSString *password =@"linkapp2015";
        
        // 创建请求
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:downFileString]];
        request.HTTPMethod=@"GET";
        
        // 生成请求头
        NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", userid, password];
        NSMutableDictionary *defaultHeaders = [NSMutableDictionary dictionary];
        defaultHeaders[@"Authorization"] = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        defaultHeaders[@"User-Agent"] = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
        defaultHeaders[@"User-Agent"] = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
        
        // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
        NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
        [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            float q = 1.0f - (idx * 0.1f);
            [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
            *stop = q <= 0.5f;
        }];
        
        
        defaultHeaders[@"Accept"] = @"application/octet-stream";
        
        //构建请求头
        request.allHTTPHeaderFields = defaultHeaders;
        [request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval: 60];
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        
//        [request setValue:[NSString stringWithFormat:@"1352435200"] forHTTPHeaderField:@"Content-Length"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLSessionDownloadTask *downLoadTask = [[NSURLSessionDownloadTask alloc] init];
            //    downLoadTask = [self.downloadSession downloadTaskWithRequest:request];
//            downLoadTask = [self.downloadSession downloadTaskWithRequest:request];
            [self.downloadSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                NSLog(@"%@",response);
            }];
            
            
            downLoadTask.taskDescription = taskDescription;
            [self.taskDic setObject:downLoadTask forKey:taskDescription];
            [downLoadTask resume];
        });
    }];

}



-(void)pauseDownloadWithTaskDescription:(NSString *)taskDescription{
    if (!taskDescription) {
        return;
    }
    __block NSURLSessionDownloadTask *task = [self.taskDic objectForKey:taskDescription];
    [task cancelByProducingResumeData:^(NSData *resumeData) {
        [resumeData writeToFile:[resumeDataPath stringByAppendingPathComponent:taskDescription] atomically:YES];
        task = nil;
        [self.taskDic removeObjectForKey:taskDescription];
    }];
}

-(void)resumeDownloadWithTaskDescription:(NSString *)taskDescription{
    if (!taskDescription) {
        return;
    }
    __block NSURLSessionDownloadTask *task = [self.taskDic objectForKey:taskDescription];
    NSString *resumeDataString = [resumeDataPath stringByAppendingPathComponent:taskDescription];
    task = [self.downloadSession downloadTaskWithResumeData:[NSData dataWithContentsOfFile:resumeDataString]];
    task.taskDescription = taskDescription;
    [task resume];
    [self.taskDic setValue:task forKey:taskDescription];
    [self.fileMgr removeItemAtPath:resumeDataString error:nil];
}

-(void)cancelDownloadWithTaskDescription:(NSString *)taskDescription{
    if (!taskDescription) {
        return;
    }
    NSURLSessionDownloadTask *task = [self.taskDic objectForKey:taskDescription];
    [task cancel];
    [self.fileMgr removeItemAtPath:[resumeDataPath stringByAppendingPathComponent:taskDescription] error:nil];
}

-(void)delateFileWithTaskDescription:(NSString *)taskDescription{
    NSURLSessionDownloadTask *task = [self.taskDic objectForKey:taskDescription];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *saveFilePath = [documentPath stringByAppendingPathComponent:task.response.suggestedFilename];
    [[NSFileManager defaultManager] removeItemAtPath:saveFilePath error:nil];
}





- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    //1.修改文件名
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *saveFilePath = [documentPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    //2.剪切
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:saveFilePath error:nil];
    NSLog(@"保存地址：%@",saveFilePath);
}




#pragma -mark 测试文件云上传进度
- (void)upLoadDataArray:(NSArray *)dataArray
{
    for (NSData *data in dataArray)
    {
//        URL: http://demo.linkapp.cn/webdav/%E6%88%91%E7%9A%84%E6%96%87%E4%BB%B6/%E6%88%91%E7%9A%84%E7%85%A7%E7%89%87/2015-10-19-15-50-570.jpg/
        NSString *host = @"http://demo.linkapp.cn/";
        NSString *userid =@"chencc";
        NSString *password =@"linkapp2015";
        
        // 生成URL,如果是照片那照片的命名是用这个格式yyyy-MM-dd-HH-mm-ss
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSString *path = @"webdav/%E6%88%91%E7%9A%84%E6%96%87%E4%BB%B6/";//webdav/我的文件
        NSString *lfsURL;

        path = @"webdav/%E6%88%91%E7%9A%84%E6%96%87%E4%BB%B6/%E6%88%91%E7%9A%84%E7%85%A7%E7%89%87/";
        lfsURL = [NSString stringWithFormat:@"%@%@%@.jpg",host,path,dateString];
        
        NSURL *url=[NSURL URLWithString:lfsURL];
        if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
            url = [url URLByAppendingPathComponent:@""];
        }
        // 创建请求
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod=@"PUT";
        
        // 生成请求头
        NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", userid, password];
        NSMutableDictionary *defaultHeaders = [NSMutableDictionary dictionary];
        defaultHeaders[@"Authorization"] = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
        defaultHeaders[@"User-Agent"] = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
        defaultHeaders[@"User-Agent"] = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
        
        // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
        NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
        [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            float q = 1.0f - (idx * 0.1f);
            [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
            *stop = q <= 0.5f;
        }];
        
        
        defaultHeaders[@"Accept"] = @"application/octet-stream";
        
        //构建请求头
        request.allHTTPHeaderFields = defaultHeaders;
        [request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
        [request setTimeoutInterval: 60];
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            request.HTTPBodyStream = [NSInputStream inputStreamWithData:data];
            [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
            
            // 用自定义代理的方式获取上传信息
            NSURLSessionUploadTask *upTask = [self.uploadSession uploadTaskWithRequest:request fromData:data];
            [upTask resume];
            
            
            // 有block回调的方式获取上传信息
            //创建会话
//            NSURLSession *session=[NSURLSession sharedSession];
//            NSURLSessionUploadTask *uploadTask=[session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                if (!error) {
//                    NSString *dataStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"Successful!:%@",dataStr);
//                }else{
//                    NSLog(@"error is :%@",error.localizedDescription);
//                }
//            }];
//            [uploadTask resume];
        });
    }
}

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}
@end
