//
//  ForthPrimitiveOperator.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthPrimitiveOperator.h"

#import "ForthRegisters.h"
#import "ForthStack.h"

void ForthFuncNop( ForthRegistersRef reg ) {}

void ForthFuncDrop( ForthRegistersRef reg )
{
	ForthStackDrop(reg->param_stack);
}

void ForthFuncDup( ForthRegistersRef reg )
{
	ForthCell cell = ForthCellCopy(ForthStackCellAt(reg->param_stack,0));
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthFuncSwap( ForthRegistersRef reg )
{
	ForthCell cell0 = ForthCellCopy(ForthStackCellAt(reg->param_stack,0));
	ForthCell cell1 = ForthCellCopy(ForthStackCellAt(reg->param_stack,1));
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthStackPushCell(reg->param_stack, &cell0);
	ForthStackPushCell(reg->param_stack, &cell1);
}

void ForthFuncPrint( ForthRegistersRef reg )
{
	ForthCellPrint( ForthStackCellAt(reg->param_stack, 0) );
	ForthStackDrop(reg->param_stack);
//	printf(" ok\n");
	printf("\n");
}

void ForthFuncCompilingOff( ForthRegistersRef reg )
{
	reg->compiling = false;
}

void ForthFuncCompilingOn( ForthRegistersRef reg )
{
	reg->compiling = true;
}

void ForthFuncCreate( ForthRegistersRef reg )
{
	ForthRegistersCreateNewWord(reg);
	ForthWordRef word = ForthRegistersGetCurrentWord(reg);
	ForthThreadRef thread = ForthThreadCreate();
	ForthWordSetThread(word, thread);
	ForthThreadDelete(thread);
}

void ForthFuncName( ForthRegistersRef reg )
{
	ForthWordRef word = ForthRegistersGetCurrentWord(reg);
	ForthWordSetName(word, ForthStackGetString(reg->param_stack,0) );
	ForthStackDrop(reg->param_stack);
}

void ForthFuncImmediate( ForthRegistersRef reg )
{
	ForthWordRef word = ForthRegistersGetCurrentWord(reg);
	ForthWordSetImmediate(word, true);
}

void ForthFuncBranchIf( ForthRegistersRef reg )
{
	bool flag = ForthStackGetBool(reg->param_stack,0);
	ForthStackDrop(reg->param_stack);
	if ( flag )
		reg->pc = (reg->pc+1)->cell;
	else
		reg->pc += 2;
}

void ForthFuncFetch( ForthRegistersRef reg )
{
	ForthCell *ptr = ForthStackCellAt(reg->param_stack,0)->cell;
	ForthStackDrop(reg->param_stack);
	ForthStackPushCell(reg->param_stack, ptr);
}

void ForthFuncStore( ForthRegistersRef reg )
{
	ForthCell *ptr = ForthStackCellAt(reg->param_stack,0)->cell;
	ForthStackDrop(reg->param_stack);
	*ptr = ForthCellCopy(ForthStackCellAt(reg->param_stack,0));
	ForthStackDrop(reg->param_stack);
}

void ForthFuncNot( ForthRegistersRef reg )
{
	bool flag = ForthStackGetBool(reg->param_stack,0);
	ForthStackDrop(reg->param_stack);
	
	ForthCell cell = ForthCellCreateWithBool(!flag);
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthFuncCompile( ForthRegistersRef reg )
{
	ForthWordRef w = ForthRegistersGetCurrentWord(reg);
	ForthThreadAddCell( ForthWordGetThread(w), reg->pc+1);
	reg->pc += 2;
}

void ForthFuncHere( ForthRegistersRef reg )
{
	ForthWordRef w = ForthRegistersGetCurrentWord(reg);
	ForthCell cell = ForthCellCreateCellPtr(ForthThreadGetLastCell(ForthWordGetThread(w)));
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthFuncMoveReturnToParam( ForthRegistersRef reg )
{
	ForthCell cell = ForthCellCopy(ForthStackCellAt(reg->return_stack,0));
	ForthStackPushCell(reg->param_stack, &cell);
	ForthStackDrop(reg->return_stack);
}

void ForthFuncMoveParamToReturn( ForthRegistersRef reg )
{
	ForthCell cell = ForthCellCopy(ForthStackCellAt(reg->param_stack,0));
	ForthStackPushCell(reg->return_stack, &cell);
	ForthStackDrop(reg->param_stack);
}

void ForthRegisterPrimitiveFunctions( ForthRegistersRef reg )
{
	
	ForthRegisterEntryFunction(reg, ForthFuncNop, "nop", false);
	ForthRegisterEntryFunction(reg, ForthFuncNot, "not", false);
	
	ForthRegisterEntryFunction(reg, ForthFuncDrop, "drop", false);
	ForthRegisterEntryFunction(reg, ForthFuncDup, "dup", false);
	ForthRegisterEntryFunction(reg, ForthFuncSwap, "swap", false);
	ForthRegisterEntryFunction(reg, ForthFuncPrint, "print", false);
	ForthRegisterEntryFunction(reg, ForthFuncPrint, ".", false);
	
	ForthRegisterEntryFunction(reg, ForthFuncFetch, "@", false);
	ForthRegisterEntryFunction(reg, ForthFuncStore, "!", false);

	ForthRegisterEntryFunction(reg, ForthFuncCompilingOff, "[", true);
	ForthRegisterEntryFunction(reg, ForthFuncCompilingOn, "]", false);
	
	ForthRegisterEntryFunction(reg, ForthFuncCreate, "create", false);
	ForthRegisterEntryFunction(reg, ForthFuncName, "name", false);
	ForthRegisterEntryFunction(reg, ForthFuncImmediate, "immediate", false);
	
	ForthRegisterEntryNakedFunction(reg, ForthFuncBranchIf, "branch-if", false);
	
	ForthRegisterEntryNakedFunction(reg, ForthFuncCompile, "compile", false);
	ForthRegisterEntryFunction(reg, ForthFuncHere, "here", false);

	ForthRegisterEntryFunction(reg, ForthFuncMoveParamToReturn, ">r", false);
	ForthRegisterEntryFunction(reg, ForthFuncMoveReturnToParam, "r>", false);
	
}

