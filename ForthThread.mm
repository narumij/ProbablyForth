//
//  ForthThread.m
//  ForthTest1
//
//  Created by narumij on 10/12/05.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthThread.h"

#import "ForthAlloc.h"


#if 0
int ForthThreadCellCount( ForthThreadRef thread )
{
	int i;
	for( i = 1; !ForthCellIsNull(thread); ++i,++thread ) { }
	return i;
}

void ForthThreadDebugPrint( ForthThreadRef thread )
{
	printf("#<THREAD 0x%lx [ ",(unsigned long)thread);
	if ( thread == NULL )
	{
		printf(" ] >");
		return;
	}
	
	for( int i = 0; i < ForthThreadCellCount(thread); ++i )
	{
		if ( i != 0 )
			printf(",");
		ForthCellDebugPrint(&thread[i]);
	}
	printf(" ] >");
}

ForthThreadRef ForthThreadCreate()
{
	return ForthThreadCreateWithSize(64);
}
ForthThreadRef ForthThreadCreateWithSize( int size )
{
	assert(size);
	ForthThreadRef result = (ForthThreadRef)ForthAlloc( sizeof(ForthCell) * size );
	for( int i = 0; i < size; ++i )
		result[i] = ForthNullCell();
	return result;
}
void ForthThreadDelete( ForthThreadRef thread )
{
	ForthFree( thread );
}
void ForthThreadAddCell( ForthThreadRef thread, ForthCell *cell )
{
	while (thread->value_type != FTH_NULL) {
		++thread;
	}
	*thread = ForthCellCopy(cell);
}
ForthCell *ForthThreadGetHeadCell( ForthThreadRef thread )
{
	return thread;
}
void ForthThreadClear( ForthThreadRef thread )
{
	while (thread->value_type != FTH_NULL) {
		*thread = ForthNullCell();
		++thread;
	}
}
#else

#include <vector>

using namespace std;

struct ForthThread
{
	vector<ForthCell> cells;
};


int ForthThreadCellCount( ForthThreadRef thread )
{
	return thread->cells.size();
}

void ForthThreadDebugPrint( ForthThreadRef thread )
{
	printf("#<THREAD 0x%lx [ ",(unsigned long)thread);
	if ( thread == NULL )
	{
		printf(" ] >");
		return;
	}
	
	for( int i = 0; i < ForthThreadCellCount(thread); ++i )
	{
		if ( i != 0 )
			printf(",");
		ForthCellDebugPrint(&thread->cells[i]);
	}
	printf(" ] >");
}

ForthThreadRef ForthThreadCreate()
{
	return ForthThreadCreateWithSize(64);
}
ForthThreadRef ForthThreadCreateWithSize( int size )
{
	ForthThreadRef thread = new ForthThread();
	thread->cells.resize( size, ForthCellCreateWithNull() );
	thread->cells.clear();
	thread->cells.push_back( ForthCellCreateWithNull() );
	return thread;
}
void ForthThreadDelete( ForthThreadRef thread )
{
	for( int i = 0; i < thread->cells.size(); ++i )
	{
		ForthCellCleanUpHeap( &thread->cells[i] );
	}
	delete thread;
}
void ForthThreadAddCellStruct( ForthThreadRef thread, ForthCell cell )
{
	thread->cells.back() = cell;
	thread->cells.push_back( ForthCellCreateWithNull() );
}
void ForthThreadAddCell( ForthThreadRef thread, ForthCell *cell )
{
	thread->cells.back() = ForthCellCopy(cell);
	thread->cells.push_back( ForthCellCreateWithNull() );
}
void ForthThreadAddThread( ForthThreadRef dest, ForthThreadRef source )
{
	dest->cells.erase( dest->cells.end() );
	copy(source->cells.begin(), source->cells.end(), back_inserter(dest->cells));
}

ForthCell *ForthThreadGetHeadCell( ForthThreadRef thread )
{
	return &thread->cells[0];
}
ForthCell *ForthThreadGetLastCell( ForthThreadRef th )
{
	if ( th->cells.size() < 2 )
		return NULL;
	
	return &th->cells[ th->cells.size() - 2 ];
}

void ForthThreadClear( ForthThreadRef thread )
{
	thread->cells.clear();
	thread->cells.push_back( ForthCellCreateWithNull() );
}
void ForthThreadCopyThread( ForthThreadRef *dest, ForthThreadRef source )
{
	if ( *dest == NULL )
		*dest = ForthThreadCreate();
	(*dest)->cells = source->cells;
}

#endif


