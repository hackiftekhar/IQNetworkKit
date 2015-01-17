//
// IQNetworkTask.m
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

#import "IQNetworkTask.h"
#import "IQURLConnection.h"

NSString *const IQNetworkTaskDidCompleteNotification    =   @"IQNetworkTaskDidCompleteNotification";
NSString *const IQNetworkTaskDidFailedNotification      =   @"IQNetworkTaskDidFailedNotification";
NSString *const IQNetworkTaskDidChangeStateNotification =   @"IQNetworkTaskDidChangeStateNotification";

@interface IQNetworkTask ()

@property(nonatomic, getter = isPaused) BOOL paused;

@end

@implementation IQNetworkTask
{
    NSMutableDictionary *_taskEventsTargets;
    
    __block IQURLConnection *_connection;
}

-(void)_initialize
{
    _paused = NO;
    _taskEventsTargets = [[NSMutableDictionary alloc] init];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self)
    {
        [self _initialize];
        _request = request;
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        [self _initialize];
        _request = [[self class] expectedRequestForURL:url];
    }
    return self;
}

+(NSURLRequest*)expectedRequestForURL:(NSURL*)url
{
    return [NSURLRequest requestWithURL:url];
}

-(NSCachedURLResponse *)cachedResponse
{
    return [[NSURLCache sharedURLCache] cachedResponseForRequest:self.request];
}

-(void)setState:(IQNetworkTaskState)state
{
    _state = state;

    NSSet *targets = _taskEventsTargets[@(IQNetworkTaskEventStateChange)];
    
    for (NSInvocation *invocation in targets)
    {
        [invocation setArgument:&_state atIndex:2];
        [invocation invoke];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IQNetworkTaskDidChangeStateNotification object:self];
    
    switch (state)
    {
        case IQNetworkTaskStateDownloaded:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:IQNetworkTaskDidCompleteNotification object:self];
        }
            break;
            
        case IQNetworkTaskStateFailed:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:IQNetworkTaskDidFailedNotification object:self];
        }
            break;
            
        default:
            break;
    }
}

-(NSInteger)totalBytesReceived
{
    return _connection.totalBytesReceived;
}

-(NSInteger)totalBytesExpectedToReceive
{
    return _connection.totalBytesExpectedToReceive;
}

-(NSInteger)totalBytesSent
{
    return _connection.totalBytesSent;
}

-(NSInteger)totalBytesExpectedToSend
{
    return _connection.totalBytesExpectedToSend;
}

-(void)start
{
    _paused = NO;
    self.state = IQNetworkTaskStatePreparing;
    _error = nil;
    
    _connection = [[IQURLConnection alloc] initWithRequest:self.request resumeData:_resumeData responseBlock:^(NSHTTPURLResponse *response) {
        _response = [response copy];
        self.state = IQNetworkTaskStateWaiting;
    } uploadProgressBlock:^(CGFloat progress) {

        _uploadProgress = progress;
        self.state = IQNetworkTaskStateUploading;
        
        NSSet *targets = _taskEventsTargets[@(IQNetworkTaskEventUploadProgress)];
        
        for (NSInvocation *invocation in targets)
        {
            [invocation setArgument:&progress atIndex:2];
            [invocation invoke];
        }
        
    } downloadProgressBlock:^(CGFloat progress) {
        
        _downloadProgress = progress;
        self.state = IQNetworkTaskStateDownloading;

        NSSet *targets = _taskEventsTargets[@(IQNetworkTaskEventDownloadProgress)];
        
        for (NSInvocation *invocation in targets)
        {
            [invocation setArgument:&progress atIndex:2];
            [invocation invoke];
        }
        
    } completionBlock:^(NSData *result, NSError *error) {
        
        _error = error;
        
        if (_paused == YES && [error code] == kIQUserCancelErrorCode)
        {
            self.state = IQNetworkTaskStatePaused;
            _resumeData = [result copy];
        }
        else if (result)
        {
            _connection = nil;
            self.state = IQNetworkTaskStateDownloaded;
        }
        else
        {
            _connection = nil;
            self.state = IQNetworkTaskStateFailed;
        }
        
        NSSet *targets = _taskEventsTargets[@(IQNetworkTaskEventFinish)];
        
        for (NSInvocation *invocation in targets)
        {
            [invocation setArgument:&result atIndex:2];
            [invocation setArgument:&error atIndex:3];
            [invocation invoke];
        }
    }];

    [_connection start];
}

-(BOOL)isPaused
{
    return _paused;
}

-(void)pause
{
    _paused = YES;
    [_connection cancel];
}

-(void)resume
{
    [self start];
}

-(void)cancel
{
    [_connection cancel];
    _connection = nil;
    _resumeData = nil;
}

- (void)addTarget:(id)target action:(SEL)action forTaskEvents:(IQNetworkTaskEvents)taskEvents
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
    invocation.target = target;
    invocation.selector = action;
    
    NSMutableSet *targets = _taskEventsTargets[@(taskEvents)];
    
    if (targets == nil)
    {
        targets = [[NSMutableSet alloc] init];
        _taskEventsTargets[@(taskEvents)] = targets;
    }
    
    [targets addObject:invocation];
}

- (void)removeTarget:(id)target action:(SEL)action forTaskEvents:(IQNetworkTaskEvents)taskEvents
{
    NSMutableSet *targets = _taskEventsTargets[@(taskEvents)];

    for (NSInvocation *invocation in targets)
    {
        if ([invocation.target isEqual:target] && invocation.selector == action)
        {
            [targets removeObject:invocation];
            break;
        }
    }
}

-(void)dealloc
{
    [_taskEventsTargets removeAllObjects];
    _taskEventsTargets = nil;
}

@end
