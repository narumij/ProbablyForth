//
//  ForthCell.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthCell.h"

static void ForthFloatPrint( ForthFloatPtr_t num, ForthValueType_t type )
{
	switch (type) {
		case FTH_FLOAT:
			printf("%f",num[0]);
			break;
		case FTH_VEC2:
			printf("(%f %f)",num[0],num[1]);
			break;
		case FTH_VEC3:
			printf("(%f %f %f)",num[0],num[1],num[2]);
			break;
		case FTH_VEC4:
			printf("(%f %f %f %f)",num[0],num[1],num[2],num[3]);
			break;
		case FTH_MAT3:
			printf("\n");
			printf("|%f %f %f|\n",num[0],num[3],num[6]);
			printf("|%f %f %f|\n",num[1],num[4],num[7]);
			printf("|%f %f %f|\n",num[2],num[5],num[8]);
			break;
		case FTH_MAT4:
			printf("\n");
			printf("|%f %f %f %f|\n",num[0],num[4],num[8],num[12]);
			printf("|%f %f %f %f|\n",num[1],num[5],num[9],num[13]);
			printf("|%f %f %f %f|\n",num[2],num[6],num[10],num[14]);
			printf("|%f %f %f %f|\n",num[3],num[7],num[11],num[15]);
			break;
		default:
			break;
	}
}

const char *ForthValueName( ForthValueType_t value_type )
{
	switch (value_type) {
		case FTH_NULL:
			return "NULL";
			break;
			
		case FTH_NAKED_FUNC:
			return "NAKED_FUNC";
			break;
		case FTH_FUNC:
			return "FUNC";
			break;
			
		case FTH_INT:
			return "INT";
			break;
			
		case FTH_CELL:
			return "CELL";
			break;
			
			
		case FTH_STR:
			return "STR";
			break;
			
		case FTH_FLOAT:
			return "FLOAT";
			break;
		case FTH_VEC2:
			return "VEC2";
			break;
		case FTH_VEC3:
			return "VEC3";
			break;
		case FTH_VEC4:
			return "VEC4";
			break;
		default:
			break;
	}
	return NULL;
}

const char *ForthPtrName( ForthPtrType_t ptr_type )
{
	switch (ptr_type) {
		case FTH_PTR:
			return "PTR";
			break;
		case FTH_HEAP:
			return "HEAP";
			break;
		case FTH_REF:
			return "REF";
			break;
		default:
			break;
	}
	return NULL;
}

int ForthNumCount( ForthValueType_t value_type )
{
	int size = 0;
	switch (value_type) {
		case FTH_FLOAT:
			size = 1;
			break;
		case FTH_VEC2:
			size = 2;
			break;
		case FTH_VEC3:
			size = 3;
			break;
		case FTH_VEC4:
			size = 4;
			break;
		default:
			break;
	}
	return size;
}

char * ForthStringCopy( const char * s )
{
	int length = strlen(s);
	char * result = (char *)ForthAlloc(length+1);
	for( int i = 0; i < length; ++i )
		result[i] = s[i];
	result[length] = 0;
	return result;
};

void ForthStringDelete( char * s )
{
	ForthFree(s);
}

#pragma mark -

void ForthCellPrint( ForthCell *cell )
{
	switch (cell->value_type) {
		case FTH_NULL:
			assert(cell->cell == 0 );
			break;
		case FTH_NAKED_FUNC:
			printf("0x%lx - 0x%lx",(unsigned long)cell,(unsigned long)cell->func);
			break;
		case FTH_FUNC:
			printf("0x%lx - 0x%lx",(unsigned long)cell,(unsigned long)cell->func);
			break;
		case FTH_CELL:
			printf("0x%lx - 0x%lx",(unsigned long)cell,(unsigned long)cell->cell);
			break;
		case FTH_STR:
			printf("\"%s\"",cell->str);
			break;
		case FTH_INT:
			printf("%d",(int)cell->scalar_int);
			break;
		default:
			ForthFloatPrint(cell->float_ptr, cell->value_type);
			break;
	}
}

void ForthCellDebugPrint( ForthCell *cell )
{
	printf("#<%s ",ForthValueName(cell->value_type));
	ForthCellPrint(cell);
	printf(">");
}

#pragma mark -

