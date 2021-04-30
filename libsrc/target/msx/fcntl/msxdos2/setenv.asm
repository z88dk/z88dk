
SECTION code_clib

INCLUDE "target/msx/def/msxdos2.def"

PUBLIC  setenv
PUBLIC  _setenv


EXTERN  MSXDOS
EXTERN  msxdos_error

setenv:
_setenv:
   pop af  ;ret
   pop bc  ;overwrite flag
   pop de ; value
   pop hl ; arg
   push hl
   push de
   push bc
   push bc
   ld c,_SENV
   call MSXDOS
   ld  hl,0
   ld  (msxdos_error),a
   and  a
   ret  z
   dec  hl
   ret
   
