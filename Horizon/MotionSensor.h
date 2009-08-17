/* motion.c
*
* a little program to display the coords returned by
* the powerbook motion sensor
*
* A fine piece of c0de, brought to you by
*
*               ---===---
* *** teenage mutant ninja hero coders ***
*               ---===---
*
* All of the software included is copyrighted by Christian Klein <chris@5711.org>.
*
* Copyright 2005 Christian Klein. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 3. All advertising materials mentioning features or use of this software
*    must display the following acknowledgement:
*	This product includes software developed by Christian Klein.
* 4. The name of the author must not be used to endorse or promote
*    products derived from this software
*    without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
		   * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*
* Modified for iBook compatibility by Pall Thayer <http://www.this.is/pallit>
*/

//
//  MotionSensor.h
//  iAlertU
//
//  Motion.c converted to Objective C Class to be used with Xcode by Randy Green on 3/22/06.
//  Copyright 2006 SlappingTurtle. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/IOKitLib.h>

// MacBook kernel funtion 5, pad 37, service match SMCMotionSensor
// PB and iBook kernel function 21, pad 57, service match IOI2CMotionSensor
// PB HR kernel function 21, pad 57, service match PMUMotionSensor
 
enum model {
    NONE = 0,
    MB = 1,
    PB = 2,
    PBHR = 3
};

typedef struct
{
	char x;
	char y;
	char z;
	char pad[37];
} mb_data;

typedef struct
{
	char x;
	char y;
	char z;
	char pad[57];
} pb_data;

typedef struct
{
	char x;
	char y;
	char z;
} data;

@interface MotionSensor : NSObject {
	
	int kernelFunc;
	int machineType;
	
	int xCurrent;
	int yCurrent;
	int zCurrent;
	
	kern_return_t result;
	mach_port_t masterPort;
	
	io_iterator_t iterator;
	io_object_t aDevice;
	io_connect_t  dataPort;

	IOItemCount structureInputSize;
	IOByteCount structureOutputSize;

	mb_data MBInputStructure;
	mb_data MBOutputStructure;
	
	pb_data PBInputStructure;
	pb_data PBOutputStructure;
	
	data coordinatesStruct;
}

- (int) openMotionSensor;
- (data) coordinates;

- (void) setMachineType: (int) type;
- (int) machineType; 
@end
