#import "GLTexture.h"
#import "Geometry.h"
#import "GLCard.h"
#import "AnimatedFloat.h"
#import "AnimatedVector3D.h"
#import "GLCardGroup.h"
#import "GameRenderer.h"

@implementation GLCardGroup

@synthesize renderer        = _renderer;
@synthesize cards           = _cards;
@synthesize draggedCard     = _draggedCard;
@synthesize initialAngle    = _initialAngle;
@synthesize initialIndex    = _initialIndex;
@synthesize finalIndex      = _finalIndex;

@dynamic bendFactor;

-(GLfloat)bendFactor
{
    return [[[self.cards objectAtIndex:0] bendFactor] value];
}

-(void)setBendFactor:(GLfloat)bendFactor
{
    for(GLCard* card in self.cards)
    {
        card.bendFactor = [AnimatedFloat withStartValue:card.bendFactor.value endValue:bendFactor speed:1];
    }
}

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        _cards     = [[NSMutableArray alloc] init];
        
        _initialIndex = -1;
        _finalIndex   = -1;
        _initialAngle = 0.0;
        _draggedCard  = nil;
    }
    
    return self;
}

-(void)layoutCards
{
    int cardCount = 0;
    
    for(GLCard* card in self.cards) 
    {   
        if(card.isDead) { continue; }
        
        cardCount++;
    }
    
    GLfloat fan = -15 + 5 * cardCount;
    
    GLfloat position = 0;
    
    for(GLCard* card in self.cards) 
    {   
        if(card.isDead) { continue; }
        
        card.position = position;
        
        card.angleFan = [AnimatedFloat withStartValue:card.angleFan.value endValue:fan forTime:0.15];
        
        position++;
        
        fan -= 5;
    }
}

-(void)makeControlPoints
{
    for(GLCard* card in self.cards) 
    {         
        [card makeControlPoints]; 
    }
}

-(void)clearDeadCard:(GLCard*)item
{
    [self.cards removeObject:item];   
}

-(void)drawFronts
{
    for(GLCard* card in self.cards) 
    { 
        [card drawFront]; 
    }
}

-(void)drawBacks
{
    for(GLCard* card in self.cards.reverseObjectEnumerator) 
    { 
        [card drawBack]; 
    }
}

-(void)drawShadows
{
    for(GLCard* card in self.cards) 
    { 
        [card drawShadow]; 
    }
}

-(void)drawLabels
{
    for(GLCard* card in self.cards) 
    { 
        [card drawLabel]; 
    }
}

-(void)discardCardWithSuit:(int)suit numeral:(int)numeral afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work
{
    runAfterDelay(self.renderer.animated ? delay : 0, 
    ^{
        for(GLCard* card in self.cards)
        {
            if(card.suit == suit && card.numeral == numeral)
            {
                card.isDead = YES;
                card.location = [AnimatedVector3D withStartValue:card.location.value endValue:Vector3DMake(0, 0, -30) speed:30];
                card.location.onEnd = ^{ [self performSelector:@selector(clearDeadCard:) withObject:card afterDelay:TIMESCALE * 0.00]; runLater(work); };
                card.location.curve = AnimationEaseInOut;
            }
        }

        [self layoutCards];
    });
}

-(void)dealCardWithSuit:(int)suit numeral:(int)numeral held:(BOOL)isHeld afterDelay:(NSTimeInterval)delay andThen:(simpleBlock)work
{
    runAfterDelay(self.renderer.animated ? delay : 0, 
    ^{
        GLCard* card = [[[GLCard alloc] initWithSuit:suit numeral:numeral] autorelease];
        
        [self.cards insertObject:card atIndex:0];
        
        card.renderer       = self.renderer;
        card.cardGroup      = self;
        card.position       = self.cards.count;
        card.angleJitter    = randomFloat(-3.0, 3.0);
        card.isHeld         = [AnimatedFloat withValue:isHeld];
        card.location       = self.renderer.animated ? [AnimatedVector3D withStartValue:Vector3DMake(0, 0, -30) endValue:Vector3DMake(0, 0, 0) speed:30] : [AnimatedVector3D withValue:Vector3DMake(0, 0, 0)];
        card.location.onEnd = work; 
        card.location.curve = AnimationEaseInOut;

        [self layoutCards];
    });
}

-(void)clearCards
{
    self.cards = [[[NSMutableArray alloc] init] autorelease];
}

-(void)startDragForCard:(GLCard*)card
{
    if(self.draggedCard) { return; }
    
    self.draggedCard = card;
    self.initialAngle = card.angleFan.value;
    self.initialIndex = card.position;
    self.draggedCard.isSelected.value = 1;
}

-(void)dragCardToTarget:(int)target withDelta:(GLfloat)delta
{
    if(self.draggedCard) 
    {
        [self.cards removeObjectIdenticalTo:self.draggedCard];
        
        [self.cards insertObject:self.draggedCard atIndex:target];
        
        [self layoutCards];
        
        self.finalIndex = target;
        
        self.draggedCard.angleFan.value = self.initialAngle - delta * 25 / 480;
    }
}

-(void)stopDrag
{
    if(self.draggedCard) 
    { 
        if(self.initialIndex >= 0 && self.finalIndex >= 0)
        {
            [self.renderer.gameController moveCardIndex:self.initialIndex toIndex:self.finalIndex];
        }
        
        [self layoutCards];
        
        self.draggedCard.isSelected = 0;
        self.draggedCard = nil;
        self.initialAngle = 0.0;
        self.initialIndex = -1;
        self.finalIndex = -1;
    }
}

@end
