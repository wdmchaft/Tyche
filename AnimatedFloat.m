#import "AnimatedFloat.h"

@implementation AnimatedFloat 

@synthesize startValue = _startValue;
@synthesize startTime  = _startTime;
@synthesize hasStarted = _hasStarted;

@synthesize endValue   = _endValue;
@synthesize endTime    = _endTime;
@synthesize hasEnded   = _hasEnded;

@synthesize curve      = _curve; 

@dynamic value;

-(id)initWithStartValue:(GLfloat)startValue endValue:(GLfloat)endValue startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime
{
    self = [super init];
    
    if(self)
    {
        _startValue  = startValue;
        _startTime   = startTime;
        _endValue    = endValue;
        _endTime     = startTime + TIMESCALE * animate * (endTime - startTime);
        _hasStarted  = NO;
        _hasEnded    = NO;
        _curve       = AnimationEaseInOut;
    }
    
    return self;
}

+(id)withValue:(GLfloat)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedFloat alloc] initWithStartValue:value endValue:value startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
}

+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue forTime:(NSTimeInterval)timeInterval
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + timeInterval onStart:nil onEnd:nil] autorelease];
}

+(id)withStartValue:(GLfloat)startValue endValue:(GLfloat)endValue speed:(GLfloat)speed
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();    
    
    if(speed == 0)
    {
        return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now onStart:nil onEnd:nil] autorelease];
    }
    else 
    {
        return [[[AnimatedFloat alloc] initWithStartValue:startValue endValue:endValue startTime:now endTime:now + absf(endValue, startValue) / speed onStart:nil onEnd:nil] autorelease];
    }
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"[%f5] -> [%f5] (Duration:%f5)", _startValue, _endValue, _endTime - _startTime];
}

-(void)dealloc
{
    [_onStart release];
    [_onEnd   release];
    
    [super dealloc];
}

-(GLfloat)value
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    if(now > self.startTime && !self.hasStarted) 
    {
        runLater(
        ^{
            if(self.onStart) { runLater(self.onStart); } 
            self.hasStarted = YES;         
        });
    }
    
    if(now > self.endTime && !self.hasEnded) 
    { 
        runLater(
        ^{
            if(self.onEnd) { runLater(self.onEnd); }
            self.hasEnded = YES; 
        });
    }
    
    if(now < self.startTime) { return self.startValue; }
    if(now > self.endTime)   { return self.endValue; }
    
    GLfloat delta = (now - self.startTime) / (self.endTime - self.startTime);
    
    GLfloat delta2 = delta * delta;
    GLfloat delta3 = delta * delta2;
    
    GLfloat proportion = delta;
    
    if(self.curve == AnimationEaseIn)    { proportion = (3 * delta - delta3) / 2; }
    if(self.curve == AnimationEaseOut)   { proportion = (3 * delta2 - delta3) / 2; }
    if(self.curve == AnimationEaseInOut) { proportion = (3 * delta2 - 2 * delta3); }
    
    return (1.0 - proportion) * self.startValue + (proportion) * self.endValue;
}

@end
