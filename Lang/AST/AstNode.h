//
//  AstNode.h
//  Lang
//
//  Created by gaoyu on 2023/11/24.
//

#import <Foundation/Foundation.h>

@interface AstNode : NSObject

- (void)dump:(NSString *)prefix;

@end

@interface Statement : AstNode

@end
