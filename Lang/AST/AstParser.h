//
//  AstParser.h
//  Lang
//
//  Created by gaoyu on 2023/11/24.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"

@interface AstParser : NSObject

@property (nonatomic, strong) Tokenizer * tokenizer;

- (void)parseProg;

@end
