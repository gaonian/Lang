//
//  AstParser.h
//  Lang
//
//  Created by gaoyu on 2023/11/24.
//

#import <Foundation/Foundation.h>
@class Tokenizer;
@class Prog;

@interface AstParser : NSObject

@property (nonatomic, strong) Tokenizer * tokenizer;

- (Prog *)parseProg;

@end
