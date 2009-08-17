#import <Cocoa/Cocoa.h>
#include "unimotion.h"
typedef enum {
    raw,
    calibrated,
    real,
    bytes,
    scaled
} disp_t;
@interface HZView : NSView {
	NSTimer* mTimer;
	double mx,my,mz;
	int type;
}

@end
