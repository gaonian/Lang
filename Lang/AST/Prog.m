//
//  Prog.m
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "Prog.h"
#import "AstNode.h"

@interface Prog ()

@end

@implementation Prog

- (void)dump:(NSString *)prefix {
    NSLog(@"%@Prog", prefix);
    for (Statement *stmt in self.stmts) {
        [stmt dump:[NSString stringWithFormat:@"%@\t", prefix]];
    }
}

@end
