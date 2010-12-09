//
//  ForthStack.h
//  ForthTest1
//
//  Created by narumij on 10/12/04.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthCell.h"

#ifdef __cplusplus
#define FORTH_STACK_C_BEGIN extern "C" {
#define FORTH_STACK_C_END }
#else
#define FORTH_STACK_C_BEGIN
#define FORTH_STACK_C_END
#endif

FORTH_STACK_C_BEGIN

struct ForthStack;
typedef struct ForthStack *ForthStackRef;

ForthStackRef ForthStackCreate();
void ForthStackDelete( ForthStackRef );

int ForthStackGetStackCount( ForthStackRef );
void ForthStackDump( ForthStackRef );
void ForthStackPrint( ForthStackRef );

bool ForthStackPushCell( ForthStackRef s, ForthCell *cell );
bool ForthStackDrop( ForthStackRef );
ForthCell *ForthStackCellAt( ForthStackRef s, int index );

bool ForthStackIsEmpty( ForthStackRef );

#pragma mark convinient

bool ForthStackPushFloat( ForthStackRef, float f );
bool ForthStackPushFloatv( ForthStackRef s, ForthValueType_t type, float *v );
bool ForthStackPushInt( ForthStackRef, ForthInteger_t i );

bool ForthStackPushString( ForthStackRef, const char * );

ForthInteger_t ForthStackGetInt( ForthStackRef, int stack_index, int num_index );
float ForthStackGetFloat( ForthStackRef, int stack_index, int num_index );
const char *ForthStackGetString( ForthStackRef, int stack_index );
bool ForthStackGetBool( ForthStackRef s, int stack_index );

FORTH_STACK_C_END


