//
//  HZVoiceRecordView.h
//  HZAudioPlayerDemo
//
//  Created by 季怀斌 on 2018/6/22.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZVoiceRecordViewDelegate <NSObject>
- (void)voiceRecordViewStartRecord;
- (void)voiceRecordViewStartSend;
- (void)voiceRecordViewStartCancel;
- (void)voiceRecordViewStartRemove;
@end

@interface HZVoiceRecordView : UIView
@property (nonatomic, weak) id<HZVoiceRecordViewDelegate> delegate;
- (instancetype)initWithRecordView:(UILabel *)recordView;
@end
