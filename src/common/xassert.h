//-----------------------------------------------------------------------------
// assertion that is not removed in a release compile
// Copyright (C) Paulo Custodio, 2011-2026
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#define xassert(f)      ((void)((!!(f)) || xassert_(#f, __FILE__, __LINE__)))

void xassert_init(const char* progname);
int xassert_(const char* expr, const char* file, unsigned line_num);

#ifdef __cplusplus
}
#endif
