//
//  ForthAlloc.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthTypes.h"

#ifdef __cplusplus
#define FORTH_ALLOC_C_BEGIN extern "C" {
#define FORTH_ALLOC_C_END }
#else
#define FORTH_ALLOC_C_BEGIN
#define FORTH_ALLOC_C_END
#endif

FORTH_ALLOC_C_BEGIN

#if !defined(USE_FORTH_LEACK_CHECK_ALLOCATOR)
#ifndef NDEBUG
#define USE_FORTH_LEACK_CHECK_ALLOCATOR 1
#else
#define USE_FORTH_LEACK_CHECK_ALLOCATOR 0
#endif
#endif

#if USE_FORTH_LEACK_CHECK_ALLOCATOR
void *ForthAllocWithLeakCheck( size_t size, const char *file, int line );
void ForthFreeWithLeackCheck( void *ptr );
#define ForthAlloc( size ) ForthAllocWithLeakCheck( size, __FILE__, __LINE__ )
#define ForthFree( ptr ) ForthFreeWithLeackCheck( ptr )
int ForthAllocatedBytes();
void ForthPrintAllocatedBytes();
void ForthPrintLeackCheck();
#else
//void *ForthAlloc( ForthUInteger_t size );
//void ForthFree( void * ptr );
#define ForthAlloc( size ) malloc( size )
#define ForthFree( ptr ) free( ptr )
#define ForthAllocatedBytes()
#define ForthPrintAllocatedBytes()
#define ForthPrintLeackCheck()
#endif

FORTH_ALLOC_C_END

