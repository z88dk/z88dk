
; int ispunct(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC ispunct

EXTERN asm_ispunct, error_zc

ispunct:

   inc h
   dec h
   jp nz, error_zc

   ld a,l
   call asm_ispunct
   
   ld l,h
   ret c
   
   inc l
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ispunct
defc _ispunct = ispunct
ENDIF

