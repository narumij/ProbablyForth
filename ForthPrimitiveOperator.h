//
//  ForthPrimitiveOperator.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthRegisters.h"

#ifdef __cplusplus
#define FORTH_PRIM_OPERATOR_C_BEGIN extern "C" {
#define FORTH_PRIM_OPERATOR_END }
#else
#define FORTH_PRIM_OPERATOR_C_BEGIN
#define FORTH_PRIM_OPERATOR_END
#endif

FORTH_PRIM_OPERATOR_C_BEGIN

void ForthFuncNop( ForthRegistersRef );

void ForthFuncDrop( ForthRegistersRef );
void ForthFuncDup( ForthRegistersRef );
void ForthFuncSwap( ForthRegistersRef );

void ForthFuncPrint( ForthRegistersRef );

void ForthFuncCreate( ForthRegistersRef );
void ForthFuncName( ForthRegistersRef );
void ForthFuncImmediate( ForthRegistersRef );

//void ForthFuncParamToReturn();
//void ForthFuncReturnToParam();

void ForthRegisterPrimitiveFunctions( ForthRegistersRef );

FORTH_PRIM_OPERATOR_END

