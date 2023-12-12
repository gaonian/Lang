//
//  Prog.h
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstNode.h"
@class Statement;

@interface Prog : AstNode

@property (nonatomic, strong) NSArray<Statement *> * stmts;

- (void)dump:(NSString *)prefix;

@end
