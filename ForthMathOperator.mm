//
//  ForthMathOperator.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthMathOperator.h"

void ForthFuncAddi( ForthRegistersRef reg )
{
	ForthInteger_t i;
	i = ForthStackGetInt(reg->param_stack,1,0) + ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell c = ForthCellCreateWithInt(i);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncSubi( ForthRegistersRef reg )
{
	ForthInteger_t i;
	i = ForthStackGetInt(reg->param_stack,1,0) - ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell c = ForthCellCreateWithInt(i);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncMuli( ForthRegistersRef reg )
{
	ForthInteger_t i;
	i = ForthStackGetInt(reg->param_stack,1,0) * ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell c = ForthCellCreateWithInt(i);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncDivi( ForthRegistersRef reg )
{
	ForthInteger_t i;
	i = ForthStackGetInt(reg->param_stack,1,0) / ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell c = ForthCellCreateWithInt(i);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncMulf( ForthRegistersRef reg )
{
	float f;
	f = ForthStackGetFloat(reg->param_stack,0,0) * ForthStackGetFloat(reg->param_stack,1,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
//	ForthStackPushByCopy(reg->param_stack, FTH_FLOAT, &num);
	ForthCell c = ForthCellCreateWithFloatByHeap(f);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncMulvec2( ForthRegistersRef reg )
{
//	assert( ForthStackTypeAt(reg->param_stack, 0) == ForthStackTypeAt(reg->param_stack, 1) );
//	assert( ForthStackTypeAt(reg->param_stack, 0) == FTH_VEC2 );
//	ForthNum num[2];
	float num[2];
	for( int i = 0; i < 2; ++i )
		num[i] = ForthStackGetFloat(reg->param_stack,0,i) * ForthStackGetFloat(reg->param_stack,1,i);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
//	ForthStackPushByCopy(reg->param_stack, FTH_VEC2, num);
	ForthCell c = ForthCellCreateWithFloatvByHeap(FTH_VEC2,num);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncMulvec3( ForthRegistersRef reg )
{
//	assert( ForthStackTypeAt(reg->param_stack, 0) == ForthStackTypeAt(reg->param_stack, 1) );
//	assert( ForthStackTypeAt(reg->param_stack, 0) == FTH_VEC3 );
	float num[3];
	for( int i = 0; i < 3; ++i )
		num[i] = ForthStackGetFloat(reg->param_stack,0,i) * ForthStackGetFloat(reg->param_stack,1,i);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
//	ForthStackPushByCopy(reg->param_stack, FTH_VEC3, num);
	ForthCell c = ForthCellCreateWithFloatvByHeap(FTH_VEC3,num);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncMulvec4( ForthRegistersRef reg )
{
	float num[4];
	for( int i = 0; i < 4; ++i )
		num[i] = ForthStackGetFloat(reg->param_stack,0,i) * ForthStackGetFloat(reg->param_stack,1,i);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell c = ForthCellCreateWithFloatvByHeap(FTH_VEC4,num);
	ForthStackPushCell(reg->param_stack, &c);
}

void ForthFuncLessi( ForthRegistersRef reg )
{
	bool flag;
	flag = ForthStackGetInt(reg->param_stack,1,0) < ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell cell = ForthCellCreateWithBool(flag);
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthFuncGreatori( ForthRegistersRef reg )
{
	bool flag;
	flag = ForthStackGetInt(reg->param_stack,1,0) > ForthStackGetInt(reg->param_stack,0,0);
	ForthStackDrop(reg->param_stack);
	ForthStackDrop(reg->param_stack);
	ForthCell cell = ForthCellCreateWithBool(flag);
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthFuncEvenp( ForthRegistersRef reg )
{
	bool flag = (ForthStackGetInt(reg->param_stack,0,0) % 2) == 0;
	ForthStackDrop(reg->param_stack);
	ForthCell cell = ForthCellCreateWithBool(flag);
	ForthStackPushCell(reg->param_stack, &cell);
}

void ForthRegisterMathFunctions( ForthRegistersRef reg )
{
	ForthRegisterEntryFunction(reg, ForthFuncAddi, "+", false);
	ForthRegisterEntryFunction(reg, ForthFuncSubi, "-", false);
	ForthRegisterEntryFunction(reg, ForthFuncMuli, "*", false);
	ForthRegisterEntryFunction(reg, ForthFuncDivi, "/", false);
	
	ForthRegisterEntryFunction(reg, ForthFuncGreatori, ">", false);
	ForthRegisterEntryFunction(reg, ForthFuncLessi, "<", false);

	ForthRegisterEntryFunction(reg, ForthFuncEvenp, "evenp", false);
}





