
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_inir(void *dst, uint8_t port, uint8_t num)
;
; Read sequence of bytes from port and store at address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_inir
PUBLIC asm_cpu_inir

asm_z80_inir:
asm_cpu_inir:

   ; enter : hl = void *dst
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = void *dst_nxt (address following last byte written)
   ;
   ; uses  : f, b, hl
   
   inir
   ret
