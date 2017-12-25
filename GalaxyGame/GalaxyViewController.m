//
//  GalaxyViewController.m
//  GalaxyGame
//
//  Created by Bret Williams on 12/25/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import "GalaxyViewController.h"
#import "GameScene.h"

@interface GalaxyViewController ()

@end

@implementation GalaxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *skView = (SKView *)self.view;
    SKScene *scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(BOOL)shouldAutorotate {
    return YES;
}

@end
