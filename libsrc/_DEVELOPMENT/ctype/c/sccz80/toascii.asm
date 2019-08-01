
; int toascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toascii

toascii:

   ld h,0
IF __CPU_INTEL__
   ld  a,l
   and 127
   ld  l,a
ELSE
   res 7,l
ENDIF
   
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _toascii
defc _toascii = toascii
ENDIF

