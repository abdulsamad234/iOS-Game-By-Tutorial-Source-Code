//
//  AnimatingSprite.m
//  PestControl
//
//  Created by Main Account on 9/1/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "AnimatingSprite.h"

@implementation AnimatingSprite

+ (SKAction*)createAnimWithPrefix:(NSString *)prefix
                           suffix:(NSString *)suffix
{
  SKTextureAtlas *atlas = 
    [SKTextureAtlas atlasNamed:@"characters"];

  NSArray *textures =
  @[[atlas textureNamed:[NSString stringWithFormat:@"%@_%@1",
                         prefix, suffix]],
    [atlas textureNamed:[NSString stringWithFormat:@"%@_%@2",
                         prefix, suffix]]];
  
  [textures[0] setFilteringMode:SKTextureFilteringNearest];
  [textures[1] setFilteringMode:SKTextureFilteringNearest];
  
  return [SKAction repeatActionForever:
           [SKAction animateWithTextures:textures
                            timePerFrame:0.20]];
}

- (void)setFacingDirection:(PCFacingDirection)facingDirection
{
  // 1
  _facingDirection = facingDirection;
  // 2
  switch (facingDirection) {
    case PCFacingForward:
      [self runAction:self.facingForwardAnim];
      break;
    case PCFacingBack:
      [self runAction:self.facingBackAnim];
      break;
    case PCFacingLeft:
      [self runAction:self.facingSideAnim];
      break;
    case PCFacingRight:
      [self runAction:self.facingSideAnim];
      // 3
      if (self.xScale > 0.0f) {
        self.xScale = -self.xScale;
      }
      break;
  }
  // 4
  if(facingDirection != PCFacingRight && self.xScale < 0.0f) {
    self.xScale = -self.xScale;
  }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  //1
  [super encodeWithCoder:aCoder];
  //2
  [aCoder encodeObject:_facingForwardAnim
                forKey:@"AS-ForwardAnim"];
  [aCoder encodeObject:_facingBackAnim
                forKey:@"AS-BackAnim"];
  [aCoder encodeObject:_facingSideAnim
                forKey:@"AS-SideAnim"];
  [aCoder encodeInt32:_facingDirection
               forKey:@"AS-FacingDirection"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  //1
  if (self = [super initWithCoder:aDecoder]) {
    //2
    _facingForwardAnim =
      [aDecoder decodeObjectForKey:@"AS-ForwardAnim"];
    _facingBackAnim =
      [aDecoder decodeObjectForKey:@"AS-BackAnim"];
    _facingSideAnim =
      [aDecoder decodeObjectForKey:@"AS-SideAnim"];
    _facingDirection =
      [aDecoder decodeInt32ForKey:@"AS-FacingDirection"];
  }
  return self;
}

@end
