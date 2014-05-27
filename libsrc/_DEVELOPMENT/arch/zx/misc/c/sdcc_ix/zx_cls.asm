
; void zx_cls(uchar attr)

PUBLIC _zx_cls

_zx_cls:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_cls.asm"
