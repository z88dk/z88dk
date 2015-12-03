
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z80_otir(void *src, uint16_t port)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_otir

asm_z80_otir:

   ; enter : bc = port
   ;         hl = void *src
   ;
   ; exit  : hl = void *src_nxt (address of byte after last written)
   ;
   ; uses  : f, b, hl
   
   otir
   ret
