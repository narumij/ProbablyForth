//
//  ForthMathOperator.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthRegisters.h"

#ifdef __cplusplus
#define FORTH_MATH_OPERATOR_C_BEGIN extern "C" {
#define FORTH_MATH_OPERATOR_END }
#else
#define FORTH_MATH_OPERATOR_C_BEGIN
#define FORTH_MATH_OPERATOR_END
#endif

FORTH_MATH_OPERATOR_C_BEGIN

void ForthFuncMuli( ForthRegistersRef );
void ForthFuncMulf( ForthRegistersRef );
void ForthFuncMulvec2( ForthRegistersRef );
void ForthFuncMulvec3( ForthRegistersRef );
void ForthFuncMulvec4( ForthRegistersRef );

void ForthRegisterMathFunctions( ForthRegistersRef );

FORTH_MATH_OPERATOR_END

