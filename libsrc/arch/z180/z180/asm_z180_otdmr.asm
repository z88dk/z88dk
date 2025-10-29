; ===============================================================
; Apr 2017
; ===============================================================
;
; void *z180_otdmr(void *src, uint8_t port, uint8_t num)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_otdmr
PUBLIC asm_cpu_otdmr

asm_z180_otdmr:
asm_cpu_otdmr:

   ; enter : hl = void *src
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = void *src_prev (address of byte prior to last written)
   ;          c = port_prev
   ;
   ; uses  : f, bc, hl
   
   otdmr
   ret
