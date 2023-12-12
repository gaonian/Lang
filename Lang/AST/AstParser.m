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
#import "Prog.h"
#import "Tokenizer.h"

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
- (Prog *)parseProg {
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
        } else {
            NSLog(@"Unrecognized token: %@", token.text);
        }
        token = [self.tokenizer peek];
    }
    Prog *prog = [[Prog alloc] init];
    prog.stmts = stmts;
    return prog;
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
                call.parameters = aryParam;
                return call;
            }
        }
    }
    return nil;
}

/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 * 返回值：
 * null-意味着解析过程出错。
 */
- (AstFuncDecl *)parseFunctionDecl {
    // 跳过关键字 ‘function’
    [self.tokenizer next];
    
    TokenKind *token = [self.tokenizer next];
    if (token.type == TokenTypeIdentifier) {
        TokenKind *token1 = [self.tokenizer next];
        if ([token1.text isEqualToString:@"("]) {
            TokenKind *token2 = [self.tokenizer next];
            if ([token2.text isEqualToString:@")"]) {
                // 解析函数体
                AstFuncBody *body = [self parseFunctionBody];
                if (body) {
                    // 如果解析成功，从这里返回
                    AstFuncDecl *decl = [[AstFuncDecl alloc] init];
                    decl.name = token.text;
                    decl.body = body;
                    return decl;
                } else {
                    NSLog(@"Error parsing FunctionBody in FunctionDecl");
                    return nil;
                }
            } else {
                NSLog(@"Expecting ')' in FunctionDecl, while we got a %@", token.text);
                return nil;
            }
        } else {
            NSLog(@"Expecting '(' in FunctionDecl, while we got a %@", token.text);
            return nil;
        }
    }
    NSLog(@"Expecting a function name, while we got a %@", token.text);
    return nil;
}

/**
 * 解析函数体
 * 语法规则：
 * functionBody : '{' functionCall* '}' ;
 */
- (AstFuncBody *)parseFunctionBody {
    NSMutableArray<AstFuncCall *> *aryTemp = [NSMutableArray array];
    TokenKind *token = [self.tokenizer next];
    if ([token.text isEqualToString:@"{"]) {
        while ([self.tokenizer peek].type == TokenTypeIdentifier) {
            AstFuncCall *call = [self parseFunctionCall];
            if (call) {
                [aryTemp addObject:call];
            } else {
                NSLog(@"Error parsing a FunctionCall in FunctionBody.");
                return nil;
            }
        }
        token = [self.tokenizer next];
        if ([token.text isEqualToString:@"}"]) {
            AstFuncBody *body = [[AstFuncBody alloc] init];
            body.stmts = aryTemp;
            return body;
        } else {
            NSLog(@"Expecting '}' in FunctionBody, while we got a %@", token.text);
            return nil;
        }
    } else {
        NSLog(@"Expecting '{' in FunctionBody, while we got a %@", token.text);
        return nil;
    }
    return nil;
}

- (NSMutableArray<Statement *> *)stmts {
    if (!_stmts) {
        _stmts = [NSMutableArray array];
    }
    return _stmts;
}

@end
