
; int isascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isascii

EXTERN error_znc

isascii:

   inc h
   dec h
   jp nz, error_znc

IF __CPU_8080__
   ld a,l
   rla
   ld l,h
   ret c
ELSE
   bit 7,l
   
   ld l,h
   ret nz
ENDIF

   inc l
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _isascii
defc _isascii = isascii
ENDIF

