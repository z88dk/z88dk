
; int isalnum(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC isalnum

EXTERN asm_isalnum, error_zc

isalnum:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_isalnum
   
   ld l,h
   ret c
   
   inc l
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _isalnum
defc _isalnum = isalnum
ENDIF

