//
//  IQNetworkUploadTask.m
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

#import "IQNetworkUploadTask.h"

@implementation IQNetworkUploadTask

-(instancetype)initWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    request = [[self class] expectedRequestForRequest:request fromFile:fileURL];
    
    if (self = [super initWithRequest:request])
    {

    }
    
    return self;
}

-(instancetype)initWithRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData
{
    request = [[self class] expectedRequestForRequest:request bodyData:bodyData];
    
    if (self = [super initWithRequest:request])
    {
        
    }
    
    return self;
}

+(NSURLRequest*)expectedRequestForRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    return [self expectedRequestForRequest:request bodyData:[[NSData alloc] initWithContentsOfURL:fileURL]];
}

+(NSURLRequest*)expectedRequestForRequest:(NSURLRequest *)request bodyData:(NSData *)bodyData
{
    NSMutableURLRequest *newRequest = [request copy];
    newRequest.HTTPBody = bodyData;
    return newRequest;
}

@end
