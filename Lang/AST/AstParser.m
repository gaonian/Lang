//
//  AstParser.m
//  Lang
//
//  Created by gaoyu on 2023/11/24.
//

#import "AstParser.h"
#import "AstNode.h"
#import "TokenKind.h"
#import "AstFuncCall.h"
#import "AstFuncDecl.h"
#import "AstFuncBody.h"

@interface AstParser ()

@property (nonatomic, strong) NSMutableArray<Statement *> * stmts;
@property (nonatomic, strong) Statement * stmt;

@end

@implementation AstParser

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

/**
 * 解析Prog
 * 语法规则：
 * prog = (functionDecl | functionCall)* ;
 */
- (void)parseProg {
    NSMutableArray *stmts = [NSMutableArray array];
    Statement *stmt = nil;
    TokenKind *token = [self.tokenizer peek];
    
    while (token.type != TokenTypeEOF) {
        if (token.type == TokenTypeKeyword && [token.text isEqualToString:@"function"]) {
            // 解析函数声明
            stmt = [self parseFunctionDecl];
        } else if (token.type == TokenTypeIdentifier) {
            // 解析函数调用
            stmt = [self parseFunctionCall];
        }
        if (stmt) {
            [stmts addObject:stmt];
            NSLog(@"success");
        } else {
            NSLog(@"Unrecognized token: %@", token.text);
        }
        token = [self.tokenizer peek];
    }
    NSLog(@"---- %@", stmts);
}

/**
 * 解析函数调用
 * 语法规则：
 * functionCall : Identifier '(' parameterList? ')' ;
 * parameterList : StringLiteral (',' StringLiteral)* ;
 */
- (AstFuncCall *)parseFunctionCall {
    NSMutableArray *aryParam = [NSMutableArray array];
    TokenKind *token = [self.tokenizer next];
    if (token.type == TokenTypeIdentifier) {
        TokenKind *token1 = [self.tokenizer next];
        if ([token1.text isEqualToString:@"("]) {
            TokenKind *token2 = [self.tokenizer next];
            // 循环读出所有参数
            while (![token2.text isEqualToString:@")"]) {
                if (token2.type == TokenTypeString && token2.text) {
                    [aryParam addObject:token2.text];
                } else {
                    NSLog(@"Expecting parameter in FunctionCall, while we got a %@", token2.text);
                    return nil;
                }
                token2 = [self.tokenizer next];
                if (![token2.text isEqualToString:@")"]) {
                    if ([token2.text isEqualToString:@","]) {
                        token2 = [self.tokenizer next];
                    } else {
                        NSLog(@"Expecting a comma in FunctionCall, while we got a %@", token2.text);
                        return nil;
                    }
                }
            }
            // 消化掉一个分号：;
            token2 = [self.tokenizer next];
            if ([token2.text isEqualToString:@";"]) {
                AstFuncCall *call = [[AstFuncCall alloc] init];
                call.name = token.text;
                return call;
            }
        }
    }
    return nil;
    
    /*
             //消化掉一个分号：;
             t2 = this.tokenizer.next();
             if (t2.text == ";"){
                 return new FunctionCall(t.text, params);
             }
             else{
                 console.log("Expecting a semicolon in FunctionCall, while we got a " + t2.text);
                 return null;
             }
         }
     }

     return null;
     */
}

/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 * 返回值：
 * null-意味着解析过程出错。
 */
- (AstFuncDecl *)parseFunctionDecl {
    return nil;
}

- (NSMutableArray<Statement *> *)stmts {
    if (!_stmts) {
        _stmts = [NSMutableArray array];
    }
    return _stmts;
}

@end
