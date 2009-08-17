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
//  MotionSensor.m
//  iAlertU
//
//  Motion.c converted to Objective C Class to be used with Xcode by Randy Green on 3/22/06.
//  Copyright 2006 Slappingturtle. All rights reserved.
//

#import "MotionSensor.h"
#import <mach/mach.h>

@implementation MotionSensor

- (id) init
{
	[super init];
	return self;
}

- (void) dealloc
{
	IOServiceClose(dataPort);
	[super dealloc];
}

- (int) openMotionSensor
{	
	result = IOMasterPort(MACH_PORT_NULL, &masterPort);
	
	CFMutableDictionaryRef matchingDictionary = IOServiceMatching("SMCMotionSensor");
	result = IOServiceGetMatchingServices(masterPort, matchingDictionary, &iterator);
	
	aDevice = IOIteratorNext(iterator);
	IOObjectRelease(iterator);
	
	result = IOServiceOpen(aDevice, mach_task_self(), 0, &dataPort);
	IOObjectRelease(aDevice);
	
	if (result == KERN_SUCCESS)
	{
		kernelFunc = 5;
		structureInputSize = sizeof(mb_data);
		structureOutputSize = sizeof(mb_data);
		memset(&MBInputStructure, 0, sizeof(MBInputStructure));
		memset(&MBOutputStructure, 0, sizeof(MBOutputStructure));
		[self setMachineType: MB];
		return [self machineType];
	}
	
	matchingDictionary	= IOServiceMatching("IOI2CMotionSensor");
	result = IOServiceGetMatchingServices(masterPort, matchingDictionary, &iterator);
	
	aDevice = IOIteratorNext(iterator);
	IOObjectRelease(iterator);
	
	result = IOServiceOpen(aDevice, mach_task_self(), 0, &dataPort);
	IOObjectRelease(aDevice);
	
	if (result == KERN_SUCCESS)
	{
		kernelFunc = 21;
		structureInputSize = sizeof(pb_data);
		structureOutputSize = sizeof(pb_data);
		memset(&PBInputStructure, 0, sizeof(PBInputStructure));
		memset(&PBOutputStructure, 0, sizeof(PBOutputStructure));
		[self setMachineType: PB];
		return [self machineType];
	}
	
	matchingDictionary	= IOServiceMatching("PMUMotionSensor");
	result = IOServiceGetMatchingServices(masterPort, matchingDictionary, &iterator);
	
	aDevice = IOIteratorNext(iterator);
	IOObjectRelease(iterator);
	
	result = IOServiceOpen(aDevice, mach_task_self(), 0, &dataPort);
	IOObjectRelease(aDevice);
	
	if (result == KERN_SUCCESS)
	{
		kernelFunc = 21;
		structureInputSize = sizeof(pb_data);
		structureOutputSize = sizeof(pb_data);
		memset(&PBInputStructure, 0, sizeof(PBInputStructure));
		memset(&PBOutputStructure, 0, sizeof(PBOutputStructure));
		[self setMachineType: PBHR];
		return [self machineType];
	}
	
	[self setMachineType: NONE];
	return [self machineType];
}

- (void) setMachineType: (int) type
{
	machineType = type;
}

- (int) machineType
{
	return machineType;
}

- (data) coordinates
{
	memset(&coordinatesStruct, 0, sizeof(coordinatesStruct));
	
	switch ( [self machineType] ) {
        case MB:
			result = IOConnectMethodStructureIStructureO(dataPort, kernelFunc, structureInputSize, &structureOutputSize, &MBInputStructure, &MBOutputStructure);
			coordinatesStruct.x = MBOutputStructure.x;
			coordinatesStruct.y = MBOutputStructure.y;
			coordinatesStruct.z = MBOutputStructure.z;
			break;
		case PB:
			result = IOConnectMethodStructureIStructureO(dataPort, kernelFunc, structureInputSize, &structureOutputSize, &PBInputStructure, &PBOutputStructure);
			coordinatesStruct.x = PBOutputStructure.x;
			coordinatesStruct.y = PBOutputStructure.y;
			coordinatesStruct.z = PBOutputStructure.z;
			break;
		case PBHR:
			result = IOConnectMethodStructureIStructureO(dataPort, kernelFunc, structureInputSize, &structureOutputSize, &PBInputStructure, &PBOutputStructure);
			coordinatesStruct.x = PBOutputStructure.x;
			coordinatesStruct.y = PBOutputStructure.y;
			coordinatesStruct.z = PBOutputStructure.z;
			break;
    }
	
	return coordinatesStruct;
}

@end
