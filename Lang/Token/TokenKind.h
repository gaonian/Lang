//
//  TokenKind.h
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, TokenType) {
    TokenTypeUnknown,
    TokenTypeKeyword,
    TokenTypeIdentifier,
    TokenTypeNumber,
    TokenTypeString,
    TokenTypeSeperator,
    TokenTypeOperator,
    TokenTypeEOF,
};

@interface TokenKind : NSObject

@property (nonatomic, assign) TokenType type;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) int line;
@property (nonatomic, assign) int col;

+ (instancetype)tokenType:(TokenType)type text:(NSString *)text;

@end
