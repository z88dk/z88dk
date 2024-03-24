//-----------------------------------------------------------------------------
// x88dk file utilities
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

extern char* last_path_char(char* filename);
extern char* zdirname(char* filename);
extern char* zbasename(char* filename);
extern char* remove_ext(char* filename);
extern char* replace_ext(char* filename, const char* ext);