ForthCell ForthCellCreateWithNull()
{
	ForthCell result;
	result.func = NULL;
	result.value_type = FTH_NULL;
	result.ptr_type = FTH_PTR;
	return result;
}

ForthCell ForthCellCreateWithAbort()
{
	ForthCell result;
	result.func = NULL;
	result.value_type = FTH_ABORT;
	result.ptr_type = FTH_PTR;
	return result;
}

ForthCell ForthCellCreateWithNakedFunc( ForthFuncPtr_t func )
{
	ForthCell result;
	result.func = func;
	result.value_type = FTH_NAKED_FUNC;
	result.ptr_type = FTH_PTR;
	return result;
}

ForthCell ForthCellCreateWithFunc( ForthFuncPtr_t func )
{
	ForthCell result;
	result.func = func;
	result.value_type = FTH_FUNC;
	result.ptr_type = FTH_PTR;
	return result;
}


ForthCell ForthCellCreateWithInt( ForthInteger_t num )
{
	ForthCell cell;
	cell.scalar_int = num;
	cell.value_type = FTH_INT;
	cell.ptr_type = FTH_SCALAR;
	return cell;
}

ForthCell ForthCellCreateWithBool(bool flag)
{
	return ForthCellCreateWithInt(flag);
}

ForthCell ForthCellCreateCellPtr( ForthCell *cell )
{
	ForthCell result;
	result.cell = cell;
	result.value_type = FTH_CELL;
	result.ptr_type = FTH_PTR;
	return result;
}

#pragma mark -

ForthCell ForthCellCreateWithStringByHeap( const char * s )
{
	ForthCell result;
	result.str = ForthStringCopy( s );
	result.value_type = FTH_STR;
	result.ptr_type = FTH_HEAP;
	return result;
}

ForthCell ForthCellCreateWithFloatByHeap( float num )
{
	ForthCell cell;
	cell.float_ptr = (ForthFloat_t*)ForthAlloc(sizeof(ForthFloat_t));
	cell.float_ptr[0] = num;
	cell.value_type = FTH_FLOAT;
	cell.ptr_type = FTH_HEAP;
	return cell;
}

ForthCell ForthCellCreateWithFloatvByHeap( ForthValueType_t value_type, const float *num )
{
	int size = ForthNumCount(value_type);
	assert(size);
	
	ForthCell cell;
	cell.float_ptr = (ForthFloat_t*)ForthAlloc(sizeof(ForthFloat_t)*size);
	
	for( int i = 0; i < size; ++i )
	{
		cell.float_ptr[i] = num[i];
	}
	cell.value_type = value_type;
	cell.ptr_type = FTH_HEAP;
	return cell;
}

#pragma mark -

static ForthCell ForthCellCopyByHeap( ForthCell *cell )
{
	switch (cell->value_type) {
		case FTH_NULL:
		case FTH_NAKED_FUNC:
		case FTH_FUNC:
		case FTH_CELL:
		case FTH_INT:
			assert(0);
			break;
		case FTH_STR:
			return ForthCellCreateWithStringByHeap(cell->str);
			break;
		case FTH_FLOAT:
		case FTH_VEC2:
		case FTH_VEC3:
		case FTH_VEC4:
		case FTH_MAT3:
		case FTH_MAT4:
			return ForthCellCreateWithFloatvByHeap(cell->value_type, cell->float_ptr);
			break;
		default:
			assert(0);
			break;
	}
	return ForthCellCreateWithNull();
}

ForthCell ForthCellCopy( ForthCell *cell )
{
	switch (cell->ptr_type) {
		case FTH_SCALAR:
		case FTH_PTR:
			return *cell;
			break;
		default:
			return ForthCellCopyByHeap(cell);
			break;
	}
}

#pragma mark -

void ForthCellCleanUpHeap( ForthCell *cell )
{
	if ( cell->ptr_type == FTH_HEAP )
	{
		ForthFree(cell->float_ptr);
	}
}

#pragma mark -

bool ForthCellIsNull( ForthCell *cell )
{
	return cell->value_type == FTH_NULL;
}

bool ForthCellGetBool( ForthCell *cell )
{
	return cell->scalar_int;
}

ForthInteger_t ForthCellGetInteger( ForthCell *cell )
{
	return cell->scalar_int;
}




