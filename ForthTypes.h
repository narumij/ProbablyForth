//
//  ForthTypes.h
//  ForthTest1
//
//  Created by narumij on 10/12/07.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

/* expected same bit length as void pointer */
typedef long ForthInteger_t;
typedef unsigned long ForthUInteger_t;
/* */

enum ForthValueTypes {
	/* FTH_PTR */
	FTH_NULL,
	
	FTH_ABORT,
	
	FTH_NAKED_FUNC,
	FTH_FUNC,
	FTH_CELL,
	
	/* FTH_SCALAR */
	FTH_INT,
	
	/* FTH_HEAP or FTH_REF */
	FTH_STR,
	
	FTH_FLOAT,
	FTH_VEC2,
	FTH_VEC3,
	FTH_VEC4,
	FTH_MAT2,
	FTH_MAT3,
	FTH_MAT4,
	
	NUM_FTH_VALUE_TYPE,
};

enum ForthPtrTypes {
	FTH_PTR,
	FTH_SCALAR,
	FTH_HEAP,
	FTH_REF,
	
	NUM_FTH_PTR_TYPE,
};

#if 0
typedef enum ForthPtrTypes ForthPtrType_t;
typedef enum ForthValueTypes ForthValueType_t;
#else
typedef short ForthPtrType_t;
typedef short ForthValueType_t;
#endif

typedef float ForthFloat_t;
typedef float *ForthFloatPtr_t;

typedef struct ForthRegisters *ForthRegistersRef;
typedef void (*ForthFuncPtr_t)( ForthRegistersRef );
typedef struct ForthCell ForthCell;
//typedef char * ForthStringRef;







