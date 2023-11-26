//
//  Tokenizer.h
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import <Foundation/Foundation.h>
@class TokenKind;

@interface Tokenizer : NSObject

+ (NSArray<TokenKind *> *)parseWithProg:(NSString *)prog;

@end
