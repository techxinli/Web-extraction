//
//  ViewController.m
//  网页提取器
//
//  Created by 李鑫 on 17/5/3.
//  Copyright © 2017年 李鑫. All rights reserved.
//

//     [self downloadImageWithUrl:@"https://pic1.zhimg.com/0c647acf065e2b6f6f5065787986473c_b.png"];

//    NSImage *image = [NSImage imageNamed:@"界面.jpg"];
//    NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
//    NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
//    [data writeToFile: @"/Users/LiXin/Desktop/file.png" atomically: NO];

//    NSSavePanel*  panel = [NSSavePanel savePanel];
//    [panel setNameFieldStringValue:@"Untitle.png"];
//    [panel setMessage:@"Choose the path to save the document"];
//    [panel setAllowsOtherFileTypes:YES];
//    [panel setAllowedFileTypes:@[@"jpg",@"png"]];
//    [panel setExtensionHidden:YES];
//    [panel setCanCreateDirectories:YES];
//    [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result){
//        if (result == NSFileHandlingPanelOKButton)
//            {
//                NSString *path = [[panel URL] path];
//                NSImage *image = [NSImage imageNamed:@"界面.jpg"];
//                NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
//                NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
//                [data writeToFile:path atomically: NO];
/////Users/lixin/Desktop/X/aa.jpg
//
//                NSLog(@"%@",path);
//                //[@"onecodego" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//                }
//        }];


#import "ViewController.h"


@implementation ViewController


//int timenum = 0;
//int inside =0;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dic = [[NSMutableDictionary alloc]init];
    _nextdic = [[NSMutableDictionary alloc]init];
    //test
    _InputText.stringValue = @"https://dribbble.com/shots/2391800-Walllpaper-Turn-Dribbble-shots-into-backgrounds-for-your-phone";
    _count = 0;
    _a = 1;
       // Do any additional setup after loading the view.
}
- (IBAction)Create:(NSButton *)sender {
    
    if(_InputText.stringValue == nil){
        
        NSLog(@"非法输入");
        
    }
    else{


    NSURL *url = [NSURL URLWithString:_InputText.stringValue];
    NSError *err = nil;
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if (err == nil)
    {
    
        [self start:str path:[self getDocumentsPath] num:1];

    }
    
    }
    
}
-(void)start:(NSString*)str path:(NSString*)path num:(int)num{

    
        _ShowText.string = str;
        NSMutableDictionary *dic =  [self regex:_ShowText.string num:num];
            
        for (NSString *key in [dic allKeys])
        {
                
            if([key rangeOfString:@".png"].location != NSNotFound || [key rangeOfString:@".jpg"].location != NSNotFound || [key rangeOfString:@".gif"].location != NSNotFound ){
                    
                [self downloadImageWithUrl:key path:path];
                
                }
//                else{
//                
//                    for (NSString *key in [dic[@"nextdic"] allKeys]) {
//                        
//                        if([dic[@"count"] intValue] > 0 && _a == 1){
//                            int a = [dic[@"count"] intValue];
//                            NSFileManager *fileManager = [NSFileManager defaultManager];
//                            NSString *newpath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d",1]];
//                            [dic setValue:[NSString stringWithFormat:@"%d",a-1] forKey:@"count"];
//                            NSLog(@"%@::::::%d",key,a);
//                            BOOL isSuccess = [fileManager createDirectoryAtPath:newpath withIntermediateDirectories:YES attributes:nil error:nil];
//                            if (isSuccess) {
//                                
//                                NSURL *url = [NSURL URLWithString:@"https://dribbble.com/Alvin_Ley"];
//                                NSError *err = nil;
//                                NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
//                                NSLog(@"%d---------------########%@",a,str);
//                                // only two
//                                _a = 0;
//                                [self start:str path:newpath num:2];
//                                //NSLog(@"success");
//                            } else {
//                                //NSLog(@"fail");
//                            }
//                            
//                            //[self start:key path:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d",timenum++]]];
//                        }
//                  }
          
                }
                
            }
    
    //timenum = 0;
  
//}


-(void)downloadImageWithUrl:(NSString *)imageDownloadURLStr path:(NSString*)path{
    

    
    //以便在block中使用
    __block NSImage *image = [[NSImage alloc] init];
    //图片下载链接
    NSURL *imageDownloadURL = [NSURL URLWithString:imageDownloadURLStr];
    
    //将图片下载在异步线程进行
    //创建异步线程执行队列
    dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue", NULL);
    //创建异步线程
    dispatch_async(asynchronousQueue, ^{
        //网络下载图片  NSData格式
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            image = [[NSImage alloc] initWithData:imageData];
            //NSLog(@"HElloooo");
        }
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
          
            NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
            NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
            if([imageDownloadURLStr rangeOfString:@".png"].location != NSNotFound){
            
                  [data writeToFile: [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.png",[self md5:imageDownloadURLStr]]] atomically: NO];
                
            }
            if([imageDownloadURLStr rangeOfString:@".jpg"].location != NSNotFound){
                
                [data writeToFile: [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.jpg",[self md5:imageDownloadURLStr]]] atomically: NO];
                
            }
            
            if([imageDownloadURLStr rangeOfString:@".gif"].location != NSNotFound){
                
                [data writeToFile: [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.gif",[self md5:imageDownloadURLStr]]] atomically: NO];
                
            }

            
        });
    });
}


-(NSMutableDictionary*)regex:(NSString*)str num:(int)num{

    NSError *error;
    NSMutableDictionary*Dic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary*nextDic = [[NSMutableDictionary alloc]init];
    int count = 0;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [str substringWithRange:match.range];
        [Dic setValue:substringForMatch forKey:substringForMatch];
        if ([substringForMatch rangeOfString:@".gif"].location == NSNotFound && [substringForMatch rangeOfString:@".png"].location == NSNotFound && [substringForMatch rangeOfString:@".jpg"].location == NSNotFound && num!=2) {
            
            [nextDic  setValue:substringForMatch forKey:substringForMatch];
            count++;
        }
        //NSLog(@"######%@", substringForMatch);
        
       
    }
    
    [Dic setValue:nextDic forKey:@"nextdic"];
    [Dic setValue:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    if ([str  isEqual: @"https://cdn.dribbble.com/assets/favicon-63b2904a073c89b52b19aa08cebc16a154bcf83fee8ecc6439968b1e6db569c7.ico"]){
        
        for (NSString *key in [Dic allKeys]) {
            
            NSLog(@"%@-------------key",key);
        }
    }

    
    return Dic;
    
    //NSLog(@"-------------%@",[_dic allKeys]);
    
    
}

-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

- (NSString *)getDocumentsPath
{
    //获取Documents路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    _iOSDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"0"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager createDirectoryAtPath:_iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        //NSLog(@"success");
    } else {
        //NSLog(@"fail");
    }
    return _iOSDirectory;
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
