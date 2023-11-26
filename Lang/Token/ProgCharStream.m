//
//  ProgCharStream.m
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import "ProgCharStream.h"

@interface ProgCharStream ()

@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) int position;

@end

@implementation ProgCharStream

+ (instancetype)initWithContent:(NSString *)content {
    ProgCharStream *stream = [[ProgCharStream alloc] init];
    stream.content = content;
    stream.position = 0;
    stream.line = 1;
    stream.col = 0;
    return stream;
}

/// 预读下一个字符，但不移动指针
- (unichar)peek {
    return [self.content characterAtIndex:self.position];
}

/// 读取下一个字符，并且移动指针
- (unichar)next {
    unichar ch = [self.content characterAtIndex:self.position++];
    if (ch == '\n') {
        self.line++;
        self.col = 0;
    } else {
        self.col++;
    }
    return ch;
}

/// 判断是否已经到了结尾
- (BOOL)eof {
    return self.position == self.content.length - 1;
}

@end
