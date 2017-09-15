; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _index_sdcc
GLOBAL _index
GLOBAL index

defc _index = index

