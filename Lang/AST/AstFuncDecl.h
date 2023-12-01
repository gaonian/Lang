//
//  AstFuncDecl.h
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstNode.h"
#import "AstFuncBody.h"

NS_ASSUME_NONNULL_BEGIN

@interface AstFuncDecl : Statement

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) AstFuncBody * body;

@end

NS_ASSUME_NONNULL_END
