//-----------------------------------------------------------------------------
// string pool
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

extern const char* spool_add(const char* str);
extern const char* spool_add_n(const char* str, size_t n);

#ifdef __cplusplus
}
#endif
