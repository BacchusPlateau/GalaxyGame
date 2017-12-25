//
//  GameScene.m
//  GalaxyGame
//
//  Created by Bret Williams on 12/25/17.
//  Copyright © 2017 Bret Williams. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
    
    int playerScore = 0;
    int maxBullets = 5;
    int currentBullet = 0;
    int enemyCount = 5;
    AVAudioPlayer *audioEffect;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        background.position = (CGPoint) {
            CGRectGetMidX(self.frame),
            CGRectGetMidY(self.frame)
        };
        
        [self addChild:background];
        
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"System"];
        self.scoreLabel.fontSize = 15;
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.scoreLabel.position = CGPointMake(10, CGRectGetMaxY(self.frame)-50);
        
        self.mManager = [[CMMotionManager alloc] init];
        if(self.mManager.accelerometerAvailable) {
            [self.mManager startAccelerometerUpdates];
        } else {
            NSLog(@"No accelerometer");
        }
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.playerShip = [SKSpriteNode spriteNodeWithImageNamed:@"ship.png"];
        self.playerShip.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + self.playerShip.frame.size.height);
        self.playerShip.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerShip.frame.size];
        self.playerShip.physicsBody.dynamic = TRUE;
        self.playerShip.physicsBody.affectedByGravity = FALSE;
        self.playerShip.physicsBody.mass = 0.02;
        [self addChild: self.playerShip];
        
        self.playerBullets = [[NSMutableArray alloc] initWithCapacity:maxBullets];
        for(int i=0; i<enemyCount; ++i) {
            SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet02.png"];
            bullet.position = self.playerShip.position;
            bullet.hidden = TRUE;
            [self.playerBullets addObject:bullet];
            [self addChild:bullet];
        }
        
        self.enemies = [[NSMutableArray alloc] initWithCapacity:enemyCount];
        for(int i=0; i<enemyCount; ++i) {
            NSString *enemyName = [NSString stringWithFormat:@"enemy0%ld.png", (random() % 3) + 1];
            SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:enemyName];
            enemy.position = CGPointMake(enemy.size.width + (i*enemy.size.width), 400);
            enemy.hidden = FALSE;
            [self.enemies addObject:enemy];
            [self addChild:enemy];
        }
        
        
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {

}


- (void)touchDownAtPoint:(CGPoint)pos {

}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {
 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        SKSpriteNode *playerBullet = [self.playerBullets objectAtIndex:currentBullet];
        currentBullet++;
        if(currentBullet >= self.playerBullets.count)
            currentBullet = 0;
        playerBullet.position = self.playerShip.position;
        playerBullet.hidden = FALSE;
        
        SKAction *fireBulletAction = [SKAction moveTo:CGPointMake(self.playerShip.position.x, self.frame.size.height) duration:1];
        SKAction *endBulletAction = [SKAction runBlock:^{
            [playerBullet removeAllActions];
            playerBullet.hidden = TRUE;
        }];
        
        SKAction *fireBulletAndDestroy = [SKAction sequence:@[fireBulletAction, endBulletAction]];
        [playerBullet runAction:fireBulletAndDestroy withKey:@"Fire"];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)shipUpdates {
    
    CMAccelerometerData* data = self.mManager.accelerometerData;
    if(fabs(data.acceleration.x) > 0.2) {
        [self.playerShip.physicsBody applyForce:CGVectorMake(40.0 * data.acceleration.x, 0.0)];
    }
    
}

-(void)collisionDetection {
    
    for(SKSpriteNode *enemy in self.enemies) {
        if(enemy.hidden == TRUE)
            continue;
        for(SKSpriteNode *bullet in self.playerBullets) {
            if(bullet.hidden == TRUE)
                continue;
            if([bullet intersectsNode:enemy]) {
                bullet.hidden = TRUE;
                enemy.hidden = TRUE;
                playerScore++;
                self.scoreLabel.text = [NSString stringWithFormat:@"%d", playerScore];
                NSString *soundName = @"impact01";
                [self playSoundEffect: soundName];
                continue;
            }
        }
    }
}

-(void)playSoundEffect: (NSString *) effectName {
    
    NSDataAsset* soundAsset = [[NSDataAsset alloc] initWithName:effectName];
    NSError *error;
    audioEffect = [[AVAudioPlayer alloc] initWithData:soundAsset.data fileTypeHint:@"wav" error:&error];
    
    if (!audioEffect) {
        NSLog(@"Player Failed with error: %@", error);
    } else {
        audioEffect.numberOfLoops = 0;
        [audioEffect prepareToPlay];
        [audioEffect play];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    [self shipUpdates];
    [self enemyUpdates];
    [self collisionDetection];
    
}

-(void)enemyUpdates{
}

@end
