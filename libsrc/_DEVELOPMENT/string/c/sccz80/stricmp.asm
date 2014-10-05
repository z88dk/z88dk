
; int stricmp(const char *s1, const char *s2)

SECTION seg_code_string

PUBLIC stricmp

EXTERN strcasecmp

defc stricmp = strcasecmp
