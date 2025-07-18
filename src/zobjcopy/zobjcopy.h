//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2025
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include "die.h"
#include "objfile.h"
#include "optparse.h"
#include "strutil.h"
#include "utlist.h"
#include "utstring.h"
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>	// needed before regex.h
#include "regex.h"

#ifdef __cplusplus
}
#endif
