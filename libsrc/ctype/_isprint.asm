; int isprint(int c)

SECTION code_clib
SECTION code_string

MODULE _isprint_sdcc
GLOBAL _isprint
GLOBAL isprint

defc _isprint = isprint

