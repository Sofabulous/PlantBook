//
//  JYKPickerView.h
//  YKPickerViewDemo
//
//  Created by yukun on 2018/4/14.
//  Copyright © 2018年 SouthWest University-yukun. All rights reserved.
//

#import <UIKit/UIKit.h>
//变量不为空
NS_ASSUME_NONNULL_BEGIN
//利用闭包传值回调-确定和取消闭包
typedef void (^JYKCancelBlock)(void);
typedef void (^JYKConfirmBlock)(NSArray<NSString *> *strings,NSArray<NSNumber *> *indexs);

//数据内容对象
@interface  JYKPickerComponentObject : NSObject
//目录子结构，迭代结构
@property (nonatomic, strong, nullable) NSMutableArray<JYKPickerComponentObject *> *subArray;
//目录名字
@property (nonatomic, copy)  NSString *text;

- (instancetype)initWithText:(NSString *)text subArray:(NSMutableArray *)array;
- (instancetype)initWithText:(NSString *)text;
@end // JYKPickerComponentObject

//选择器视图构建对象
@interface  JYKPickerBuilder:NSObject
//是否显示背后遮罩, 默认为YES
@property (nonatomic, assign, getter=isShowMask) BOOL showMask;
//确认按钮的文字，默认为“确定”
@property (nonatomic, copy, nullable)  NSString *confirmText;
//取消按钮的文字，默认为“取消“
@property (nonatomic, copy, nullable) NSString *cancelText;
//确定文字的颜色，默认为蓝色
@property (nonatomic, strong, nullable) UIColor *confirmTextColor;
//取消文字的颜色, 默认为蓝色
@property (nonatomic, strong, nullable) UIColor *cancelTextColor;
//选择器的文字颜色，默认为黑色
@property (nonatomic, strong, nullable) UIColor *pickerTextColor;
//选择器的背景颜色，默认为白色
@property (nonatomic, strong, nullable) UIColor *pickerColor;
//默认滚动的行数，默认为第1行
@property (nonatomic, assign)  NSInteger defaultIndex;
//整个pickerView的高度，默认为248, 包括44的按钮栏
@property (nonatomic, assign)  CGFloat pickerHeight;
@end // JYKPickerBulider

@interface JYKPicker : UIView

/**
 单行数据

 @param view 所在view
 @param bulider 配置
 @param strings 单个string数组
 @param confirmBlock 点击确认后
 @param cancelBlock 点击取消后
 */
+ (void)showSinglePickerInView:(UIView *)view
                   withBulider:(nullable JYKPickerBuilder*)bulider
                       strings:(NSArray<NSString *> *)strings
                       confirm:(JYKConfirmBlock)confirmBlock
                        cancel:(JYKCancelBlock)cancelBlock;

/**
 多行不联动数据

 @param view 所在view
 @param bulider 配置
 @param arrays 二维数组，数组里string数组个数为行数，相互独立
 @param confirmBlock 点击确认后
 @param cancelBlock 点击取消后
 */

+ (void)showMultiPickerInView:(UIView *)view
                  withBulider:(nullable JYKPickerBuilder*)bulider
                      stringArrays:(NSArray<NSArray<NSString *> *> *)arrays
                      confirm:(JYKConfirmBlock)confirmBlock
                       cancel:(JYKCancelBlock)cancelBlock;

/**
 多行联动数据

 @param view 所在view
 @param bulider 配置
 @param components 传入componentObject数组，可嵌套
 @param confirmBlock 点击确定后
 @param cancelBlock 点击取消后
 */

+ (void)showLinkagePickerInView:(UIView *)view
                    withBulider:(nullable JYKPickerBuilder*)bulider
                    strings:(NSArray<JYKPickerComponentObject *> *)components
                    confirm:(JYKConfirmBlock)confirmBlock
                    cancel:(JYKCancelBlock)cancelBlock;
                

@end // JYKPicker
NS_ASSUME_NONNULL_END
