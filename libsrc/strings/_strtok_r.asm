; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

MODULE _strtok_r_sdcc
GLOBAL _strtok_r
GLOBAL strtok_r

defc _strtok_r = strtok_r

