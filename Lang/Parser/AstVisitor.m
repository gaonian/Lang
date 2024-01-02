//
//  AstVisitor.m
//  Lang
//
//  Created by gaoyu on 2023/12/1.
//

#import "AstVisitor.h"
#import "Prog.h"
#import "AstNode.h"
#import "AstFuncDecl.h"
#import "AstFuncCall.h"
#import "AstFuncBody.h"

@implementation AstVisitor

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id)visitProg:(Prog *)prog {
    id retVal = nil;
    for (Statement *stmt in prog.stmts) {
        if ([stmt isKindOfClass:AstFuncDecl.class]) {
            AstFuncDecl *decl = (AstFuncDecl *)stmt;
            return [self visitFunctionDecl:decl];
        } else if ([stmt isKindOfClass:AstFuncCall.class]) {
            AstFuncCall *call = (AstFuncCall *)stmt;
            return [self visitFunctionCall:call];
        }
    }
    return retVal;
}

- (id)visitFunctionDecl:(AstFuncDecl *)decl {
    return [self visitFunctionBody:decl.body];
}

- (id)visitFunctionBody:(AstFuncBody *)body {
    id retVal = nil;
    for (AstFuncCall *call in body.stmts) {
        retVal = [self visitFunctionCall:call];
    }
    return retVal;
}

- (id)visitFunctionCall:(AstFuncCall *)call {
    return nil;
}

@end
