//
// IQNetworkQueue.h
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
#import "IQNetworkUploadTask.h"
#import "IQNetworkDownloadTask.h"

@interface IQNetworkQueue : NSObject

/* Returns currently running IQNetworkTask's. */
@property (nonatomic, copy, readonly) NSSet *tasks;

+(IQNetworkQueue*)sharedQueue;

/* Creates a data task with the given request. */
- (IQNetworkTask *)dataTaskWithRequest:(NSURLRequest *)request;

/* Creates a data task to retrieve the contents of the given URL. */
- (IQNetworkTask *)dataTaskWithURL:(NSURL *)url;

/* Creates an upload task with the given request.  The body of the request will be created from the file referenced by fileURL */
- (IQNetworkTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

/* Creates an upload task with the given request.  The body of the request is provided from the bodyData. */
- (IQNetworkTask *)uploadTaskWithRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData;

/* Creates a download task with the given request. */
- (IQNetworkTask *)downloadTaskWithRequest:(NSURLRequest *)request;

/* Creates a download task to download the contents of the given URL. */
- (IQNetworkTask *)downloadTaskWithURL:(NSURL *)url;

/* Creates a download task with the resume data */
- (IQNetworkTask *)downloadTaskWithRequest:(NSURLRequest*)request resumeData:(NSData *)resumeData;

@end
