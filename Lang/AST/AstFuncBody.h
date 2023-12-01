//
//  AstFuncBody.h
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstNode.h"
#import "AstFuncCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface AstFuncBody : AstNode

@property (nonatomic, strong) NSArray<AstFuncCall *> * stmts;

@end

NS_ASSUME_NONNULL_END
