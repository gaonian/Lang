//
//  RefResolver.m
//  Lang
//
//  Created by gaoyu on 2023/12/1.
//

#import "RefResolver.h"
#import "Prog.h"
#import "AstFuncCall.h"
#import "AstFuncDecl.h"
#import "AstFuncBody.h"

@interface RefResolver ()

@property (nonatomic, strong) Prog *prog;

@end

@implementation RefResolver

- (id)visitProg:(Prog *)prog {
    self.prog = prog;
    for (Statement *stmt in prog.stmts) {
        if ([stmt isKindOfClass:AstFuncCall.class]) {
            AstFuncCall *call = (AstFuncCall *)stmt;
            [self resolveFunctionCall:prog call:call];
        } else if ([stmt isKindOfClass:AstFuncDecl.class]) {
            AstFuncDecl *decl = (AstFuncDecl *)stmt;
            [self visitFunctionDecl:decl];
        }
    }
    return nil;
}

- (id)visitFunctionBody:(AstFuncBody *)body {
    if (self.prog) {
        for (AstFuncCall *call in body.stmts) {
            [self resolveFunctionCall:self.prog call:call];
        }
    }
    return nil;
}

- (void)resolveFunctionCall:(Prog *)prog call:(AstFuncCall *)call {
    AstFuncDecl *decl = [self findFunctionDecl:prog name:call.name];
    if (decl) {
        call.definition = decl;
    } else {
        //系统内置函数不用报错
        if (![call.name isEqualToString:@"print"] &&
            ![call.name isEqualToString:@"NSLog"]) {
            NSLog(@"Error: cannot find definition of function %@", call.name);
        }
    }
}

- (AstFuncDecl *)findFunctionDecl:(Prog *)prog name:(NSString *)name {
    for (Statement *stmt in prog.stmts) {
        if ([stmt isKindOfClass:AstFuncDecl.class]) {
            AstFuncDecl *decl = (AstFuncDecl *)stmt;
            if ([decl.name isEqualToString:name]) {
                return decl;
            }
        }
    }
    return nil;
}

/*
 prog: Prog|null = null;
     visitProg(prog:Prog):any{
         this.prog = prog;
         for(let x of prog.stmts){
             let functionCall = x as FunctionCall;
             if (typeof functionCall.parameters === 'object'){
                 this.resolveFunctionCall(prog, functionCall);
             }
             else{
                 this.visitFunctionDecl(x as FunctionDecl);
             }
         }
     }
     visitFunctionBody(functionBody:FunctionBody):any{
         if(this.prog != null){
             for(let x of functionBody.stmts){
                 return this.resolveFunctionCall(this.prog, x);
             }
         }
     }
     private resolveFunctionCall(prog: Prog, functionCall: FunctionCall){
         let functionDecl = this.findFunctionDecl(prog,functionCall.name);
         if (functionDecl != null){
             functionCall.definition = functionDecl;
         }
         else{
             if (functionCall.name != "println"){  //系统内置函数不用报错
                 console.log("Error: cannot find definition of function " + functionCall.name);
             }
         }
     }
     private findFunctionDecl(prog:Prog, name:string):FunctionDecl|null{
         for(let x of prog?.stmts){
             let functionDecl = x as FunctionDecl;
             if (typeof functionDecl.body === 'object' &&
                 functionDecl.name == name){
                 return functionDecl;
             }
         }
         return null;
     }
 */

@end
