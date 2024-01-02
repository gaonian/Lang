//
//  ViewController.m
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import "ViewController.h"
#import "Tokenizer.h"
#import "AST/AstParser.h"
#import "Prog.h"
#import "RefResolver.h"
#import "Intepretor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* patchPath = [NSBundle.mainBundle pathForResource:@"main" ofType:@"js"];
    NSString* script = [NSString stringWithContentsOfFile:patchPath encoding:NSUTF8StringEncoding error:nil];
    
//    [Tokenizer parseWithProg:script];
    
    AstParser *parser = [[AstParser alloc] init];
    parser.tokenizer = [Tokenizer tokenWithProg:script];
    Prog *prog = [parser parseProg];
    [prog dump:@""];
    
    //语义分析
    RefResolver *resolver = [[RefResolver alloc] init];
    [resolver visitProg:prog];
    NSLog(@"\n语法分析后的AST，注意自定义函数的调用已被消解:");
    [prog dump:@""];
    
    // 运行程序
    NSLog(@"运行当前的程序：");
    Intepretor *intepretor = [[Intepretor alloc] init];
    id retVal = [intepretor visitProg:prog];
    NSLog(@"程序返回值：%@", retVal);
}


@end
