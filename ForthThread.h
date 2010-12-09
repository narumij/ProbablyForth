//
//  ForthThread.h
//  ForthTest1
//
//  Created by narumij on 10/12/05.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthCell.h"

#ifdef __cplusplus
#define FORTH_THREAD_C_BEGIN extern "C" {
#define FORTH_THREAD_C_END }
#else
#define FORTH_THREAD_C_BEGIN
#define FORTH_THREAD_C_END
#endif

FORTH_THREAD_C_BEGIN

struct ForthThread;
//typedef ForthCell * ForthThreadRef;
typedef struct ForthThread *ForthThreadRef;

int ForthThreadCellCount( ForthThreadRef thread );
void ForthThreadDebugPrint( ForthThreadRef thread );

ForthThreadRef ForthThreadCreate();
ForthThreadRef ForthThreadCreateWithSize( int size );
void ForthThreadDelete( ForthThreadRef );


void ForthThreadAddCellStruct( ForthThreadRef, ForthCell );
void ForthThreadAddCell( ForthThreadRef, ForthCell * );
void ForthThreadAddThread( ForthThreadRef, ForthThreadRef );


ForthCell *ForthThreadGetHeadCell( ForthThreadRef );
ForthCell *ForthThreadGetLastCell( ForthThreadRef );

void ForthThreadClear( ForthThreadRef );

void ForthThreadCopyThread( ForthThreadRef *, ForthThreadRef );



FORTH_THREAD_C_END

