//
//  ProgCharStream.h
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import <Foundation/Foundation.h>

@interface ProgCharStream : NSObject

@property (nonatomic, assign) int line;
@property (nonatomic, assign) int col;

+ (instancetype)initWithContent:(NSString *)content;

/// 预读下一个字符，但不移动指针
- (unichar)peek;

/// 读取下一个字符，并且移动指针
- (unichar)next;

/// 判断是否已经到了结尾
- (BOOL)eof;

@end
