//
//  HZVoiceRecordView.m
//  HZAudioPlayerDemo
//
//  Created by 季怀斌 on 2018/6/22.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import "HZVoiceRecordView.h"
#import "Masonry.h"
NS_ASSUME_NONNULL_BEGIN
@interface HZVoiceRecordView ()
@property (nonatomic, strong) UILabel *recordView;
@property (nonatomic, strong) UIView *recordCoverView;
@property (nonatomic, strong) UIImageView *startRecordImageView;
@property (nonatomic, strong) UIImageView *startCancelImageView;
@end
NS_ASSUME_NONNULL_END
@implementation HZVoiceRecordView
- (instancetype)initWithRecordView:(UILabel *)recordView {
    if (self = [super initWithFrame:CGRectZero]) {
        _recordView = recordView;
        [self setMyRecord];
    }
    return self;
}

- (void)setMyRecord{
    
    if (!self.recordCoverView) {
        self.recordCoverView = [UIView new];
        self.recordCoverView.hidden = true;
        [[UIApplication sharedApplication].keyWindow addSubview:_recordCoverView];
        [self.recordCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
    if (!_startRecordImageView) {
        _startRecordImageView = [UIImageView new];
        [self.recordCoverView addSubview:_startRecordImageView];
        [_startRecordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 150));
            make.centerX.mas_equalTo(self.recordCoverView.mas_centerX);
            make.centerY.mas_equalTo(self.recordCoverView.mas_centerY);
        }];
        
        _startRecordImageView.image = [UIImage imageNamed:@"1.png"];
    }
    
    if (!_startCancelImageView) {
        _startCancelImageView = [UIImageView new];
        [self.recordCoverView addSubview:_startCancelImageView];
        [_startCancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 150));
            make.centerX.mas_equalTo(self.recordCoverView.mas_centerX);
            make.centerY.mas_equalTo(self.recordCoverView.mas_centerY);
        }];
        
        _startCancelImageView.image = [UIImage imageNamed:@"2.png"];
    }
   
    _recordView.userInteractionEnabled = true;
    [self addSubview:_recordView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_recordView addGestureRecognizer:longPress];
}
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    int sendState = 0;
    CGPoint point = [longPress locationInView:longPress.view];
    
    if (point.y < 0) {
        
        _recordCoverView.hidden = false;
        _startRecordImageView.hidden = true;
        _startCancelImageView.hidden = false;
        _recordView.text = @"松开 结束";
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecordViewStartCancel)]) {
            [self.delegate voiceRecordViewStartCancel];
        }

        sendState = 1;
        
    } else {
        
        //重新进入长按录音范围内
//        NSLog(@"---------重新进入长按录音范围内--------");
        sendState = 0;
    }
    
    //手势状态
    
    switch (longPress.state) {
            
        case UIGestureRecognizerStateBegan:
            
        {
            
            //NSLog(@"开始");
            _recordCoverView.hidden = false;
            _startRecordImageView.hidden = false;
            _startCancelImageView.hidden = true;
            _recordView.text = @"松开 结束";
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecordViewStartRecord)]) {
                [self.delegate voiceRecordViewStartRecord];
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
        {
            
            //NSLog(@"长按手势结束");
            
            if (sendState == 0)
                
            {
                
                _recordCoverView.hidden = true;
                _recordView.text = @"按住 说话";
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecordViewStartSend)]) {
                    [self.delegate voiceRecordViewStartSend];
                }

            }
            
            else
                
            {
                
                //向上滑动取消发送
                _recordCoverView.hidden = true;
                _recordView.text = @"按住 说话";
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRecordViewStartRemove)]) {
                    [self.delegate voiceRecordViewStartRemove];
                }

            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateFailed:
            
            //NSLog(@"长按手势失败");
            
            break;
            
        default:
            
            break;
            
    }
}

- (void)dealloc {
    [_recordCoverView removeFromSuperview];
}
@end
