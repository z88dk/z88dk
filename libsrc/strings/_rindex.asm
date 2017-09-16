; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _rindex_sdcc
GLOBAL _rindex
GLOBAL rindex

defc _rindex = rindex

