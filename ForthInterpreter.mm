//
//  ForthInterpreter.m
//  ForthTest1
//
//  Created by narumij on 10/12/05.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthInterpreter.h"

#include <assert.h>

void ForthFuncall( ForthRegistersRef reg, ForthFuncPtr_t func ) { func(reg); }

bool ForthInnerInterpreter( ForthRegistersRef reg )
{
	while ( reg->pc || !ForthStackIsEmpty(reg->return_stack) ) {
		switch (reg->pc->value_type) {
			case FTH_ABORT:
				assert(0&&"ERROR!!");
				break;
			case FTH_NULL:
			{
				if ( !ForthStackIsEmpty(reg->return_stack) )
				{
					reg->pc = ForthStackCellAt( reg->return_stack, 0)->cell;
					ForthStackDrop(reg->return_stack);
				}
				else
				{
					reg->pc = NULL;
				}
				break;
			}
			case FTH_NAKED_FUNC:
			{
				ForthFuncall( reg, reg->pc->func );
				break;
			}
			case FTH_FUNC:
			{
				ForthFuncall( reg, reg->pc->func );
				++reg->pc;
				break;
			}
			case FTH_CELL:
			{
				ForthCell cell = ForthCellCreateCellPtr(reg->pc+1);
				ForthStackPushCell( reg->return_stack, &cell );
				reg->pc = reg->pc->cell;
				break;
			}
			default:
			{
				ForthCell cell = ForthCellCopy(reg->pc);
				ForthStackPushCell(reg->param_stack, &cell );
				++reg->pc;
				break;
			}
		}
#if 0
		printf("--\n");
		printf("PC> ");
		if ( reg->pc )
			ForthCellDebugPrint(reg->pc);
		printf("\n");

		printf("P>");
		ForthStackPrint(reg->param_stack);
		printf("R>");
		ForthStackPrint(reg->return_stack);
#endif
	}
	return 1;
}

#pragma mark -

struct ForthInterpreterContext
{
	ForthCell cell[4];
	bool postpone;
};

ForthInterpreterContextRef ForthInterpreterContextCreate()
{
	ForthInterpreterContextRef ctx = new ForthInterpreterContext();
	ctx->cell[0] = ForthCellCreateWithNull();
	ctx->cell[1] = ForthCellCreateWithNull();
	ctx->cell[2] = ForthCellCreateWithAbort();
	ctx->postpone = false;
	return ctx;
}

void ForthInterpreterContextDelete( ForthInterpreterContextRef ctx )
{
	delete ctx;
}

static bool IsIntegerString( const char *s )
{
	const char c = '0';
	while (*s!=0) {
		if ( *s < c || ( c + 9 ) < *s )
			return false;
		++s;
	}
	return true;
}

static bool StrEql( const char *l, const char *r )
{
	for(int i = 0;;++i)
	{
		if ( l[i] != r[i] )
			return false;
		if ( l[i] == 0 && r[i] == 0 )
			return true;
	}
}

bool ForthInterpreter( ForthRegistersRef reg, ForthInterpreterContextRef ctx, const char *s )
{
	
	if ( StrEql(s, "postpone") )
	{
		ctx->postpone = true;
		return true;
	}
	
	ForthWordRef w = ForthWordLookup( reg->dict, s );
	
	if ( ctx->postpone )
	{
		assert(w && "POSTPONE FAILED.");
		
		if ( ForthWordGetNaked(w) )
		{
			ForthWordCompileInThread( reg, ForthWordGetThread(w) );
		}
		else
		{
			ForthCell cell = ForthCellCreateCellPtr(ForthThreadGetHeadCell(ForthWordGetThread(w)));
			ForthWordCompileInCell( reg, &cell );
		}
		
		ctx->postpone = false;
		return true;
	}
	
	if ( w )
	{
		if ( reg->compiling && !ForthWordGetImmediate(w) )
		{
//			if ( ForthWordGetNaked(w) )
			if ( ForthWordGetFunction(w) )
			{
				ForthWordCompileInThread( reg, ForthWordGetThread(w) );
			}
			else
			{
				ForthCell cell = ForthCellCreateCellPtr(ForthThreadGetHeadCell(ForthWordGetThread(w)));
				ForthWordCompileInCell( reg, &cell );
			}
		}
		else
		{
			ctx->cell[0] = ForthCellCreateCellPtr(ForthThreadGetHeadCell(ForthWordGetThread(w)));
		}
	}
	else
	{
		if ( reg->compiling )
		{
			ForthCell cell;
			if ( IsIntegerString(s) )
				cell = ForthCellCreateWithInt( atoi(s) );
			else
				cell = ForthCellCreateWithStringByHeap( s );
			ForthWordCompileInCell( reg, &cell );
			ForthCellCleanUpHeap(&cell);
		}
		else
		{
			if ( IsIntegerString(s) )
				ctx->cell[0] = ForthCellCreateWithInt( atoi(s) );
			else
				ctx->cell[0] = ForthCellCreateWithStringByHeap( s );
		}
	}
	
	if ( ctx->cell[0].value_type != FTH_NULL )
	{
		reg->pc = ctx->cell;
		ForthInnerInterpreter(reg);
		ForthCellCleanUpHeap( &ctx->cell[0] );
		ctx->cell[0] = ForthCellCreateWithNull();
	}
	
	assert( ctx->cell[2].value_type == FTH_ABORT && "ERROR!!" );
	
	return true;
}

