//
//  JDCodeCountViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCodeCountViewController.h"

@interface JDCodeCountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextField *pathTextField;

@end

@implementation JDCodeCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)beginClick:(id)sender {
    //判断是真机还是模拟器
    
#if TARGET_OS_IPHONE
    _countLabel.text =@"请用模拟器运行";
    return;
#else
    
    NSString *path;
    if (_pathTextField.text.length>0) {
        path =_pathTextField.text;
    }
    else
        // 在这里写下需要统计的代码的目录
        path = @"/Users/laoshu/Desktop/WJDStudyLibrary/WJDStudyLibrary";//@"/Users/laoshu/Desktop/做过的项目/行云天气/FlowingCloud";
    
    NSInteger codeLine = codeLineCount(path);
    if (codeLine ==0) {
        _countLabel.text =@"路径错误";
    }
    else
        _countLabel.text = [NSString stringWithFormat:@"%@",@(codeLine)];
    
#endif
    
}

NSUInteger codeLineCount(NSString *url) {
    
    //1、设置文件管理者对象，判断文件是否存
    NSFileManager *manager =[NSFileManager defaultManager];
    
    //2、判断文件是文件夹还是文件
    BOOL dir = NO;
    
    //3、设置变量判断文件是否存在
    BOOL isExist = [manager fileExistsAtPath:url isDirectory:&dir];
    
    //如果不存在return 0；
    if (!isExist) {
        return 0;
    }
    
    //代码来到这说明路径存在
    //如果是文件夹...
    if (dir) {
        //获取当前文件夹path下面的所有内容（文件夹、文件）名 存在数组中
        NSArray *aryPath = [manager contentsOfDirectoryAtPath:url error:nil];
        
        //定义一个变量保存path中所有文件的总行数
        NSUInteger count = 0;
        
        //遍历数组中所有子文件（夹）名
        for (NSString *fileName in aryPath) {
            //获取子文件（夹）的全路径，运用递归
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",url,fileName];
            
            //递归累加所有代码行数
            count+=codeLineCount(fullPath);
        }
        return count;
    }
    //如果是文件
    else{
        //判断文件的扩展名,将文件扩展名都转化成lowercaseString小写字母便于之后判断
        NSString *extension = [[url pathExtension]lowercaseString];
        
        if (!([extension isEqualToString:@"m" ] || [extension isEqualToString:@"h"] || [extension isEqualToString:@"h"])) {
            //文件扩展名不是h/m/c
            return 0;
        }
        
        //加载文件内容
        NSString *content = [NSString stringWithContentsOfFile:url encoding:NSUTF8StringEncoding error:nil];
        
        //按换行符分割存入数组中
        NSArray *aryFile = [content componentsSeparatedByString:@"\n"];
        
        //返回行数
        return aryFile.count;
    }
    return 0;
}

@end
