
; int stricmp(const char *s1, const char *s2)

PUBLIC stricmp

EXTERN strcasecmp

;defc stricmp = strcasecmp

stricmp:

   jp strcasecmp
