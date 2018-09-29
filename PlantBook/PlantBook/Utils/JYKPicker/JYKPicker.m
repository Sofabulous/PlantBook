//
//  JYKPickerView.m
//  YKPickerViewDemo
//
//  Created by yukun on 2018/4/14.
//  Copyright © 2018年 SouthWest University-yukun. All rights reserved.
//

#import "JYKPicker.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define BACKGROUND_BLACK_COLOR [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]
static const NSInteger JYKPickerViewDefalutHeight = 248;
static const NSInteger JYKToolBarHeight = 44;

@implementation JYKPickerComponentObject
- (instancetype)init
{
    return [self initWithText:@"" subArray:[NSMutableArray array] ];
}
- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text subArray:[NSMutableArray array] ];
}

- (instancetype)initWithText:(NSString *)text subArray:(NSMutableArray *)array {
    self = [super init];
    if  (self) {
        _text = text;
        _subArray = array;
    }
    return self;
}
@end // JYKPickerComponentObject

@implementation JYKPickerBuilder
- (instancetype)init
{
    self = [super init];
    if (self) {
        _showMask = YES;
        _defaultIndex = 0;
        _pickerHeight = JYKPickerViewDefalutHeight;
    }
    return self;
}
@end // JYKPickerBulider

@interface JYKPicker() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, assign, getter=isLinkage) BOOL linkage;
@property (nonatomic, assign) NSUInteger numberOfComponents;
@property (nonatomic, strong) JYKPickerBuilder *builder;
//储存结构
@property (nonatomic, copy) NSArray<JYKPickerComponentObject *> *components;
@property (nonatomic, copy) NSArray<NSArray <NSString*> *> *stringArrays;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<JYKPickerComponentObject *> *> *rows;
//闭包
@property (nonatomic, copy) JYKConfirmBlock confirmBlock;
@property (nonatomic, copy) JYKCancelBlock cancelBlock;
//视图
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *containerView;

@end // JYKPicker class extension

@implementation JYKPicker
#pragma mark - setup
- (void)config {
    if (!self.isLinkage) {
        //不联动，只需要知道有多少列
        self.numberOfComponents = self.stringArrays.count;
    }
    else {
        //联动，创建一个文件结构
        self.rows = [NSMutableArray array];
        [self.rows setObject:[NSMutableArray arrayWithArray:self.components] atIndexedSubscript:0];
        //计算一共有多少列
        JYKPickerComponentObject *object = self.components.firstObject;
        for (self.numberOfComponents = 1;; self.numberOfComponents++) {
            [self.rows setObject:object.subArray atIndexedSubscript:self.numberOfComponents];
            object = [self objectAtIndex:0 inObject:object];
            if (!object) {
                break;
            }
        }
    }
    [self setupViews];
}

- (void)setupViews {
    //设置主视图
    self.backgroundColor = self.builder.isShowMask ? BACKGROUND_BLACK_COLOR : UIColor.clearColor;
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissView)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.delaysTouchesBegan = YES;
    [self addGestureRecognizer:doubleTapRecognizer];
    [self addSubview:self.containerView];
    //设置选择视图
    [self.containerView addSubview:self.pickerView];
    [self.containerView addSubview:self.confirmButton];
    [self.containerView addSubview:self.cancelButton];
    //设置默认选择序号
    NSInteger defaultIndex = (self.builder.defaultIndex < self.numberOfComponents && self.builder.defaultIndex > 0) ? self.builder.defaultIndex : 0;
    [self.pickerView selectRow:defaultIndex inComponent:0 animated:NO];
}

+ (void)showSinglePickerInView:(UIView *)view withBulider:(JYKPickerBuilder *)bulider strings:(NSArray<NSString *> *)strings confirm:(JYKConfirmBlock)confirmBlock cancel:(JYKCancelBlock)cancelBlock {
    JYKPicker *pickerView = [[JYKPicker alloc] initWithFrame:view.frame];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:strings.count];
    for (NSString *string in strings) {
        JYKPickerComponentObject *object = [[JYKPickerComponentObject alloc] initWithText:string];
        [tmp addObject:object];
    }
    pickerView.linkage = YES;
    pickerView.components = [tmp copy];
    pickerView.confirmBlock = confirmBlock;
    pickerView.cancelBlock = cancelBlock;
    //不写?:的表达式2会怎样？
    pickerView.builder = bulider ?: [JYKPickerBuilder new];
    [pickerView config];
    [view addSubview:pickerView];
}

+ (void)showMultiPickerInView:(UIView *)view withBulider:(JYKPickerBuilder *)bulider stringArrays:(NSArray<NSArray<NSString *> *> *)arrays confirm:(JYKConfirmBlock)confirmBlock cancel:(JYKCancelBlock)cancelBlock {
    JYKPicker *pickerView = [[JYKPicker alloc] initWithFrame:view.frame];
    pickerView.linkage = NO;
    pickerView.stringArrays = arrays;
    pickerView.confirmBlock = confirmBlock;
    pickerView.cancelBlock = cancelBlock;
    pickerView.builder = bulider?:[JYKPickerBuilder new];
    [pickerView config];
    [view addSubview:pickerView];
}
+ (void)showLinkagePickerInView:(UIView *)view withBulider:(JYKPickerBuilder *)bulider strings:(NSArray<JYKPickerComponentObject *> *)components confirm:(JYKConfirmBlock)confirmBlock cancel:(JYKCancelBlock)cancelBlock {
    JYKPicker *pickerView = [[JYKPicker alloc] initWithFrame:view.frame];
//    JYKPicker *pickerView = [[JYKPicker alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    pickerView.linkage = YES;
    pickerView.components = components;
    pickerView.confirmBlock = confirmBlock;
    pickerView.cancelBlock = cancelBlock;
    pickerView.builder = bulider?:[JYKPickerBuilder new];
    [pickerView config];
    [view addSubview:pickerView];
}

