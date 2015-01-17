//
//  ViewController.m
// https://github.com/hackiftekhar/IQNetworkKit
// Copyright (c) 2013-14 Iftekhar Qurashi.

#import "ViewController.h"
#import "IQNetworkQueue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQNetworkTask *task = [[IQNetworkQueue sharedQueue] downloadTaskWithURL:[NSURL URLWithString:@"http://www.hdwallpapersimages.com/wp-content/uploads/2014/01/Winter-Tiger-Wild-Cat-Images.jpg"]];
    
    [task addTarget:self action:@selector(stateChange:) forTaskEvents:IQNetworkTaskEventStateChange];
    [task addTarget:self action:@selector(downloadProgress:) forTaskEvents:IQNetworkTaskEventDownloadProgress];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)stateChange:(IQNetworkTaskState)state
{
    switch (state)
    {
        case IQNetworkTaskStateNotStarted:
            NSLog(@"IQNetworkTaskStateNotStarted");
            break;
        case IQNetworkTaskStatePreparing:
            NSLog(@"IQNetworkTaskStatePreparing");
            break;
        case IQNetworkTaskStateWaiting:
            NSLog(@"IQNetworkTaskStateWaiting");
            break;
        case IQNetworkTaskStateUploading:
            NSLog(@"IQNetworkTaskStateUploading");
            break;
        case IQNetworkTaskStateDownloading:
            NSLog(@"IQNetworkTaskStateDownloading");
            break;
        case IQNetworkTaskStatePaused:
            NSLog(@"IQNetworkTaskStatePaused");
            break;
        case IQNetworkTaskStateDownloaded:
            NSLog(@"IQNetworkTaskStateDownloaded");
            break;
        case IQNetworkTaskStateFailed:
            NSLog(@"IQNetworkTaskStateFailed");
            break;
            
        default:
            break;
    }
}

-(void)downloadProgress:(CGFloat)progress
{
    NSLog(@"%f",progress);
}


@end
