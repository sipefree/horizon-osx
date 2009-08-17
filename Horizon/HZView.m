#import "HZView.h"

@implementation HZView
-(id)initWithFrame:(NSRect)rect {
	if(self = [super initWithFrame:rect])
	{
		mTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:mTimer	forMode:NSDefaultRunLoopMode];
		mx = my = mz = 0.0;
		type = detect_sms();
	}
	return self;
}
#define ALPHA (4.0/5.0)
-(void)tick:(NSTimer*)theTimer
{
	double tx, ty, tz;
	tx = mx;
	ty = my;
	tz = mz;
	
	read_sms_real(type, &mx, &my, &mz);
	
	// due to jitteriness of the SMS, the new value is 4/5ths of the old
	// value and 1/5th of the next value.
	mx = ALPHA * tx + (1-ALPHA)*mx;
	my = ALPHA * ty + (1-ALPHA)*my;
	mz = ALPHA * tz + (1-ALPHA)*mz;
	
	[self setNeedsDisplay:YES];
}
-(void)drawRect:(NSRect)rect
{
	[[NSColor brownColor] set];
	NSRectFill(rect);

	
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path moveToPoint:NSMakePoint(0.0 - rect.size.width, rect.size.height/2.0)];
	[path lineToPoint:NSMakePoint(rect.size.width + rect.size.width, rect.size.height/2.0)];
	[path lineToPoint:NSMakePoint(rect.size.width + rect.size.width, rect.size.height + rect.size.height)];
	[path lineToPoint:NSMakePoint(0.0 - rect.size.width, rect.size.height + rect.size.height)];
	
	NSAffineTransform* trans = [NSAffineTransform transform];
	[trans translateXBy:rect.size.width/2.0 yBy:0];
	
	double rotateX = atan( mx / sqrt(my*my + mz*mz));
	double rotateY = atan( my / sqrt(mx*mx + mz*mz));
	
	[trans rotateByRadians:rotateX];
	
	[trans translateXBy:-rect.size.width/2.0 yBy:rect.size.height*rotateY/M_PI*2.0];
	
	NSPoint rotateCenter = [trans transformPoint:NSMakePoint(rect.size.width/2.0, rect.size.height/2.0)];
	
	[path transformUsingAffineTransform:trans];
	
	[[NSColor colorWithCalibratedRed:(56.0/255.0) green:(171.0/255.0) blue:(255.0/255.0) alpha:1.0] set];
	[path fill];
	[[NSColor whiteColor] set];
	[path stroke];
	
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[NSFont fontWithName:@"Lucida Grande" size:14.0] forKey:NSFontAttributeName];
	[dict setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
	// draw ruler
	
	[[NSColor whiteColor] set];
	
	NSBezierPath* lines = [NSBezierPath bezierPath];
	
	[@"- 0" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0-7.0) withAttributes:dict];
	[@"0 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0-7.0) withAttributes:dict];
	
	[@"- 15" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 + (15.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"15 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  + (15.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"- 15" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 - (15.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"15 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  - (15.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (5.0/90)*rect.size.width, rect.size.height/2.0 + (5.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (5.0/90)*rect.size.width, rect.size.height/2.0 + (5.0/90.0)*rect.size.height)];
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (5.0/90)*rect.size.width, rect.size.height/2.0 - (5.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (5.0/90)*rect.size.width, rect.size.height/2.0 - (5.0/90.0)*rect.size.height)];
	
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (10.0/90)*rect.size.width, rect.size.height/2.0 + (10.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (10.0/90)*rect.size.width, rect.size.height/2.0 + (10.0/90.0)*rect.size.height)];
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (10.0/90)*rect.size.width, rect.size.height/2.0 - (10.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (10.0/90)*rect.size.width, rect.size.height/2.0 - (10.0/90.0)*rect.size.height)];
	
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (15.0/90)*rect.size.width, rect.size.height/2.0 + (15.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (15.0/90)*rect.size.width, rect.size.height/2.0 + (15.0/90.0)*rect.size.height)];
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (15.0/90)*rect.size.width, rect.size.height/2.0 - (15.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (15.0/90)*rect.size.width, rect.size.height/2.0 - (15.0/90.0)*rect.size.height)];
	
	
	[@"- 30" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 + (30.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"30-" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  + (30.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"- 30" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 - (30.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"30 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  - (30.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (30.0/90)*rect.size.width, rect.size.height/2.0 + (30.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (30.0/90)*rect.size.width, rect.size.height/2.0 + (30.0/90.0)*rect.size.height)];
	[lines moveToPoint:NSMakePoint(rect.size.width/2.0 - (30.0/90)*rect.size.width, rect.size.height/2.0 - (30.0/90.0)*rect.size.height)];
	[lines lineToPoint:NSMakePoint(rect.size.width/2.0 + (30.0/90)*rect.size.width, rect.size.height/2.0 - (30.0/90.0)*rect.size.height)];
	
	
	[@"- 45" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 + (45.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"45 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  + (45.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"- 45" drawAtPoint:NSMakePoint(0.0, rect.size.height/2.0 - (45.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	[@"45 -" drawAtPoint:NSMakePoint(rect.size.width-30.0, rect.size.height/2.0  - (45.0/90.0)*rect.size.height-7.0) withAttributes:dict];
	
	[lines stroke];
	
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(rotateCenter.x-10.0, rotateCenter.y-10.0, 20.0, 20.0)] fill];
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(rotateCenter.x-20.0, rotateCenter.y-20.0, 40.0, 40.0)] stroke];
	
	NSMutableDictionary* dict2 = [[NSMutableDictionary alloc] init];
	[dict2 setValue:[NSFont fontWithName:@"Lucida Grande" size:12.0] forKey:NSFontAttributeName];
	[dict2 setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	
	[[NSString stringWithFormat:@"Elev: %i˚",(int)-(floor(rotateY*(180/M_PI)))] drawAtPoint:
	 NSMakePoint(rect.size.width/2.0-20.0, rect.size.height - 20.0) withAttributes:dict2];
	[[NSString stringWithFormat:@"Rot: %i˚",(int)-(floor(rotateX*(180/M_PI)))] drawAtPoint:
	 NSMakePoint(rect.size.width/2.0-20.0, rect.size.height - 40.0) withAttributes:dict2];
	
	double gravity = sqrt(mx*mx+my*my+mz*mz);
	double vertAcc = - (gravity*9.8 - 9.8);
	
	[[NSString stringWithFormat:@"G: %.1f",gravity] drawAtPoint:
	 NSMakePoint(rect.size.width/2.0-17.0, rect.size.height - 60.0) withAttributes:dict2];
	
	[[NSString stringWithFormat:@"V.Acc: %.1f m/s^2",vertAcc] drawAtPoint:
	 NSMakePoint(rect.size.width/2.0-45.0, rect.size.height - 80.0) withAttributes:dict2];
	
	[[NSColor blackColor] set];
	NSBezierPath* crosshair = [NSBezierPath bezierPath];
	[crosshair moveToPoint:NSMakePoint(rect.size.width/2.0 - rect.size.width*0.1, rect.size.height/2.0)];
	[crosshair lineToPoint:NSMakePoint(rect.size.width/2.0 + rect.size.width*0.1, rect.size.height/2.0)];
	[crosshair moveToPoint:NSMakePoint(rect.size.width/2.0, rect.size.height/2.0 + rect.size.height*0.1)];
	[crosshair lineToPoint:NSMakePoint(rect.size.width/2.0, rect.size.height/2.0 - rect.size.height*0.1)];
	[crosshair stroke];
}
@end
