//
//  Tokenizer.h
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import <Foundation/Foundation.h>
@class TokenKind;

@interface Tokenizer : NSObject

+ (instancetype)tokenWithProg:(NSString *)prog;

+ (NSArray<TokenKind *> *)parseWithProg:(NSString *)prog;

- (TokenKind *)peek;

- (TokenKind *)next;

@end
