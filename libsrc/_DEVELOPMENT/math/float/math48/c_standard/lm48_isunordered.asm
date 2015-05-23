
; int isunordered(real-floating x, real-floating y)

SECTION code_fp_math48

PUBLIC lm48_isunordered

EXTERN error_znc

; doubles are always ordered in this library
;
; return HL = 0 with carry reset (false)

defc lm48_isunordered = error_znc
