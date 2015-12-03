
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_indr(void *dst, uint16_t port)
;
; Read sequence of bytes from port and store at address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_indr

asm_z80_indr:

   ; enter : hl = void *dst
   ;         bc = port
   ;
   ; exit  : hl = void *dst_prev (address prior to last byte written)
   ;
   ; uses  : f, b, hl
   
   indr
   ret
