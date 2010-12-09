//
//  ForthStack.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthStack.h"

#import "ForthAlloc.h"

//ForthNum *ForthStackNumAt( ForthStackRef s, int index );
void *ForthStackPtrAt( ForthStackRef s, int index );

#include <vector>

using namespace std;

struct ForthStack
{
//	vector<ForthNum> num_data;
	vector<ForthCell> stack;
	ForthStack() : stack() {}
	
#if 1
	void* operator new (size_t size)
	{
		return ForthAlloc(size);
	}
	void operator delete (void* p)
	{
		ForthFree(p);
	}
#endif
};

ForthStackRef ForthStackCreate()
{
	return new ForthStack();
}
void ForthStackDelete( ForthStackRef s )
{
	for( int i = 0; i < s->stack.size(); ++i )
	{
		ForthCellCleanUpHeap(&s->stack[i]);
	}
	delete s;
}

int ForthStackGetStackCount( ForthStackRef s )
{
	return s->stack.size();
}

void ForthStackDump( ForthStackRef s )
{
	printf("- STACK_DUMP_BEGIN -\n");
	for( int i = 0; i < s->stack.size(); ++i )
	{
		printf("[STACK:%d] %s (%s) \n 0x%08lx -> ",
			   i,
			   ForthValueName(s->stack[i].value_type),
			   ForthPtrName(s->stack[i].ptr_type),
//			   (unsigned long)s->stack[i].ptr );
			   (unsigned long)ForthStackPtrAt(s, s->stack.size() - i - 1) );
		ForthCellDebugPrint( &s->stack[i] );
		printf("\n");
	}
//	for( int i = 0; i < s->num_data.size(); ++i )
//	{
//		printf("[NUM:%d] %d %.3f\n",i,s->num_data[i].i,s->num_data[i].f);
//	}
	printf("- STACK_DUMP_END -");
	printf("\n\n");
}

void ForthStackPrint( ForthStackRef s )
{
	printf("> ");
	for( int i = 0; i < s->stack.size(); ++i )
	{
		if ( i != 0 ) printf(",");
		ForthCellDebugPrint( &s->stack[i] );
	}
	printf("\n");
}

bool ForthStackPushCell( ForthStackRef s, ForthCell *cell )
{
	s->stack.push_back( *cell );
	return true;
}

ForthCell *ForthStackReverseValueRefAt( ForthStackRef s, int index )
{
	return &(s->stack[index]);
}

ForthCell *ForthStackCellAt( ForthStackRef s, int index )
{
	return &(*(s->stack.end()-index-1));
}

void *ForthStackPtrAt( ForthStackRef s, int index )
{
	ForthCell *p = ForthStackCellAt(s, index);
	if ( p->ptr_type == FTH_REF )
		return p->cell;

	if ( p->ptr_type == FTH_HEAP )
		return p->cell;

//	if ( p->ptr_type == FTH_NUM_STACK )
//		return (ForthNum*)((char*)&s->num_data[0] + (int)p->num);
//	assert(0);
	return NULL;
}

bool ForthStackDrop( ForthStackRef s)
{
	ForthCellCleanUpHeap(&s->stack.back());
	s->stack.erase( s->stack.end() );
//	ForthPrintAllocatedBytes();
	return true;
}

bool ForthStackIsEmpty( ForthStackRef s)
{
	return s->stack.empty();
}


#pragma mark -

bool ForthStackPushFloat( ForthStackRef s, float f )
{
	ForthCell c = ForthCellCreateWithFloatByHeap(f);
	ForthStackPushCell(s, &c);
	return true;
}

bool ForthStackPushFloatv( ForthStackRef s, ForthValueType_t type, float *v )
{
	ForthCell c = ForthCellCreateWithFloatvByHeap(type,v);
	ForthStackPushCell(s, &c);
	return true;
}

bool ForthStackPushInt( ForthStackRef s, ForthInteger_t i )
{
	ForthCell c = ForthCellCreateWithInt(i);
	ForthStackPushCell(s, &c);
	return true;
}

bool ForthStackPushString( ForthStackRef s, const char * str )
{
	ForthCell c = ForthCellCreateWithStringByHeap(str);
	ForthStackPushCell(s, &c);
	return true;
}

ForthInteger_t ForthStackGetInt( ForthStackRef s, int stack_index, int num_index )
{
//	return ForthStackNumAt(s, stack_index)[num_index].i;
	return ForthStackCellAt(s, stack_index)->scalar_int;
}

float ForthStackGetFloat( ForthStackRef s, int stack_index, int num_index )
{
	return ((float*)ForthStackPtrAt(s, stack_index))[num_index];
}

const char *ForthStackGetString( ForthStackRef s, int stack_index )
{
	ForthCell *cell = ForthStackCellAt(s, stack_index);
	return cell->str;
}

bool ForthStackGetBool( ForthStackRef s, int stack_index )
{
	ForthCell *cell = ForthStackCellAt(s, stack_index);
	return ForthCellGetBool(cell);
}

