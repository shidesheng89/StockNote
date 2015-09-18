//
//  DataModel.h
//  股票记帐本
//
//  Created by 施德胜 on 15/9/11.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (strong,nonatomic) NSMutableArray *Data;

- (void)saveData;

@end
