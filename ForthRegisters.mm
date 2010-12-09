//
//  ForthRegisters.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthRegisters.h"
#import "ForthAlloc.h"
#import "ForthThread.h"

#include <vector>
using namespace std;

ForthRegistersRef ForthRegistersCreate()
{
	ForthRegistersRef ref = (ForthRegistersRef)ForthAlloc(sizeof(ForthRegisters));
	ref->param_stack = ForthStackCreate();
	ref->return_stack = ForthStackCreate();
	ref->dict = NULL;
	ref->pc = NULL;
	ref->compiling = false;
	return ref;
}

void ForthRegistersDelete( ForthRegistersRef ref )
{
	ForthStackDelete(ref->param_stack);
	ForthStackDelete(ref->return_stack);
	ForthWordDelete(ref->dict);
	ForthFree(ref);
}

void ForthRegistersCreateNewWord( ForthRegistersRef reg )
{
	ForthWordRef prev = reg->dict;
	reg->dict = ForthWordCreate();
	ForthWordSetPrev( reg->dict, prev );
}

ForthWordRef ForthRegistersGetCurrentWord( ForthRegistersRef reg )
{
	return reg->dict;
}

int ForthRegistersParameterStackCount( ForthRegistersRef reg )
{
	return ForthStackGetStackCount( reg->param_stack );
}

void ForthRegistersDump( ForthRegistersRef reg )
{
	printf("param_stack\n");
	ForthStackDump(reg->param_stack);
	printf("return_stack\n");
	ForthStackDump(reg->return_stack);
	printf("dict\n");
	ForthWordDump(reg->dict);
	printf("pc\n");
	if ( reg->pc )
		ForthCellDebugPrint(reg->pc);
	else
		printf("#<NULL>\n");
	
	printf("\ncompiling %s\n",reg->compiling ? "on" : "off" );
}

void ForthRegisterEntryFunction( ForthRegistersRef reg, ForthFuncPtr_t func, const char *name, bool immediate )
{
	ForthRegistersCreateNewWord(reg);
	ForthWordRef word = ForthRegistersGetCurrentWord(reg);
	assert(word);
	ForthThreadRef thread = ForthThreadCreateWithSize(2);
	ForthThreadAddCellStruct(thread, ForthCellCreateWithFunc(func) );
	ForthWordSetThread(word, thread);
	ForthWordSetImmediate(word, immediate);
	ForthWordSetFunction(word, true);
	ForthWordSetNaked(word, false);
	ForthWordSetName(word, name);
}


void ForthRegisterEntryNakedFunction( ForthRegistersRef reg, ForthFuncPtr_t func, const char *name, bool immediate )
{
	ForthRegistersCreateNewWord(reg);
	ForthWordRef word = ForthRegistersGetCurrentWord(reg);
	assert(word);
	ForthThreadRef thread = ForthThreadCreateWithSize(2);
	ForthThreadAddCellStruct(thread, ForthCellCreateWithNakedFunc(func) );
	ForthWordSetThread(word, thread);
	ForthWordSetImmediate(word, immediate);
	ForthWordSetFunction(word, true);
	ForthWordSetNaked(word, true);
	ForthWordSetName(word, name);
}


void ForthWordCompileInCell( ForthRegistersRef reg, ForthCell *cell )
{
	ForthWordRef w = ForthRegistersGetCurrentWord(reg);
	ForthThreadRef thread = ForthWordGetThread(w);
	ForthThreadAddCell( thread, cell );
}

void ForthWordCompileInThread( ForthRegistersRef reg, ForthThreadRef th )
{
	ForthWordRef w = ForthRegistersGetCurrentWord(reg);
	ForthThreadRef thread = ForthWordGetThread(w);
	ForthThreadAddThread( thread, th );
}


