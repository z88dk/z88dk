
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_otdr(void *src, uint8_t port, uint8_t num)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_otdr
PUBLIC asm_cpu_otdr

asm_z80_otdr:
asm_cpu_otdr:

   ; enter : hl = void *src
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = void *src_prev (address of byte prior to last written)
   ;
   ; uses  : f, b, hl
   
   otdr
   ret
