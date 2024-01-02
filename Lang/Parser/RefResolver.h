//
//  RefResolver.h
//  Lang
//
//  Created by gaoyu on 2023/12/1.
//

// 语义分析
// 对函数调用做引用消解，也就是找到函数的声明。

#import "AstVisitor.h"

@interface RefResolver : AstVisitor

@end
