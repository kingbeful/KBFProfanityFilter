//
//  ViewController.m
//  ProfanityFilterSample
//
//  Created by John Arnold on 2013-02-27.
//  Copyright (c) 2013 Island of Doom Software Inc. All rights reserved.
//

#import "ViewController.h"
#import "KBFProfanityFilter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [KBFProfanityFilter sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filter:(id)sender
{
    self.filteredTextLabel.text = [[KBFProfanityFilter sharedInstance] filteringString:self.inputTextField.text];
    
}
@end
