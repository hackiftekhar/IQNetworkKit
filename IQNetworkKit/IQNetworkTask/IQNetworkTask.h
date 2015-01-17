//
// IQNetworkTask.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger, IQNetworkTaskState) {
    IQNetworkTaskStateNotStarted = 0,
    IQNetworkTaskStatePreparing,
    IQNetworkTaskStateUploading,
    IQNetworkTaskStateWaiting,
    IQNetworkTaskStateDownloading,
    IQNetworkTaskStatePaused,
    IQNetworkTaskStateDownloaded,
    IQNetworkTaskStateFailed,
};

typedef NS_ENUM(NSUInteger, IQNetworkTaskEvents) {
    /*  Method signature should be similar to `-(void)uploadProgress:(CGFloat)progress`    */
    IQNetworkTaskEventUploadProgress,
    
    /*  Method signature should be similar to `-(void)downloadProgress:(CGFloat)progress`    */
    IQNetworkTaskEventDownloadProgress,
    
    /*  Method signature should be similar to `-(void)taskState:(IQNetworkTaskState)state`    */
    IQNetworkTaskEventStateChange,
    
    /*  Method signature should be similar to `-(void)finishWithData:(NSData*)result error:(NSError*)error`    */
    IQNetworkTaskEventFinish,
};

@interface IQNetworkTask : NSObject
{
    NSData *_resumeData;
}

-(instancetype)initWithURL:(NSURL *)url;
-(instancetype)initWithRequest:(NSURLRequest*)request;

@property (nonatomic, readonly) IQNetworkTaskState state;
@property (nonatomic, readonly, copy) NSURLRequest *request;
@property (nonatomic, readonly, copy) NSHTTPURLResponse *response;	    /* may be nil if no response has been received */
@property (nonatomic, readonly, copy) NSError *error;

/* download progress of task */
@property (readonly) CGFloat downloadProgress;
/* number of body bytes already received */
@property (readonly) NSInteger totalBytesReceived;
/* number of byte bytes we expect to receive, usually derived from the Content-Length header of an HTTP response. */
@property (readonly) NSInteger totalBytesExpectedToReceive;

/* upload progress of task */
@property(nonatomic, assign, readonly) CGFloat uploadProgress;
/* number of body bytes already sent */
@property (readonly) NSInteger totalBytesSent;
/* number of body bytes we expect to send, derived from the Content-Length of the HTTP request */
@property (readonly) NSInteger totalBytesExpectedToSend;


- (void)addTarget:(id)target action:(SEL)action forTaskEvents:(IQNetworkTaskEvents)taskEvents;
- (void)removeTarget:(id)target action:(SEL)action forTaskEvents:(IQNetworkTaskEvents)taskEvents;

-(void)start;
-(void)pause;
-(void)resume;
-(void)cancel;

//Return cached response for current NSURLRequest
-(NSCachedURLResponse*)cachedResponse;

+(NSURLRequest*)expectedRequestForURL:(NSURL*)url;

@end

extern NSString *const IQNetworkTaskDidCompleteNotification;
extern NSString *const IQNetworkTaskDidFailedNotification;
extern NSString *const IQNetworkTaskDidChangeStateNotification;



