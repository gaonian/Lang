//
//  ViewController.m
//  Lang
//
//  Created by gaoyu on 2023/11/23.
//

#import "ViewController.h"
#import "Tokenizer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* patchPath = [NSBundle.mainBundle pathForResource:@"main" ofType:@"js"];
    NSString* script = [NSString stringWithContentsOfFile:patchPath encoding:NSUTF8StringEncoding error:nil];
    
    [Tokenizer parseWithProg:script];
}


@end