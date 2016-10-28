//
//  TwoViewController.m
//  ScrollView自动布局
//
//  Created by 张江东 on 16/10/28.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#define kMainScreenWidth        ([[UIScreen mainScreen] bounds].size.width)
#define kMainScreenHeight       ([[UIScreen mainScreen] bounds].size.height)

#import "TwoViewController.h"
#import "Masonry.h"

@interface TwoViewController ()<UITextFieldDelegate,
                                UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;
@property (nonatomic, assign) CGFloat history_Y_offset;//记录textField距离顶部的距离
@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset
@property(nonatomic,assign) CGFloat textFieldH;


@end

@implementation TwoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    // 1. 添加一个视图，四周和 scrollView 一致 containerView的大小就是scrollView的containSize大小
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    self.contentView = containerView;
    [scrollView addSubview:containerView];
    
    // 2. 自动布局
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        // 通过宽高设置 contentSize
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000));
    }];
    
    // 3. 之后的布局控件，全部添加到 containerView 上即可！
    self.textFieldH = 50;
    //创建输入框
    [self setUpTextField];
    
}

#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘高度
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    
    if (keyboardHeight <=0) {//!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为keyboardHeight都大于零时.
        return;
    }
    
    CGFloat delta = 0.0;
    //delta为输入框距离顶部高度 - 屏幕除键盘和输入框之外的高度 - 你留的缝隙
    delta = self.history_Y_offset - (kMainScreenHeight - keyboardHeight -_textFieldH - 10);
    CGPoint offset = self.scrollView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    //移动scrollView 如果文本框的位置在顶部则不需要移动scrollView
    if (self.history_Y_offset + _textFieldH + keyboardHeight > kMainScreenHeight) {
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //记录文本框的位置的y
    self.history_Y_offset = [textField convertRect:textField.bounds toView:window].origin.y;
    return YES;
}

//退出键盘 滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //退出键盘
    [scrollView endEditing:YES];
}


- (void)setUpTextField{
    
    UITextField *field1 = [UITextField new];
    field1.layer.backgroundColor = [[UIColor redColor] CGColor];
    field1.delegate = self;
    [self.contentView addSubview:field1];
    [field1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(150);
        make.top.equalTo(self.contentView).with.offset(100);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(_textFieldH);
    }];
    
    
    UITextField *field2 = [UITextField new];
    field2.delegate = self;
    field2.layer.backgroundColor = [[UIColor redColor] CGColor];
    [self.contentView addSubview:field2];
    [field2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(field1);
        make.top.equalTo(field1).with.offset(340);
        make.right.equalTo(field1);
        make.height.mas_equalTo(_textFieldH);
    }];
    
    
    
    UITextField *field3 = [UITextField new];
    field3.layer.backgroundColor = [[UIColor redColor] CGColor];
    field3.delegate = self;
    [self.contentView addSubview:field3];
    [field3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(field2);
        make.top.equalTo(field2).with.offset(130);
        make.right.equalTo(field2);
        make.height.mas_equalTo(_textFieldH);
    }];
    
    UITextField *field4 = [UITextField new];
    field4.layer.backgroundColor = [[UIColor redColor] CGColor];
    field4.delegate = self;
    [self.contentView addSubview:field4];
    [field4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(field3);
        make.top.equalTo(field3).with.offset(130);
        make.right.equalTo(field3);
        make.height.mas_equalTo(_textFieldH);
    }];
}




@end