#pragma mark - event response

- (void)confirm:(UIButton *)button{
    if (self.confirmBlock) {
        NSMutableArray<NSString *> *resultStrings = [NSMutableArray arrayWithCapacity:self.numberOfComponents];
        NSMutableArray<NSNumber *> *resultIndexs = [NSMutableArray arrayWithCapacity:self.numberOfComponents];
        if ([self configResultStrings:resultStrings indexs:resultIndexs]) {
            self.confirmBlock([resultStrings copy],[resultIndexs copy]);
        }
    }
    [self removeFromSuperview];
}

- (void)dissView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

- (void)cancel:(UIButton *)button {
    [self dissView];
}

#pragma mark - private

- (BOOL)configResultStrings:(NSMutableArray <NSString *>*)strings indexs:(NSMutableArray <NSNumber *>*)indexs {
    if(!strings || !indexs) {
        return NO;
    }
    [strings removeAllObjects];
    [indexs removeAllObjects];
    
    if (!self.isLinkage) {
        for (NSInteger index = 0; index < self.numberOfComponents; index++) {
            NSInteger indexRow = [self.pickerView selectedRowInComponent:index];
            [indexs addObject:@(indexRow)];
            NSArray<NSString *> *tmp = self.stringArrays[index];
            //需要判断吗？
            if(tmp.count > 0) {
                [strings addObject:tmp[indexRow]];
            }
        }
    }
    else {
        for (NSInteger index = 0; index < self.numberOfComponents; index++) {
            NSInteger indexRow = [self.pickerView selectedRowInComponent:index];
            [indexs addObject:@(indexRow)];
            NSMutableArray<JYKPickerComponentObject *> *tmp = self.rows[index];
            if (tmp.count > 0) {
                [strings addObject:tmp[indexRow].text];
            }
        }
    }
    return YES;
}

- (JYKPickerComponentObject *)objectAtIndex:(NSInteger)index inObject:(JYKPickerComponentObject *)object {
    if (object.subArray.count > index) {
        return object.subArray[index];
    }
    return nil;
}

#pragma mark - PickerDataSource

-  (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!self.isLinkage) {
        return self.stringArrays[component].count;
    }
    else {
        return self.rows[component].count;
    }
}

#pragma mark - PickerDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!self.isLinkage) {
        return;
    }
    
    if (component < (self.numberOfComponents - 1)) {
        NSMutableArray<JYKPickerComponentObject *> *tmp = self.rows[component];
        if (tmp.count > 0) {
            tmp = tmp[row].subArray;
        }
        [self.rows setObject:((tmp.count > 0)?tmp:[NSMutableArray array]) atIndexedSubscript:component + 1];
        [self pickerView:pickerView didSelectRow:0 inComponent:component + 1];
        [pickerView selectRow:0 inComponent:component + 1 animated:NO];
    }
    [pickerView reloadComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = UIColor.clearColor;
        }
    }
    //设置文字的属性
    UILabel *generalLabel = [UILabel new];
    generalLabel.textAlignment = NSTextAlignmentCenter;
    generalLabel.font = [UIFont systemFontOfSize:20];
    generalLabel.textColor = self.builder.pickerTextColor ?: UIColor.blackColor;
    if (!self.isLinkage) {
        NSArray<NSString *> *tmp = self.stringArrays[component];
        if (tmp.count > 0) {
            generalLabel.text = tmp[row];
        }
    }else {
        NSArray<JYKPickerComponentObject *> *tmp = self.rows[component];
        if (tmp.count > 0) {
            generalLabel.text = tmp[row].text;
        }
    }
    return generalLabel;
}
#pragma mark - getter
- (UIView *)containerView{
    if (!_containerView) {
        CGFloat pickerViewHeight = self.builder.pickerHeight > JYKToolBarHeight ? self.builder.pickerHeight : JYKPickerViewDefalutHeight;
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - pickerViewHeight, SCREEN_WIDTH, pickerViewHeight)];
        _containerView.backgroundColor = self.builder.pickerTextColor ?: UIColor.whiteColor;
    }
    return _containerView;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -70, 10, 50, 30)];
        _confirmButton.backgroundColor = UIColor.clearColor;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        NSString *title = self.builder.confirmText.length ? self.builder.confirmText : @"确定";
        [_confirmButton setTitle:title forState:UIControlStateNormal];
        UIColor *color = self.builder.confirmTextColor ?: UIColor.blueColor;
        [_confirmButton setTitleColor:color forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 50, 30)];
        _cancelButton.backgroundColor = UIColor.clearColor;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        NSString *title = self.builder.cancelText.length ? self.builder.cancelText : @"取消";
        [_cancelButton setTitle:title forState:UIControlStateNormal];
        UIColor *color = self.builder.cancelTextColor ?: UIColor.blueColor;
        [_cancelButton setTitleColor:color forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        CGFloat pickerViewHeight = self.builder.pickerHeight > JYKToolBarHeight ? self.builder.pickerHeight : JYKPickerViewDefalutHeight;
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,JYKToolBarHeight, SCREEN_WIDTH, pickerViewHeight - JYKToolBarHeight)];
        _pickerView.backgroundColor = UIColor.clearColor;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end // JYKPicker










