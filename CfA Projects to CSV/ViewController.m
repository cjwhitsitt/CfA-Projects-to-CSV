//
//  ViewController.m
//  CfA Projects to CSV
//
//  Created by Jay Whitsitt on 2/9/15.
//  Copyright (c) 2015 Jay Whitsitt. All rights reserved.
//

#import "ViewController.h"

#import "NSDictionary+ObjectForKeyNotNull.h"

#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSTextField *urlTextField;
@property (nonatomic, weak) IBOutlet NSButton *makeCSVButton;
@property (unsafe_unretained) IBOutlet NSTextView *progressTextView;

@property (nonatomic, strong) NSMutableString *csvString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self.urlTextField setStringValue:@"http://codeforamerica.org/api/projects"];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)makeTheCSV:(NSButton *)sender
{
    NSString *urlString = self.urlTextField.stringValue;
    
    // get the json
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // get the relevant json nodes
        NSDictionary *responseDictionary = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseDictionary = responseObject;
            
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"The response was not a dictionary which is required for the logic to work properly.";
            [alert runModal];
            return;
        }
        
        // append to CSV string
        NSArray *objects = [responseDictionary objectForKeyNotNull:@"objects"];
        for (NSDictionary *object in objects) {
            NSString *apiURL = [object objectForKeyNotNull:@"api_url"];
            NSString *githubURL = [object objectForKeyNotNull:@"code_url"];
            NSString *description = [object objectForKeyNotNull:@"description"];
            NSString *lastUpdated = [object objectForKeyNotNull:@"description"];
            NSString *linkURL = [object objectForKeyNotNull:@"link_url"];
            NSString *projectName = [object objectForKeyNotNull:@"name"];
            
            NSDictionary *organization = [object objectForKeyNotNull:@"organization"];
            NSString *organizationName = nil;
            NSString *organizationAPIURL = nil;
            NSString *organizationCity = nil;
            NSString *organizationWebsite = nil;
            if (organization) {
                organizationName = [organization objectForKeyNotNull:@"name"];
                organizationAPIURL = [organization objectForKeyNotNull:@"api_url"];
                organizationCity = [organization objectForKeyNotNull:@"city"];
                organizationWebsite = [organization objectForKeyNotNull:@"website"];
            }
            
            [self appendAPIURL:apiURL githubURL:githubURL description:description lastUpdated:lastUpdated linkURL:linkURL projectName:projectName organizationName:organizationName organizationAPIURL:organizationAPIURL organizationCity:organizationCity organizationWebsite:organizationWebsite];
        }
        
        // if another page, call the next one
        NSDictionary *pages = [responseDictionary objectForKeyNotNull:@"pages"];
        
        NSString *lastPage = [pages objectForKeyNotNull:@"last"];
        if (lastPage) {
            [self.progressTextView setString:[NSString stringWithFormat:@"Last page:\n%@", lastPage]];
        } else {
            self.progressTextView.string = @"";
        }
        
        NSString *nextPage = [pages objectForKeyNotNull:@"next"];
        
        if (nextPage) {
            [self.urlTextField setStringValue:nextPage];
            [self makeTheCSV:sender];
            
        } else {
            // we're done, output the file
            NSString *path = [@"~/Desktop/thefile.csv" stringByExpandingTildeInPath];
            NSError *error = nil;
            NSAlert *alert = nil;
            
            if (![self.csvString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
                alert = [NSAlert alertWithError:error];
                NSLog(@"%@",error);
                
            } else {
                alert = [[NSAlert alloc] init];
                alert.messageText = @"The file was output to your desktop.";
            }
            
            [alert runModal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }];
    
    [operation start];
    
    // more?
}

- (void)appendAPIURL:(NSString *)apiURL githubURL:(NSString *)githubURL description:(NSString *)description lastUpdated:(NSString *)lastUpdated linkURL:(NSString *)linkURL projectName:(NSString *)projectName organizationName:(NSString *)organizationName organizationAPIURL:(NSString *)organizationAPIURL organizationCity:(NSString *)organizationCity organizationWebsite:(NSString *)organizationWebsite
{
    // if the first chunk, add the csv headers
    if (!self.csvString) {
        self.csvString = [[NSMutableString alloc] init];
        [self appendAPIURL:@"API URL" githubURL:@"Github URL" description:@"Description" lastUpdated:@"Last Updated" linkURL:@"Link URL" projectName:@"Project Name" organizationName:@"Organization Name" organizationAPIURL:@"Organization API URL" organizationCity:@"Organization City" organizationWebsite:@"Organization Website"];
    }
    
    organizationCity = [organizationCity stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    
    [self.csvString appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",projectName,description,apiURL,githubURL,lastUpdated,linkURL,organizationName,organizationAPIURL,organizationCity,organizationWebsite];
}

@end
