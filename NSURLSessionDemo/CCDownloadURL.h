//
//  CCDownloadURL.h
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import <Foundation/Foundation.h>

@interface CCDownloadURL : NSURL

@property (nonatomic, strong)NSData *resumeData;

@end
