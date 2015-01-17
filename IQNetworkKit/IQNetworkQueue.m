//
// IQNetworkQueue.m
// https://github.com/hackiftekhar/IQNetworkKit
// Copyright (c) 2013-14 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQNetworkQueue.h"

@implementation IQNetworkQueue
{
    NSMutableSet *_networkTasks;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _networkTasks = [[NSMutableSet alloc] init];
    }
    return self;
}

-(NSSet*)tasks
{
    return [_networkTasks copy];
}

+(IQNetworkQueue*)sharedQueue
{
    static IQNetworkQueue *manager;
    
    if (manager == nil)
    {
        manager = [[self alloc] init];
    }
    
    return manager;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)appendToQueueAndStartTask:(IQNetworkTask*)task
{
    if ([_networkTasks containsObject:task] == NO)
    {
        [_networkTasks addObject:task];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDidCompleteNotification:) name:IQNetworkTaskDidCompleteNotification object:task];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDidFailedNotification:) name:IQNetworkTaskDidFailedNotification object:task];
        
        [task start];
    }
}

-(void)removeTaskFromQueue:(IQNetworkTask*)task
{
    if ([_networkTasks containsObject:task] == YES)
    {
        [_networkTasks removeObject:task];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IQNetworkTaskDidCompleteNotification object:task];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IQNetworkTaskDidFailedNotification object:task];
    }
}

/* Creates a data task with the given request. */
- (IQNetworkTask *)dataTaskWithRequest:(NSURLRequest *)request
{
    IQNetworkTask *task = [self existingTaskForRequest:request];
    
    if (task == nil)
    {
        task = [[IQNetworkDataTask alloc] initWithRequest:request];
        [task start];
    }
    
    return task;
}

/* Creates a data task to retrieve the contents of the given URL. */
- (IQNetworkTask *)dataTaskWithURL:(NSURL *)url
{
    NSURLRequest *request = [IQNetworkDataTask expectedRequestForURL:url];
    
    IQNetworkTask *task = [self existingTaskForRequest:request];
    
    if (task == nil)
    {
        task = [[IQNetworkDataTask alloc] initWithRequest:request];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

/* Creates an upload task with the given request.  The body of the request will be created from the file referenced by fileURL */
- (IQNetworkTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    NSURLRequest *expectedRequest = [IQNetworkUploadTask expectedRequestForRequest:request fromFile:fileURL];
    
    IQNetworkTask *task = [self existingTaskForRequest:expectedRequest];
    
    if (task == nil)
    {
        task = [[IQNetworkUploadTask alloc] initWithRequest:request fromFile:fileURL];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

/* Creates an upload task with the given request.  The body of the request is provided from the bodyData. */
- (IQNetworkTask *)uploadTaskWithRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData
{
    NSURLRequest *expectedRequest = [IQNetworkUploadTask expectedRequestForRequest:request bodyData:bodyData];
    
    IQNetworkTask *task = [self existingTaskForRequest:expectedRequest];
    
    if (task == nil)
    {
        task = [[IQNetworkUploadTask alloc] initWithRequest:request bodyData:bodyData];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

/* Creates a download task with the given request. */
- (IQNetworkTask *)downloadTaskWithRequest:(NSURLRequest *)request
{
    IQNetworkTask *task = [self existingTaskForRequest:request];
    
    if (task == nil)
    {
        task = [[IQNetworkDownloadTask alloc] initWithRequest:request];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

/* Creates a download task to download the contents of the given URL. */
- (IQNetworkTask *)downloadTaskWithURL:(NSURL *)url
{
    NSURLRequest *expectedRequest = [IQNetworkDownloadTask expectedRequestForURL:url];
    
    IQNetworkTask *task = [self existingTaskForRequest:expectedRequest];
    
    if (task == nil)
    {
        task = [[IQNetworkDownloadTask alloc] initWithURL:url];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

/* Creates a download task with the resume data.  If the download cannot be successfully resumed, URLSession:task:didCompleteWithError: will be called. */
- (IQNetworkTask *)downloadTaskWithRequest:(NSURLRequest*)request resumeData:(NSData *)resumeData
{
    IQNetworkTask *task = [self existingTaskForRequest:request];
    
    if (task == nil)
    {
        task = [[IQNetworkDownloadTask alloc] initWithRequest:request resumeData:resumeData];
        [self appendToQueueAndStartTask:task];
    }
    
    return task;
}

-(IQNetworkTask*)existingTaskForRequest:(NSURLRequest*)request
{
    for (IQNetworkTask *task in _networkTasks)
        if ([task.request isEqual:request])
            return task;
    
    return nil;
}

-(void)taskDidCompleteNotification:(NSNotification*)notification
{
    if (notification.object)
    {
        [self removeTaskFromQueue:notification.object];
    }
}

-(void)taskDidFailedNotification:(NSNotification*)notification
{
    if (notification.object)
    {
        [self removeTaskFromQueue:notification.object];
    }
}

@end
