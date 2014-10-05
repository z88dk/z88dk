
; int strnicmp(const char *s1, const char *s2, size_t n)

SECTION seg_code_string

PUBLIC strnicmp

EXTERN strncasecmp

defc strnicmp = strncasecmp
