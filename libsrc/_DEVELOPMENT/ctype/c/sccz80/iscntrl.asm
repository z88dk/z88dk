
; int iscntrl(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC iscntrl

EXTERN asm_iscntrl, error_znc

iscntrl:

   inc h
   dec h
   jp nz, error_znc

   ld a,l
   call asm_iscntrl
   
   ld l,h
   ret nc
   
   inc l
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _iscntrl
defc _iscntrl = iscntrl
ENDIF

