//
//  QSCLoginImageVerifyView.h
//  qingsongchou
//
//  Created by zhangzhenwei on 16/10/25.
//  Copyright © 2016年 Chai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^InputSuccessBlock)();
typedef void(^InputFailureBlock)();


@interface QSCLoginImageVerifyView : UIView

@property (nonatomic, copy) InputSuccessBlock  successBolck;
@property (nonatomic, copy) InputFailureBlock  failureBlock;

- (void)verifySuccess:(InputSuccessBlock)successBolck filure:(InputFailureBlock)failureBlock;

@end
