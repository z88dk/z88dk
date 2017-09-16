; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_clib
SECTION code_string

MODULE _strsep_callee_sdcc
GLOBAL _strsep_callee
GLOBAL strsep_callee

defc _strsep_callee = strsep_callee

