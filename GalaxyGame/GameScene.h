//
//  GameScene.h
//  GalaxyGame
//
//  Created by Bret Williams on 12/25/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface GameScene : SKScene

@property SKLabelNode *scoreLabel;
@property CMMotionManager *mManager;
@property SKSpriteNode *playerShip;
@property NSMutableArray *playerBullets;

@end
