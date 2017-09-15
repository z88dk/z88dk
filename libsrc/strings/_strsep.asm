; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

MODULE _strsep_sdcc
GLOBAL _strsep
GLOBAL strsep

defc _strsep = strsep

