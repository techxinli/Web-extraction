//
//  ViewController.h
//  网页提取器
//
//  Created by 李鑫 on 17/5/3.
//  Copyright © 2017年 李鑫. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *InputText;
@property (unsafe_unretained) IBOutlet NSTextView *ShowText;
@property (strong) NSMutableDictionary*dic;
@property NSString*path;
@property NSString *iOSDirectory;
@property (strong) NSMutableDictionary*nextdic;
@property int a;
@property int count;


@property (weak) IBOutlet NSTextField *num;


@end

