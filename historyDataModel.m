//
//  historyDataModel.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/16.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "historyDataModel.h"

@implementation historyDataModel
-(id)init{
    //当应用从storyboard中加在视图控制器时，uikit将会自动触发该方法
    if ((self=[super init])) {
        [self loadHistoryData];
    }
    return self;
}
#pragma mark 数据加载和保存
- (NSString *)documentsDirectory{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//NSDocumentDirectory表明查找Documents目录的路径，NSUserDomainMask表明讲搜素限制在应用的沙盒内
    NSString *documentsDirectory=path[0];//每个应用只有一个Documents目录
    NSLog(@"%@",documentsDirectory);
    return documentsDirectory;
}

- (NSString *)dataFilePath{
    //创建到checklists.plist的完整路径
    return [[self documentsDirectory]stringByAppendingPathComponent:@"historyData.plist"];
}

- (void)saveHistoryData{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.historyData forKey:@"historyData"];//_局部变量，self属性
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    //获取sellData数组中的内容，然后分两步讲它转换成二进制数据块，然后写进到文件中，chapter13p5
    
    
}
- (void) loadHistoryData{
    NSString *path=[self dataFilePath];
    //检查沙盒中是否存在该文件
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        //当应用从沙河中找到path.plist文件时，我们无需创建一个新的数组，可以从该文件中加载整个数组和其中内容（savechecklistitem的逆向操作）
        NSData *data=[[NSData alloc]initWithContentsOfFile:path];//将文件内容加载到nsdata对象中
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];//创建一个nskeyedunarchiver对象
        self.historyData=[unarchiver decodeObjectForKey:@"historyData"];
        [unarchiver finishDecoding];
    }else{
        self.historyData=[[NSMutableArray alloc]initWithCapacity:100];
    }
}

@end
