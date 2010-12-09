//
//  ForthInterpreter.h
//  ForthTest1
//
//  Created by narumij on 10/12/05.
//  Copyright 2010 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ForthRegisters.h"


#ifdef __cplusplus
#define FORTH_INTERPRETER_C_BEGIN extern "C" {
#define FORTH_INTERPRETER_C_END }
#else
#define FORTH_INTERPRETER_C_BEGIN
#define FORTH_INTERPRETER_C_END
#endif

FORTH_INTERPRETER_C_BEGIN

bool ForthInnerInterpreter( ForthRegistersRef reg );

struct ForthInterpreterContext;
typedef struct ForthInterpreterContext *ForthInterpreterContextRef;

ForthInterpreterContextRef ForthInterpreterContextCreate();
void ForthInterpreterContextDelete( ForthInterpreterContextRef );

bool ForthInterpreter( ForthRegistersRef reg, ForthInterpreterContextRef ctx, const char *s );


FORTH_INTERPRETER_C_END


