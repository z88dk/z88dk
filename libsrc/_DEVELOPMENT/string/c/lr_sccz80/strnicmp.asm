
; int strnicmp(const char *s1, const char *s2, size_t n)

PUBLIC strnicmp

EXTERN strncasecmp

;defc strnicmp = strncasecmp

strnicmp:

   jp strncasecmp
