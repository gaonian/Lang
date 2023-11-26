//
//  TokenKind.m
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import "TokenKind.h"

@interface TokenKind ()

@end

@implementation TokenKind

+ (instancetype)tokenType:(TokenType)type text:(NSString *)text {
    TokenKind *kind = [[TokenKind alloc] init];
    kind.type = type;
    kind.text = text;
    return kind;
}

- (NSString *)description {
    NSString *type = @"Unknown";
    switch (self.type) {
        case TokenTypeKeyword:
            type = @"Keyword";
            break;
        case TokenTypeIdentifier:
            type = @"Identifier";
            break;
        case TokenTypeNumber:
            type = @"Number";
            break;
        case TokenTypeString:
            type = @"String";
            break;
        case TokenTypeSeperator:
            type = @"Seperator";
            break;
        case TokenTypeOperator:
            type = @"Operator";
            break;
        case TokenTypeEOF:
            type = @"EOF";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"type: %d  line: %d  col: %d\ntext: %@\n", self.type, self.line, self.col, self.text];
}

@end
