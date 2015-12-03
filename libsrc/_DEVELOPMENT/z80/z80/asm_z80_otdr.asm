
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_otdr(void *src, uint16_t port)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_otdr

asm_z80_otdr:

   ; enter : bc = port
   ;         hl = void *src
   ;
   ; exit  : hl = void *src_prev (address of byte prior to last written)
   ;
   ; uses  : f, b, hl
   
   otdr
   ret
