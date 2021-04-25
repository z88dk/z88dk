
SECTION code_clib

INCLUDE "target/msx/def/msxdos2.def"

PUBLIC  unsetenv
PUBLIC  _unsetenv


EXTERN  MSXDOS
EXTERN  msxdos_error

unsetenv:
_unsetenv:
   pop bc
   pop hl
   push hl
   push bc
   ld de,0 ; Set value string to 0
   ld c,_SENV
   call MSXDOS
   ld  hl,0
   ld  (msxdos_error),a
   and  a
   ret  z
   dec  hl
   ret
   
