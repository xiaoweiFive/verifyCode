//
//  CYRandomCodeView.h
//  caiyuanbao
//
//  Created by 张振伟 on 15/10/13.
//  Copyright © 2015年 北京财源网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidChangeCode)(NSString*code);

@interface CYRandomCodeView : UIView

{
    DidChangeCode _didChangeCode;
    UITapGestureRecognizer *_tap;
}

@property (nonatomic, assign)NSUInteger codeCount;

-(void)didChangeCode:(DidChangeCode)didChangeCode;

- (void)refreshRandomCode;

@end
