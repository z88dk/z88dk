; int isspace(int c)

SECTION code_clib
SECTION code_string

MODULE _isspace_sdcc
GLOBAL _isspace
GLOBAL isspace

defc _isspace = isspace

