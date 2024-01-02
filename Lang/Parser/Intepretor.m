//
//  Intepretor.m
//  Lang
//
//  Created by gaoyu on 2024/1/2.
//

#import "Intepretor.h"
#import "Prog.h"
#import "AstFuncCall.h"

@implementation Intepretor

- (id)visitProg:(Prog *)prog {
    id retVal = nil;
    for (Statement *stmt in prog.stmts) {
        if ([stmt isKindOfClass:AstFuncCall.class]) {
            AstFuncCall *call = (AstFuncCall *)stmt;
            retVal = [self runFunction:call];
        }
    }
    return retVal;
}

- (id)visitFunctionBody:(AstFuncBody *)body {
    id retVal = nil;
    for (AstFuncCall *call in body.stmts) {
        retVal = [self runFunction:call];
    }
    return retVal;
}

- (id)runFunction:(AstFuncCall *)call {
    if ([call.name isEqualToString:@"print"] ||
        [call.name isEqualToString:@"NSLog"]) {
        // 内置打印函数
        if (call.parameters.count) {
            NSLog(@"%@", call.parameters[0]);
        } else {
            NSLog(@"");
        }
    } else {
        // 找到函数定义，继续遍历函数体
        if (call.definition) {
            return [self visitFunctionBody:call.definition.body];
        }
    }
    return nil;
}

@end
