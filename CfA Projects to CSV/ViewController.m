//
//  ViewController.m
//  CfA Projects to CSV
//
//  Created by Jay Whitsitt on 2/9/15.
//  Copyright (c) 2015 Jay Whitsitt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSButton *makeCSVButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)makeTheCSV:(NSButton *)sender
{
    NSString *urlString = @"http://codeforamerica.org/api/projects";
    
    // get the json
    
    
    // more?
}

@end
