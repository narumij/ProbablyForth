//
//  ForthCell.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthAlloc.h"

#ifdef __cplusplus
#define FORTH_CELL_C_BEGIN extern "C" {
#define FORTH_CELL_C_END }
#else
#define FORTH_CELL_C_BEGIN
#define FORTH_CELL_C_END
#endif

FORTH_CELL_C_BEGIN

const char *ForthValueName( ForthValueType_t value_type );
const char *ForthPtrName( ForthPtrType_t ptr_type );
int ForthNumCount( ForthValueType_t value_type );

#pragma mark -

char * ForthStringCopy( const char * s );
void ForthStringDelete( char * s );

#pragma mark -

struct ForthCell
{
	
	union {
		char *str;
		ForthCell     *cell;
		ForthFuncPtr_t func;
		ForthFloatPtr_t float_ptr;
		ForthInteger_t scalar_int;
		ForthUInteger_t scalar_uint;
//		ForthFloat_t scalar_float;
	};
	
	ForthValueType_t value_type;
	ForthPtrType_t ptr_type;
//	short value_type;
//	short ptr_type;
	
};

void ForthCellPrint( ForthCell *cell );
void ForthCellDebugPrint( ForthCell *cell );

#pragma mark -

ForthCell ForthCellCreateWithNull();
ForthCell ForthCellCreateWithAbort();

ForthCell ForthCellCreateWithNakedFunc( ForthFuncPtr_t func );
ForthCell ForthCellCreateWithFunc( ForthFuncPtr_t func );
ForthCell ForthCellCreateWithInt( ForthInteger_t num );
ForthCell ForthCellCreateWithBool(bool flag);

ForthCell ForthCellCreateCellPtr( ForthCell *cell );

ForthCell ForthCellCreateWithStringByHeap( const char * );
ForthCell ForthCellCreateWithFloatByHeap( float num );
ForthCell ForthCellCreateWithFloatvByHeap( ForthValueType_t value_type, const float *num );

#pragma mark -

//ForthCell ForthCellCopyByHeap( ForthCell *cell );
ForthCell ForthCellCopy( ForthCell *cell );

#pragma mark -

void ForthCellCleanUpHeap( ForthCell *cell );

#pragma mark -



bool ForthCellIsNull( ForthCell *cell );

bool ForthCellGetBool( ForthCell *cell );
ForthInteger_t ForthCellGetInteger( ForthCell *cell );

FORTH_CELL_C_END



