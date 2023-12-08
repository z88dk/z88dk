//-----------------------------------------------------------------------------
// show a stack dump on SIGSEGV in Linux
// need to compile with -ggdb and link with -rdynamic
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

extern void dump_stack(void);
extern void dump_stack_on_sigsegv(void);

#ifdef __cplusplus
}
#endif
