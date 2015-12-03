
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_inir(void *dst, uint16_t port)
;
; Read sequence of bytes from port and store at address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_inir

asm_z80_inir:

   ; enter : hl = void *dst
   ;         bc = port
   ;
   ; exit  : hl = void *dst_nxt (address following last byte written)
   ;
   ; uses  : f, b, hl
   
   inir
   ret
