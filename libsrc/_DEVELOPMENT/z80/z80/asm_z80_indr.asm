
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_indr(void *dst, uint8_t port, uint8_t num)
;
; Read sequence of bytes from port and store at address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_indr
PUBLIC asm_cpu_indr

asm_z80_indr:
asm_cpu_indr:

   ; enter : hl = void *dst
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = void *dst_prev (address prior to last byte written)
   ;
   ; uses  : f, b, hl
   
   indr
   ret
