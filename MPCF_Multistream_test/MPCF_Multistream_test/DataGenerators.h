//
// Created by Alexander Evsyuchenya on 7/21/16.
// Copyright (c) 2016 baydet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStream.h"

@protocol InputStreamDelegate;
@class DataStream;

@protocol DataProcessor <NSObject>
- (void)stream:(DataStream *)stream hasData:(NSData *)data;
@end

@protocol DataGenerator <NSObject>
- (NSData*)dataForStream:(DataStream *)stream;
@end

@interface OutputDataGenerator: NSObject <DataGenerator>
@end

@interface DataBuffer: NSObject <DataGenerator, DataProcessor, InputStreamDelegate>
@property(atomic, strong) NSMutableArray *buffer;
@end