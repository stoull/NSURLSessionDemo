//
//  CCDownloadManager.h
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDownloadURL.h"

@interface CCDownloadManager : NSObject

@property (nonatomic, strong) id<NSURLSessionDownloadDelegate> delegate;


#pragma -mark 把我变成例模式

-(void)downloadWithURL:(CCDownloadURL *)url withTaskDescription:(NSString *)taskDescription;
// 文件云id下载测试
-(void)downloadWithFileID:(NSInteger)fileID withTaskDescription:(NSString *)taskDescription;

-(void)pauseDownloadWithTaskDescription:(NSString *)taskDescription;
-(void)resumeDownloadWithTaskDescription:(NSString *)taskDescription;
-(void)cancelDownloadWithTaskDescription:(NSString *)taskDescription;
-(void)delateFileWithTaskDescription:(NSString *)taskDescription;

- (void)upLoadDataArray:(NSArray *)dataArray;
@end
