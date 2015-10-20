//
//  CCViewController.m
//  
//
//  Created by 杜强海 on 10/17/15.
//
//

#import "CCViewController.h"
#import "CCIndicatorView.h"
#import "CCDownloadManager.h"


@interface CCViewController ()
@property (weak, nonatomic) IBOutlet CCIndicatorView *indicator1;
@property (weak, nonatomic) IBOutlet CCIndicatorView *indicator2;
@property (weak, nonatomic) IBOutlet CCIndicatorView *indicator3;
@property (weak, nonatomic) IBOutlet CCIndicatorView *indicator4;
@property (weak, nonatomic) IBOutlet CCIndicatorView *uploadIndicator1;

@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel1;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel2;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel3;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLabel4;

@property (weak, nonatomic) IBOutlet UILabel *upLoadIndicatorLabel1;



@property (nonatomic, strong) NSMutableDictionary *taskDic;

@property (nonatomic, strong) CCDownloadManager *taskMananger;


@end

@implementation CCViewController
-(NSMutableDictionary *)taskDic
{
    if (!_taskDic) {
        _taskDic = [NSMutableDictionary dictionary];
    }
    return _taskDic;
}

-(CCDownloadManager *)taskMananger
{
    if (!_taskMananger) {
        _taskMananger = [[CCDownloadManager alloc] init];
        _taskMananger.delegate = self;
    }
    return _taskMananger;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator1.progress = 0.0;
    self.indicator2.progress = 0.0;
    self.indicator3.progress = 0.0;
    self.indicator4.progress = 0.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)download:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self.taskMananger downloadWithFileID:32711 withTaskDescription:@"task1"];
//             [self.taskMananger downloadWithURL:[CCDownloadURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2015/146/15/5FRL24A9MX1F_kapa_list_large.jpg"] withTaskDescription:@"task1"];
            break;
        case 1:
            [self.taskMananger downloadWithURL:[CCDownloadURL URLWithString:@"http://img2.3lian.com/2014/f6/146/d/96.jpg"] withTaskDescription:@"task2"];
            break;
        case 2:
            [self.taskMananger downloadWithURL:[CCDownloadURL URLWithString:@"http://www.bz55.com/uploads/allimg/140414/137-140414094T9.jpg"] withTaskDescription:@"task3"];
            break;
        case 3:
            [self.taskMananger downloadWithURL:[CCDownloadURL URLWithString:@"http://211.139.191.230:12630/neibu/bmcc/mp3/liangjingru-ouzhenyu.mp3"] withTaskDescription:@"task4"];
            break;
        default:
            break;
    }
}

- (IBAction)upLoadFile:(id)sender {
    
//    NSData *fileData = [NSData dataWithContentsOfFile:@"/Users/duqianghai/Library/Developer/CoreSimulator/Devices/ED6F1E1A-8E53-4693-9225-F9BEFD8007E1/data/Containers/Data/Application/32A2C832-1E88-46CB-8FAD-ECC4BD07D2CF/Documents/liangjingru-ouzhenyu.mp3"];
    NSError *error =nil;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataPath = [docPath stringByAppendingPathComponent:@"96.jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:dataPath options:NSMappedRead error:&error];

    [self.taskMananger upLoadDataArray:@[fileData]];
}



- (IBAction)pause:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self.taskMananger pauseDownloadWithTaskDescription:@"task1"];
            break;
        case 1:
            [self.taskMananger pauseDownloadWithTaskDescription:@"task2"];
            break;
        case 2:
            [self.taskMananger pauseDownloadWithTaskDescription:@"task3"];
            break;
        case 3:
            [self.taskMananger pauseDownloadWithTaskDescription:@"task4"];
            break;
        default:
            break;
    }
}

- (IBAction)resume:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self.taskMananger resumeDownloadWithTaskDescription:@"task1"];
            break;
        case 1:
            [self.taskMananger resumeDownloadWithTaskDescription:@"task2"];
            break;
        case 2:
            [self.taskMananger resumeDownloadWithTaskDescription:@"task3"];
            break;
        case 3:
            [self.taskMananger resumeDownloadWithTaskDescription:@"task4"];
            break;
        default:
            break;
    }
}

- (IBAction)cancel:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            self.indicatorLabel1.text = [NSString stringWithFormat:@"0%%"];
            self.indicator1.progress = 0;
            [self.taskMananger cancelDownloadWithTaskDescription:@"task1"];
            break;
        case 1:
            self.indicatorLabel2.text = [NSString stringWithFormat:@"0%%"];
            self.indicator2.progress = 0;
            [self.taskMananger cancelDownloadWithTaskDescription:@"task2"];
            break;
        case 2:
            self.indicatorLabel3.text = [NSString stringWithFormat:@"0%%"];
            self.indicator3.progress = 0;
            [self.taskMananger cancelDownloadWithTaskDescription:@"task3"];
            break;
        case 3:
            self.indicatorLabel4.text = [NSString stringWithFormat:@"0%%"];
            self.indicator4.progress = 0;
            [self.taskMananger cancelDownloadWithTaskDescription:@"task4"];
            break;
        default:
            break;
    }
}

- (IBAction)deleteFile:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self.taskMananger delateFileWithTaskDescription:@"task1"];
            break;
        case 1:
            [self.taskMananger delateFileWithTaskDescription:@"task2"];
            break;
        case 2:
            [self.taskMananger delateFileWithTaskDescription:@"task3"];
            break;
        case 3:
            [self.taskMananger delateFileWithTaskDescription:@"task4"];
            break;
        default:
            break;
    }
}


#pragma -mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    The expected length of the file, as provided by the Content-Length header. If this header was not provided, the value is NSURLSessionTransferSizeUnknown
    
    // 已下载的比率
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSString *taskDescription = downloadTask.taskDescription;
    if ([taskDescription isEqualToString:@"task1"]) {
        self.indicatorLabel1.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        self.indicator1.progress = progress;
    } else if ([taskDescription isEqualToString:@"task2"]) {
        self.indicatorLabel2.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        self.indicator2.progress = progress;
    }else if ([taskDescription isEqualToString:@"task3"]) {
        self.indicatorLabel3.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        self.indicator3.progress = progress;
    }else if ([taskDescription isEqualToString:@"task4"]) {
        self.indicatorLabel4.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        self.indicator4.progress = progress;
    }else{
        NSLog(@"unknowTask!");
    }
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

#pragma -mark NSURLSessionTaskDelegate
// 上传调用此方法获得上传进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    float progress = (float)totalBytesSent / totalBytesExpectedToSend;
    self.uploadIndicator1.progress = progress;
    self.upLoadIndicatorLabel1.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"taskDescription:%@",task.taskDescription);
    } else
    NSLog(@"sessionError:%@",error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
