//-----------------------------------------------------------------------------
// zobjcopy - manipulate z80asm object files
// Copyright (C) Paulo Custodio, 2011-2018
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include "die.h"
#include "objfile.h"
#include "optparse.h"
#include "utlist.h"
#include "utstring.h"

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct opts_s
{
	bool	verbose;
	bool	list;
} opts_t;

extern opts_t opts;

typedef struct global_s
{
	bool	modified;
} global_t;

extern global_t global;
