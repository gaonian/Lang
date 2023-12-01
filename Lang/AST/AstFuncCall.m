//
//  AstFuncCall.m
//  Lang
//
//  Created by gaoyu on 2023/11/28.
//

#import "AstFuncCall.h"

@interface AstFuncCall ()

@end

@implementation AstFuncCall

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionCall %@ %@", prefix, self.name, self.definition ? @", resolved" : @", not resolved");
    for (NSString *param in self.parameters) {
        NSLog(@"%@\tParameter: %@", prefix, param);
    }
}

/*
 name:string;
 parameters: string[];
 definition: FunctionDecl|null=null;  //指向函数的声明
 constructor(name:string, parameters: string[]){
     super();
     this.name = name;
     this.parameters = parameters;
 }
 public dump(prefix:string):void{
     console.log(prefix+"FunctionCall "+this.name + (this.definition!=null ? ", resolved" : ", not resolved"));
     this.parameters.forEach(x => console.log(prefix+"\t"+"Parameter: "+ x));
 }
 */

@end
