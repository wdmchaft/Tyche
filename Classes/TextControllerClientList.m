#import "GameRenderer.h"
#import "MenuLayerController.h"

#import "TextControllerClientList.h"

@implementation TextControllerClientList

-(id)init
{
    self = [super init];
    
    if(self)
    {   
        self.padding = 0.4;
        self.center = YES;
    }
    
    return self;
}

-(void)update
{
    Color3D colorNormal      = Color3DMake(0.8, 0, 0, 0.9); 
    Color3D colorTouched     = Color3DMake(0,   0, 0, 0.9); 
    //Color3D labelColorTransparent = Color3DMake(1,   1, 1, 0.9); 
    
    [self.styles setObject:[NSNumber numberWithFloat:0.1]                                    forKey:@"fadeMargin"]; 
    [self.styles setObject:[UIFont   fontWithName:@"Helvetica-Bold" size:20]                 forKey:@"font"];
    [self.styles setObject:[NSValue  valueWithCGSize:CGSizeMake(3, 0.35)]                    forKey:@"labelSize"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorNormal  objCType:@encode(Color3D)] forKey:@"colorNormal"];
    [self.styles setObject:[NSValue  valueWithBytes:&colorTouched objCType:@encode(Color3D)] forKey:@"colorTouched"];
    
    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"join_multiplayer" forKey:@"key"]; 
        [label setObject:@"Connecting..."    forKey:@"textString"];          
        [label setObject:[NSValue  valueWithBytes:&colorTouched  objCType:@encode(Color3D)] forKey:@"colorNormal"];
        
        [labels addObject:label]; 
    }
    
    { 
        //☐☑☒✖
                
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"new_multiplayer" forKey:@"key"]; 
        [label setObject:@"Joel's asddasdsasadsdsdsad iPhone"   forKey:@"textString"];     
        [label setObject:@" ☐ "             forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"new_game"    forKey:@"key"]; 
        [label setObject:@"John's iPod" forKey:@"textString"]; 
        [label setObject:@" ☑ "         forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"calibrate"    forKey:@"key"]; 
        [label setObject:@"Jim's iPhone" forKey:@"textString"]; 
        [label setObject:@" ☒ "          forKey:@"bulletLeftString"];
        [label setObject:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];

        [labels addObject:label]; 
    }
    
    { 
        NSMutableDictionary* label = [[[NSMutableDictionary alloc] init] autorelease]; 
        
        [label setObject:@"start"      forKey:@"key"]; 
        [label setObject:@"Start Game" forKey:@"textString"];          
        
        [labels addObject:label]; 
    }
    
    
    [(NSMutableDictionary*)[labels objectAtIndex:0] setObject:[UIFont  fontWithName:@"Helvetica-Bold" size:35] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:0] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.5)]  forKey:@"labelSize"];
    [(NSMutableDictionary*)[labels objectAtIndex:4] setObject:[UIFont  fontWithName:@"Helvetica-Bold" size:35] forKey:@"font"];
    [(NSMutableDictionary*)[labels objectAtIndex:4] setObject:[NSValue valueWithCGSize:CGSizeMake(3.75, 0.5)]  forKey:@"labelSize"];
    
    [self fillWithDictionaries:labels];
}

@end