//
//  HZAudioRecordTool.h
//  HZAudioPlayerDemo
//
//  Created by 季怀斌 on 2018/6/22.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZAudioRecordTool : NSObject
- (void)startRecord;
- (void)stopRecord;
- (void)removeAudio;
- (NSString *)getAudioSource;
- (void)play:(NSString *)filePath;
@end
