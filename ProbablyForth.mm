#import <Foundation/Foundation.h>

#import "ForthRegisters.h"
#import "ForthPrimitiveOperator.h"
#import "ForthMathOperator.h"
#import "ForthInterpreter.h"
#import "ForthAlloc.h"

#include <iostream>
#include <string>

using namespace std;

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *stdlib = [[NSArray arrayWithObjects:
						 @"create ] create ] [ { name { postpone [ [ } name immediate",
						 @"{ r> drop } exit name",
						 @"{ compile not compile branch-if compile nop here } if name immediate",
						 @"{ compile nop here swap ! } then name immediate",
						 @"{ compile 1 compile branch-if compile nop here swap compile nop here swap ! } else name immediate",
						 @"{ compile nop here } begin name immediate",
						 @"{ compile 1 compile branch-if compile nop here ! } again name immediate",
						 nil] componentsJoinedByString:@" "];
	
	ForthRegistersRef reg = ForthRegistersCreate();
	ForthInterpreterContextRef ctx = ForthInterpreterContextCreate();
	ForthRegisterPrimitiveFunctions(reg);
	ForthRegisterMathFunctions(reg);
	//	ForthPrintAllocatedBytes();
	
	for( NSString *s in [stdlib componentsSeparatedByString:@" "] )
	{
		ForthInterpreter(reg, ctx, [s UTF8String]);
	}
	
	cout << "LOL Forth Imitation ver 0.1" << endl;
	cout << "type \"bye\" when you wanna exit." << endl;
	cout << endl;
	
	for(;;)
	{
		cout << "<" << ForthRegistersParameterStackCount(reg) << "> ";
		string ss;
		std::getline(std::cin, ss);
		if ( ss == "bye" )
			goto EXIT_LABEL;
		for( NSString *s in [[NSString stringWithUTF8String:ss.c_str()] componentsSeparatedByString:@" "] )
		{
			ForthInterpreter(reg, ctx, [s UTF8String]);
		}
	}
	
EXIT_LABEL:
	//	ForthRegistersDump(reg);
	//	ForthInterpreterContextDelete(ctx);
	//	ForthRegistersDelete(reg);
	//	ForthPrintAllocatedBytes();
	//	ForthPrintLeackCheck();
	
    [pool drain];
    return 0;
}
