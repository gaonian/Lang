//
//  AstFuncDecl.m
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstFuncDecl.h"

@interface AstFuncDecl ()

@end

@implementation AstFuncDecl

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionDecl %@", prefix, self.name);
    [self.body dump:[NSString stringWithFormat:@"%@\t", prefix]];
}

@end

/*
 name:string;       //函数名称
 body:FunctionBody; //函数体
 constructor(name:string, body:FunctionBody){
     super();
     this.name = name;
     this.body = body;
 }
 public dump(prefix:string):void{
     console.log(prefix+"FunctionDecl "+this.name);
     this.body.dump(prefix+"\t");
 }
 */
