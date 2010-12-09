//
//  ForthRegisters.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define FORTH_REGISTERS_C_BEGIN extern "C" {
#define FORTH_REGISTERS_C_END }
#else
#define FORTH_REGISTERS_C_BEGIN
#define FORTH_REGISTERS_C_END
#endif

FORTH_REGISTERS_C_BEGIN

#import "ForthStack.h"
#import "ForthWord.h"

struct ForthRegisters
{
	ForthStackRef param_stack;
	ForthStackRef return_stack;
	ForthWordRef dict;
	ForthCell *pc;
	bool compiling;
};

//typedef struct ForthRegisters *ForthRegistersRef;

ForthRegistersRef ForthRegistersCreate();
void ForthRegistersDelete( ForthRegistersRef );

void ForthRegistersCreateNewWord( ForthRegistersRef );
ForthWordRef ForthRegistersGetCurrentWord( ForthRegistersRef );

//ForthCell *ForthRegistersLookup( ForthRegistersRef reg, const char * s );

void ForthRegisterEntryFunction( ForthRegistersRef reg, ForthFuncPtr_t func, const char *name, bool immediate );
void ForthRegisterEntryNakedFunction( ForthRegistersRef reg, ForthFuncPtr_t func, const char *name, bool immediate );

int ForthRegistersParameterStackCount( ForthRegistersRef );
void ForthRegistersDump( ForthRegistersRef );

void ForthWordCompileInCell( ForthRegistersRef reg, ForthCell *cell );
void ForthWordCompileInThread( ForthRegistersRef reg, ForthThreadRef thread );


FORTH_REGISTERS_C_END

