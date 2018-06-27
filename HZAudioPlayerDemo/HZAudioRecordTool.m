//
//  HZAudioRecordTool.m
//  HZAudioPlayerDemo
//
//  Created by 季怀斌 on 2018/6/22.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import "HZAudioRecordTool.h"
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface HZAudioRecordTool () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (nonatomic, strong) NSURL *recoderUrl;
@property (nonatomic, strong) AVAudioRecorder *recoder;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSString *filePath;
@end
NS_ASSUME_NONNULL_END
@implementation HZAudioRecordTool
- (void)startRecord {
    NSLog(@"开始录音!!!");
    //初始化全局会话
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //设置会话种类
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    //激活全局会话
    if (_session) {
        [_session setActive:YES error:nil];
    }
    //时间戳
    NSDateFormatter *nameforamt = [NSDateFormatter new];
    [nameforamt setDateFormat:@"yyyy-hh-mm-ss"];
    NSString *dateStr = [ nameforamt stringFromDate:[NSDate date]];
    //指定音频存储路径
    _filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",dateStr]];
    NSLog(@"path = %@",_filePath);
    _recoderUrl = [NSURL fileURLWithPath:_filePath];
    //设置录音参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityMax],AVEncoderAudioQualityKey,
                                   nil];
    NSError *initError;
    //初始化录音器
    _recoder = [[AVAudioRecorder alloc] initWithURL:_recoderUrl
                                           settings:recordSetting
                                              error:&initError];
    _recoder.delegate = self;
    if (_recoder) {
        _recoder.meteringEnabled = YES;
        //开始录音
        [_recoder prepareToRecord];
        [_recoder record];
    } else {
        NSLog(@"%@", [initError description]);
    }
}
- (void)stopRecord {
    if ([_recoder isRecording]) {
        [_recoder stop];
    }
}
- (void)removeAudio {
    
}

- (NSString *)getAudioSource {
    
    NSLog(@"-----_filePath:%@", _filePath);
    return _filePath;
}
- (void)play:(NSString *)filePath {
    //
    if (!_player) {
        NSError *error;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        //设置代理
        _player.delegate = self;
    }
    
    
    if (!filePath.length) {
        NSLog(@"未录制音频！");
        return;
    }
   
        //播放
        [_player play];
        //定时器计算播放进度
        //        [NSTimer scheduledTimerWithTimeInterval:0.01
        //                                        repeats:YES
        //                                          block:^(NSTimer * _Nonnull timer) {
        //                                              NSTimeInterval currentTime = _player.currentTime;
        //                                              NSInteger hour = currentTime / 3600;
        //                                              NSInteger minute = currentTime / 60;
        //                                              NSInteger second = ((NSInteger) currentTime) %60;
        //                                              NSString *secondstr= [NSString stringWithFormat:@"%@%zd" ,second< 10 ? @"0":@"" ,second];
        //                                              NSString *minuteStr= [NSString stringWithFormat:@"%@%zd" ,minute< 10 ? @"0":@"" ,minute];
        //                                              NSString *hourStr= [NSString stringWithFormat:@"%@%zd" ,hour< 10 ? @"0":@"" ,hour];
        //                                              _playCurrentTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minuteStr,secondstr];
        //                                              float floatValue = currentTime/_seconds;
        //                                              [_progressView setProgress:floatValue animated:YES];
        //                                          }];
}

//清除缓存
- (void)deleteCaches {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = [manager contentsOfDirectoryAtPath:documentPath error:nil];
    //删除音频文件
    for (int i = 0; i < paths.count; i ++) {
        NSString *subPath  = paths[i];
        if ([subPath rangeOfString:@"wav"].length) {
            if ([manager  isDeletableFileAtPath:subPath]) {
                [manager  removeItemAtPath:subPath error:nil];
            }
        }
    }
}

#pragma mark --AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"---------录制结束----");
}

//- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder {
//    NSLog(@"---------录制中断-----");
//}
#pragma mark --AVAudioPlayerDelegate
//监听播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完成");
    //    _playButton.selected = NO;
    _player = nil;
}

@end
