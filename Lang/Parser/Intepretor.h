//
//  Intepretor.h
//  Lang
//
//  Created by gaoyu on 2024/1/2.
//

// 解释器
// 遍历AST，执行函数调用

#import "AstVisitor.h"
@class Prog;

@interface Intepretor : AstVisitor

- (id)visitProg:(Prog *)prog;

@end
