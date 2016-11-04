//
//  CYRandomCodeView.m
//  caiyuanbao
//
//  Created by 张振伟 on 15/10/13.
//  Copyright © 2015年 北京财源网络科技. All rights reserved.
//

#import "CYRandomCodeView.h"

@implementation CYRandomCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

-(void)buidView{
    self.userInteractionEnabled = YES;
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(generateCode:)];
    [self addGestureRecognizer:_tap];
    self.codeCount = 4;
    self.backgroundColor = [UIColor whiteColor];
    
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    
    return randColor;
}

-(NSString*)randomCode{
    //数字: 48-57
    //小写字母: 97-122
    //大写字母: 65-90
    char chars[] = "1234567890";
    char codes[self.codeCount];
    
    for(int i=0;i<self.codeCount; i++){
        codes[i]= chars[arc4random()%10];
    }
    
    NSString *text = [[NSString alloc] initWithBytes:codes
                                              length:self.codeCount encoding:NSUTF8StringEncoding];
    return text;
}

- (void)refreshRandomCode
{
    [self generateCode:nil];
}

- (void)generateCode:(UITapGestureRecognizer *)tap {
    
    [self setNeedsDisplay];
}

-(void)didChangeCode:(DidChangeCode)didChangeCode{
    
    if (didChangeCode) {
        _didChangeCode = [didChangeCode copy];
    }
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *text = [self randomCode];
    //生成文字
    if (_didChangeCode) {
        _didChangeCode(text);
    }
    CGSize charSize =  [@"A" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30.0]}];
    
    CGPoint point;
    float pointX, pointY;
    
    int width = self.frame.size.width / text.length - charSize.width;
    int height = self.frame.size.height - charSize.height;
    
    for (int i = 0; i < text.length; i++) {
        pointX = arc4random() % width + self.frame.size.width / text.length * i;
        pointY = arc4random() % height;
        
        point = CGPointMake(pointX, pointY);
        unichar c = [text characterAtIndex:i];
        NSString *textChar = [NSString stringWithFormat:@"%C", c];
        CGContextSetLineWidth(context, 1.0);
        //[[UIColor blueColor] set];
        float fontSize = (arc4random() % 10) + 27;
        
        [textChar drawAtPoint:point withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],NSStrokeColorAttributeName:[UIColor redColor],NSForegroundColorAttributeName:[self randomColor]}];
    }
    
    //干扰线
    CGContextSetLineWidth(context, 1.0);
    for(int i = 0; i < self.codeCount; i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextAddLineToPoint(context, pointX, pointY);
        CGContextStrokePath(context);
    }
    //干扰点
    
    for(int i = 0;i < self.codeCount*6;i++) {
        CGContextSetStrokeColorWithColor(context, [[self randomColor] CGColor]);
        pointX = arc4random() % (int)self.frame.size.width;
        pointY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pointX, pointY);
        CGContextAddLineToPoint(context, pointX+1, pointY+1);
        
        //CGContextFillRect(context, CGRectMake(pointX,pointY,1,1));
        CGContextStrokePath(context);
    }
    
}

@end
