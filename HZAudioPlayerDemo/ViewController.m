//
//  ViewController.m
//  HZAudioPlayerDemo
//
//  Created by 季怀斌 on 2018/6/22.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "HZVoiceRecordView.h"
#import "HZAudioRecordTool.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource, HZVoiceRecordViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *roundBtn;
@property (nonatomic, strong) HZAudioRecordTool *audioRecordTool;
@property (nonatomic, strong) NSMutableArray *audioPathArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"音频录制/播放";
    
    //
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //
    UILabel *recordView = [UILabel new];
    recordView.backgroundColor = [UIColor redColor];
    recordView.textAlignment = NSTextAlignmentCenter;
    HZVoiceRecordView *voiceRecordView = [[HZVoiceRecordView alloc] initWithRecordView:recordView];
    voiceRecordView.delegate = self;
     [self.view addSubview:voiceRecordView];
    
    //
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        recordView.text = @"按住 说话";
    }];
    
    [voiceRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(50);
    }];
    
    self.audioRecordTool = [HZAudioRecordTool new];
    self.audioPathArr = [NSMutableArray array];
}


#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioPathArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"音频------%ld", indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //
    
    NSString *filePath = self.audioPathArr[indexPath.row];
    NSLog(@"-----self.audioPathArr----:%@", filePath);
    [self.audioRecordTool play:filePath];
}

#pragma mark ----------------- HZVoiceRecordViewDelegate ------------------
- (void)voiceRecordViewStartRecord {
    NSLog(@"这里开始录音 ---- ");
    [self.audioRecordTool startRecord];
}
- (void)voiceRecordViewStartSend {
    NSLog(@"结束录音并发送录音");
    [self.audioRecordTool stopRecord];
    //
    NSString *filePath = [self.audioRecordTool getAudioSource];
    [self.audioPathArr addObject:filePath];
    [self.tableView reloadData];
}
- (void)voiceRecordViewStartCancel {
    NSLog(@"松开手指，取消发送 ---- ");
    [self.audioRecordTool stopRecord];
}
- (void)voiceRecordViewStartRemove {
    NSLog(@"取消发送删除录音");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
