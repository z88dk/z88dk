


SECTION code_clib

INCLUDE "target/msx/def/msxdos2.def"

PUBLIC  getenv
PUBLIC  _getenv

EXTERN asm_getenv_r

EXTERN  MSXDOS
EXTERN  msxdos_error

; char *getenv(const char *name);
getenv:
_getenv:
   pop  bc
   pop  hl
   push hl
   pop bc
   ld  de,getenv_buffer
   ld  b,255
   jp  asm_getenv_r

SECTION bss_clib
getenv_buffer:
   defs  256
