//
//  ForthWord.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthWord.h"

#include <string.h>
#include "ForthAlloc.h"
#include "ForthCell.h"
#include "ForthThread.h"

struct ForthWord
{
	ForthWordRef prev;
	char *name;
	bool immediate;
	bool function;
	bool naked;
	ForthThreadRef thread;
};

ForthWordRef ForthWordCreate()
{
	ForthWordRef result = (ForthWordRef)ForthAlloc(sizeof(ForthWord));
	result->name = NULL;
	result->immediate = false;
	result->function = false;
	result->naked = false;
	result->thread = NULL;
	return result;
}

void ForthWordDelete( ForthWordRef w )
{
	if ( w->prev )
		ForthWordDelete( w->prev );
	
	if ( w->name )
		ForthFree(w->name);
	
	if ( w->thread )
//		ForthFree(w->thread);
		ForthThreadDelete(w->thread);
	
	ForthFree(w);
}

const char* ForthWordGetCString( ForthWordRef w )
{
	if ( w == NULL )
		return NULL;
	return w->name;
}

void ForthWordSetPrev( ForthWordRef w, ForthWordRef ww)
{
	w->prev = ww;
}

void ForthWordSetName( ForthWordRef w, const char *name )
{
	if ( w->name )
		ForthFree( w->name );
	int length = strlen(name);
	w->name = (char *)ForthAlloc(length+1);
	for( int i = 0; i < length; ++i )
		w->name[i] = name[i];
	w->name[length] = 0;
}

void ForthWordSetImmediate( ForthWordRef w, bool flag )
{
	w->immediate = flag;
}

void ForthWordSetFunction( ForthWordRef w, bool flag )
{
	w->function = flag;
}
void ForthWordSetNaked( ForthWordRef w, bool flag )
{
	w->naked = flag;
}


bool ForthWordGetImmediate( ForthWordRef w ) { return w->immediate; }
bool ForthWordGetFunction( ForthWordRef w ) { return w->function; }
bool ForthWordGetNaked( ForthWordRef w ) { return w->naked; }

bool ForthWordNameEql( ForthWordRef l, ForthWordRef r)
{
	for(int i = 0;;++i)
	{
		if ( l->name[i] != 0 && r->name[i] != 0 )
			return true;
		if ( l->name[i] != 0 || r->name[i] != 0 )
			return false;
	}
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

ForthWordRef ForthWordLookup( ForthWordRef w, const char *name )
{
	for(;;)
	{
		if ( w == NULL )
			return NULL;
		if ( w->name && StrEql(w->name, name))
			return w;
		w = w->prev;
	}
}

ForthThreadRef ForthWordGetThread( ForthWordRef w )
{
	return w->thread;
}

void ForthWordSetThread( ForthWordRef w, ForthThreadRef thread )
{
	ForthThreadCopyThread(&w->thread, thread);
}

void ForthWordPrint( ForthWordRef w )
{
	if ( w == NULL )
	{
		printf("[WORD:NULL]\n");
		return;
	}
	printf("[WORD:%s] (0x%lx) (IMMEDIATE:%s)",w->name,(unsigned long)w,w->immediate?"T":"NIL");
	printf(" THREAD(%d) -> ",ForthThreadCellCount(w->thread));
	ForthThreadDebugPrint(w->thread);
	printf("\n");
}

void ForthWordDump( ForthWordRef w )
{
	while ( w ) {
		ForthWordPrint(w);
		w = w->prev;
	}
}

//void ForthWordCompileIn( ForthWordRef, ForthCell *cell )
//{
//}












