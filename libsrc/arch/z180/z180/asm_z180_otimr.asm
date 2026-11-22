; ===============================================================
; Apr 2017
; ===============================================================
;
; void *z180_otimr(void *src, uint8_t port, uint8_t num)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_otimr
PUBLIC asm_cpu_otimr

asm_z180_otimr:
asm_cpu_otimr:

   ; enter : hl = void *src
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = hl = void *src_nxt (address of byte after last written)
   ;          c = port_nxt
   ;
   ; uses  : f, bc, hl
   
   otimr
   ret
