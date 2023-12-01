//
//  AstFuncCall.h
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstNode.h"
#import "AstFuncDecl.h"

NS_ASSUME_NONNULL_BEGIN

@interface AstFuncCall : Statement

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray<NSString *> * parameters;
/// 指向函数的声明
@property (nonatomic, strong) AstFuncDecl * definition;

@end

NS_ASSUME_NONNULL_END
