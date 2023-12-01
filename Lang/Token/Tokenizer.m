//
//  Tokenizer.m
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import "Tokenizer.h"
#import "TokenKind.h"
#import "ProgCharStream.h"

@interface Tokenizer ()

@property (nonatomic, strong) NSSet * keywordSet;

@property (nonatomic, strong) ProgCharStream * stream;
@property (nonatomic, strong) TokenKind * nextToken;

@end

@implementation Tokenizer

- (instancetype)init {
    if (self = [super init]) {
        self.nextToken = [TokenKind tokenType:TokenTypeEOF text:@""];
    }
    return self;
}

+ (instancetype)tokenWithProg:(NSString *)prog {
    ProgCharStream *stream = [ProgCharStream initWithContent:prog];
    Tokenizer *tokenizer = [[Tokenizer alloc] init];
    tokenizer.stream = stream;
    return tokenizer;
}

+ (NSArray<TokenKind *> *)parseWithProg:(NSString *)prog {
    NSLog(@"%@", prog);
    Tokenizer *tokenizer = [Tokenizer tokenWithProg:prog];
    NSMutableArray *aryTemp = [NSMutableArray array];
    while ([tokenizer peek].type != TokenTypeEOF) {
        TokenKind *kind = [tokenizer next];
        if (kind) {
            [aryTemp addObject:kind];
        }
    }
    
    for (TokenKind *kind in aryTemp) {
        NSLog(@"%@", kind);
    }
    
    return aryTemp;
}

/// 返回当前token，但不移动当前位置
- (TokenKind *)peek {
    if (self.nextToken.type == TokenTypeEOF &&
        ![self.stream eof]) {
        self.nextToken = [self getAToken];
    }
    return self.nextToken;
}

/// 返回当前token，并移向下一个token
- (TokenKind *)next {
    // 在第一次的时候，先parse一个Token
    if (self.nextToken.type == TokenTypeEOF &&
        ![self.stream eof]) {
        self.nextToken = [self getAToken];
    }
    TokenKind *lastToken = [self nextToken];
    // 往前走一个Token
    self.nextToken = [self getAToken];
    return lastToken;
}

/// 从字符串流中获取一个新Token
- (TokenKind *)getAToken {
    [self skipWhiteSpaces];
    if (self.stream.eof) {
        return [TokenKind tokenType:TokenTypeEOF text:@""];
    }
    // 预读一个Token
    unichar ch = [self.stream peek];
    
    // 标识符
    if ([self isLetter:ch] || ch == '_') {
        return [self parseIdentifer];
    }
    
    // 数字
    if ([self isDigit:ch]) {
        return [self parseNumber];
    }
    
    // 字符串
    if (ch == '"') {
        return [self parseStringLiteral];
    }
    
    // 分隔符 {} () ,;
    if ([self isSeperator:ch]) {
        [self.stream next];
        return [TokenKind tokenType:TokenTypeSeperator text:[NSString stringWithFormat:@"%C", ch]];
    }
    
    // 注释
    if (ch == '/') {
        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '*') {
            // 文档注释
            [self skipMultipleLineComments];
            return [self getAToken];
        } else if (ch1 == '/') {
            // 单行注释
            [self skipSingleLineComment];
            return [self getAToken];
        }
    }
    
    // 操作符 ( + - * / = )
    if ([self isOperator:ch]) {
        return [self parseOperator:ch];
    }

    // 暂时去掉不能识别的字符
    NSLog(@"Unrecognized pattern meeting: %@  line: %d  col: %d", [NSString stringWithFormat:@"%C", ch], self.stream.line, self.stream.col);
    [self.stream next];
    return [self getAToken];
}

/// 解析标识符。从标识符中还要挑出关键字。
- (TokenKind *)parseIdentifer {
    TokenKind *token = [TokenKind tokenType:TokenTypeIdentifier text:@""];
    token.line = self.stream.line;
    token.col = self.stream.col;
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    unichar ch = [self.stream next];
    [str appendString:[NSString stringWithFormat:@"%C", ch]];
    
    //读入后序字符
    while (![self.stream eof] &&
           [self isLetterDigitOrUnderScore:[self.stream peek]]) {
        [str appendString:[NSString stringWithFormat:@"%C", [self.stream next]]];
    }
    
    token.text = str;

    // 识别出关键字
    if ([self.keywordSet containsObject:token.text]) {
        token.type = TokenTypeKeyword;
    }
//    if ([token.text isEqualToString:@"function"]) {
//        token.type = TokenTypeKeyword;
//    }
    return token;
}

