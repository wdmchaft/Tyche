#import "GameRenderer.h"
#import "MenuController.h"
#import "MenuLayerController.h"
#import "TextControllerServerInfo.h"
#import "NSArray+Circle.h"

@implementation TextControllerServerInfo

@synthesize serverName = _serverName;
@synthesize serverIcon = _serverIcon;

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.padding = 0.4;
        self.center = NO;
    }
    
    return self;
}

-(void)update
{
    Color3D colorNormal      = Color3DMake(0.8, 0.2, 0, 0.7); 
    Color3D colorTouched     = Color3DMake(0.0, 0.0, 0, 0.7); 
    
    [self.styles setObject:[NSNumber numberWithFloat:0.0]                                         forKey:@"fadeMargin"]; 
    [self.styles setObject:[UIFont   fontWithName:@"Helvetica-Bold" size:20]                      forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3.75, 0.35)]                      forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];
    [self.styles setObject:[NSNumber numberWithBool:NO] forKey:@"hasShadow"]; 

    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"delete" forKey:@"key"]; 
        [label setObject:@"Join Game" forKey:@"textString"];
        [label setObject:[UIFont fontWithName:@"Helvetica-Bold" size:30] forKey:@"font"];
        [label setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(Color3D)] forKey:@"colorNormal"];
        [label setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3.5, 0.7)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"title2" forKey:@"key"]; 
        [label setObject:self.serverName forKey:@"textString"];     
        
        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"collapse" forKey:@"key"]; 
        [label setObject:self.serverIcon forKey:@"textString"]; 
        [label setObject:[UIFont fontWithName:@"Helvetica-Bold" size:150] forKey:@"font"];
        [label setObject:[NSValue valueWithCGSize:CGSizeMake(3, 2.5)] forKey:@"labelSize"];

        [labels addObject:label]; 
    }
        
    [self fillWithDictionaries:labels];
}

@end