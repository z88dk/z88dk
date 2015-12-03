
; int stricmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC stricmp

EXTERN strcasecmp

defc stricmp = strcasecmp
