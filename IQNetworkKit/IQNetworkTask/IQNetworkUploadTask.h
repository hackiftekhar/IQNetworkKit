//
//  IQNetworkUploadTask.h
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

#import "IQNetworkDataTask.h"

@interface IQNetworkUploadTask : IQNetworkDataTask

/* Creates an upload task with the given request.  The body of the request will be created from the file referenced by fileURL */
-(instancetype)initWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;

/* Creates an upload task with the given request.  The body of the request is provided from the bodyData. */
-(instancetype)initWithRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData;

+(NSURLRequest*)expectedRequestForRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;
+(NSURLRequest*)expectedRequestForRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData;

@end
