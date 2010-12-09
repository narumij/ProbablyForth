//
//  ForthWord.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthCell.h"
#import "ForthThread.h"

#ifdef __cplusplus
#define FORTH_WORD_C_BEGIN extern "C" {
#define FORTH_WORD_C_END }
#else
#define FORTH_WORD_C_BEGIN
#define FORTH_WORD_C_END
#endif

FORTH_WORD_C_BEGIN

struct ForthWord;
typedef struct ForthWord *ForthWordRef;

ForthWordRef ForthWordCreate();
void ForthWordDelete( ForthWordRef );
const char* ForthWordGetCString( ForthWordRef );

void ForthWordSetPrev( ForthWordRef, ForthWordRef );
void ForthWordSetName( ForthWordRef, const char *name );
void ForthWordSetImmediate( ForthWordRef, bool );
void ForthWordSetFunction( ForthWordRef, bool );
void ForthWordSetNaked( ForthWordRef, bool );

bool ForthWordGetImmediate( ForthWordRef w );
bool ForthWordGetFunction( ForthWordRef w );
bool ForthWordGetNaked( ForthWordRef w );

ForthCell *ForthWordGetLast( ForthWordRef );

ForthWordRef ForthWordLookup( ForthWordRef, const char *name );

ForthThreadRef ForthWordGetThread( ForthWordRef );
void ForthWordSetThread( ForthWordRef, ForthThreadRef thread );

void ForthWordPrint( ForthWordRef );
void ForthWordDump( ForthWordRef );

//void ForthWordCompileIn( ForthWordRef, ForthCell *cell );

FORTH_WORD_C_END