/// 解析数字（目前只支持整数）
- (TokenKind *)parseNumber {
    TokenKind *token = [TokenKind tokenType:TokenTypeNumber text:@""];
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    unichar ch = [self.stream next];
    NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%C", ch]];
    //读入后序字符
    while (![self.stream eof] &&
           [self isNumber:[self.stream peek]]) {
        [str appendString:[NSString stringWithFormat:@"%C", [self.stream next]]];
    }
    
    token.text = str;

    return token;
}

/// 解析字符串字面量
- (TokenKind *)parseStringLiteral {
    TokenKind *token = [TokenKind tokenType:TokenTypeString text:@""];
    //第一个字符不用判断，因为在调用者那里已经判断过了
    [self.stream next];
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    while(![self.stream eof] &&
          [self.stream peek] != '"') {
        [str appendString:[NSString stringWithFormat:@"%C", [self.stream next]]];
    }
    token.text = str;
    if ([self.stream peek] == '"') {
        //消化掉字符换末尾的引号
        [self.stream next];
    } else {
        NSLog(@"Expecting an \" at line: %d  col: %d", self.stream.line, self.stream.col);
    }
    return token;
}

/// 解析操作符
- (TokenKind *)parseOperator:(unichar)ch {
    if (ch == '/') {
//        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '=') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"/="];
        } else {
            return [TokenKind tokenType:TokenTypeOperator text:@"/"];
        }
    } else if (ch == '+') {
        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '+') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"++"];
        } else if (ch1 == '=') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"+="];
        } else {
            return [TokenKind tokenType:TokenTypeOperator text:@"+"];
        }
    } else if (ch == '-') {
        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '-') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"--"];
        } else if (ch1 == '=') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"-="];
        } else {
            return [TokenKind tokenType:TokenTypeOperator text:@"-"];
        }
    } else if (ch == '*') {
        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '=') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"*="];
        } else {
            return [TokenKind tokenType:TokenTypeOperator text:@"*"];
        }
    } else if (ch == '=') {
        [self.stream next];
        unichar ch1 = [self.stream peek];
        if (ch1 == '=') {
            [self.stream next];
            return [TokenKind tokenType:TokenTypeOperator text:@"=="];
        } else {
            return [TokenKind tokenType:TokenTypeOperator text:@"="];
        }
    }
    return nil;
}

/// 跳过空白字符
- (void)skipWhiteSpaces {
    while ([self isWhiteSpace:[self.stream peek]] && !self.stream.eof) {
        [self.stream next];
    }
}

/// 单行注释
- (void)skipSingleLineComment {
    // 跳过第二个/，第一个之前已经跳过去了。
    [self.stream next];

    // 往后一直找到回车或者eof
    while ([self.stream peek] !='\n' && ![self.stream eof]) {
        [self.stream next];
    }
}

/// 多行注释
- (void)skipMultipleLineComments {
    // 跳过*，/之前已经跳过去了。
    [self.stream next];

    if (![self.stream eof]) {
        unichar ch1 = [self.stream next];
        // 往后一直找到回车或者eof
        while (![self.stream eof]) {
            unichar ch2 = [self.stream next];
            if (ch1 == '*' && ch2 == '/'){
                return;
            }
            ch1 = ch2;
        }
    }

    // 如果没有匹配上，报错。
    NSLog(@"Failed to find matching */ for multiple line comments at line: %d  col: %d", self.stream.line, self.stream.col);
}

- (BOOL)isWhiteSpace:(unichar)ch {
    return (ch == ' ' || ch == '\n' || ch == '\t');
}

- (BOOL)isLetter:(unichar)ch {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z');
}

- (BOOL)isLetterDigitOrUnderScore:(unichar)ch {
    return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z') || (ch >= '0' && ch <= '9') || (ch == '_');
}

- (BOOL)isSeperator:(unichar)ch {
    return (ch == '(' || ch == ')' || ch == '{' || ch == '}' || ch == ';' || ch == ',');
}

- (BOOL)isOperator:(unichar)ch {
    return ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '=';
}

- (BOOL)isDigit:(unichar)ch {
    return (ch >= '0' && ch <= '9');
}

- (BOOL)isNumber:(unichar)ch {
    return [self isDigit:ch] || ch == '.' || ch == 'x' || ch == 'X' || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F');
}

- (NSSet *)keywordSet {
    if (!_keywordSet) {
        _keywordSet = [[NSSet alloc] initWithArray:@[
            @"function",
            @"return",
            @"var",
            @"if",
            @"else",
            @"break",
        ]];
    }
    return _keywordSet;
}

@end
