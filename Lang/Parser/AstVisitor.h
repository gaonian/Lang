//
//  AstVisitor.h
//  Lang
//
//  Created by gaoyu on 2023/12/1.
//

/**
 * 对AST做遍历的Vistor。
 * 这是一个基类，定义了缺省的遍历方式。子类可以覆盖某些方法，修改遍历方式。
 */

#import <Foundation/Foundation.h>
@class Prog;
@class AstFuncDecl;
@class AstFuncBody;
@class AstFuncCall;

@interface AstVisitor : NSObject

- (id)visitProg:(Prog *)prog;

- (id)visitFunctionDecl:(AstFuncDecl *)decl;

- (id)visitFunctionBody:(AstFuncBody *)body;

- (id)visitFunctionCall:(AstFuncCall *)call;

@end
