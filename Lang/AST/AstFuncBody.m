//
//  AstFuncBody.m
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstFuncBody.h"

@implementation AstFuncBody

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionBody", prefix);
    for (AstFuncCall *call in self.stmts) {
        [call dump:[NSString stringWithFormat:@"%@\t", prefix]];
    }
}

@end

/*
 stmts: FunctionCall[];
 constructor(stmts: FunctionCall[]){
     super();
     this.stmts = stmts;
 }
 public dump(prefix:string):void{
     console.log(prefix+"FunctionBody");
     this.stmts.forEach(x => x.dump(prefix+"\t"));
 }
 */
