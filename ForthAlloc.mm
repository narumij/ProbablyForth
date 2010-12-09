//
//  ForthAlloc.m
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import "ForthAlloc.h"

#include <map>
#include <string>
#include <sstream>
#include <iostream>

using namespace std;

static int alloc_count = 0;
static int alloc_number = 0;

static map<void*,string> memory_map = map<void*,string>();

#if USE_FORTH_LEACK_CHECK_ALLOCATOR

void *ForthAllocWithLeakCheck( size_t size, const char *file, int line )
{
	alloc_count+=size;
	unsigned int *result =(unsigned int *) malloc(size+sizeof(unsigned int));
	result[0] = size;
	
	ostringstream oss;
	oss << "FILE: " << file << ", LINE: " << line << ", NUMBER : " << alloc_number;
	memory_map[result] = oss.str();
	
//	cout << "alloc number : " << alloc_number << endl;
	++alloc_number;
	
	return &result[1];
}

void ForthFreeWithLeackCheck( void *ptr )
{
	unsigned int *p = (unsigned int*)ptr;
	
	p = p - 1;
	alloc_count-= *p;
	memory_map.erase(p);
	free(p);
}

int ForthAllocatedBytes()
{
	return alloc_count;
}

void ForthPrintAllocatedBytes()
{
	printf("[Allocated:%d]\n",alloc_count);
}

void ForthPrintLeackCheck()
{
	map<void*,string>::iterator it = memory_map.begin();
	cout << "- LEAK_CHECK_BEGIN - " << endl;
	for( ; it != memory_map.end(); ++it )
	{
		cout << it->first << " " << it->second << " [MAYBE LEAKED.]" << endl;
	}
	cout << "- LEAK_CHECK_END - " << endl;
}

#else

#endif

