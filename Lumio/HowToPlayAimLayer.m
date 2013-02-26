//
//  HowToPlayLayer.m
//  Lumio
//
//  Created by Joanne Dyer on 2/25/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayAimLayer.h"
#import "MainMenuLayer.h"
#import "AboutLayer.h"
#import "HowToPlayMovementLayer.h"

@interface HowToPlayAimLayer ()

//these properties exist to pass on the information to the main menu layer when it is recreated.
@property (nonatomic, strong) BaseMenuLayer *baseMenuLayer;
@property (nonatomic) BOOL showContinue;

//used to show whether at the end of the how to play it should go to the game or the menu.
@property (nonatomic) BOOL goToGame;

@end

@implementation HowToPlayAimLayer

@synthesize baseMenuLayer = _baseMenuLayer;
@synthesize showContinue = _showContinue;
@synthesize goToGame = _goToGame;

- (id)initWithBaseLayer:(BaseMenuLayer *)baseLayer showContinue:(BOOL)showContinue goToGame:(BOOL)goToGame;
{
    if (self = [super init]) {
        self.baseMenuLayer = baseLayer;
        self.showContinue = showContinue;
        self.goToGame = goToGame;
        
        // ask director for the window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //add the background image describing how to play 'aim'.
        CCSprite *background = [CCSprite spriteWithFile:@"HowToPlayAim.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        //Create the Backwards Menu Item and put it in its own menu.
        CCMenuItemImage *backwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"BackButton.png" selectedImage:@"BackButtonSelected.png"
                                              target:self selector:@selector(backwardsButtonTapped:)];
        backwardsMenuItem.position = ccp(96, 51);
        
        CCMenuItemImage *forwardsMenuItem = [CCMenuItemImage
                                              itemWithNormalImage:@"NextButton.png" selectedImage:@"NextButtonSelected.png"
                                              target:self selector:@selector(forwardsButtonTapped:)];
        forwardsMenuItem.position = ccp(230, 51);
        
        CCMenu *menu = [CCMenu menuWithItems:backwardsMenuItem, forwardsMenuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void)backwardsButtonTapped:(id)sender
{
    CCLayer *newLayer;
    //if the how to play is on the way to playing the game it will have opened from the main menu, otherwise it will be from the about screen.
    if (self.goToGame) {
        newLayer = [[MainMenuLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    } else {
        newLayer = [[AboutLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue];
    }
    [[[CCDirector sharedDirector] runningScene] addChild:newLayer z:2];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[newLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

- (void)forwardsButtonTapped:(id)sender
{
    HowToPlayMovementLayer *movementLayer = [[HowToPlayMovementLayer alloc] initWithBaseLayer:self.baseMenuLayer showContinue:self.showContinue goToGame:self.goToGame];
    [[[CCDirector sharedDirector] runningScene] addChild:movementLayer z:2];
    
    [CCSequence actionOne:[self runAction:[CCFadeOut actionWithDuration:0.3]] two:[movementLayer runAction:[CCFadeIn actionWithDuration:0.3]]];
    [self removeFromParentAndCleanup:YES];
}

@end
