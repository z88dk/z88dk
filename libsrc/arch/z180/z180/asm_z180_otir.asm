
; ===============================================================
; Nov 2014
; ===============================================================
;
; void *z180_otir(void *src, uint8_t port, uint8_t num)
;
; Write sequence of bytes at address src to port.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_z180

PUBLIC asm_z180_otir
PUBLIC asm_cpu_otir

IF (__CLIB_OPT_UNROLL & 0x10)

EXTERN l_outi_loop
defc   asm_z180_otir = l_outi_loop
defc   asm_cpu_otir = l_outi_loop

ELSE

asm_z180_otir:
asm_cpu_otir:

   ; enter : hl = void *src
   ;          c = port
   ;          b = num
   ;
   ; exit  : hl = void *src_nxt (address of byte after last written)
   ;
   ; uses  : f, b, hl
   
   otir
   ret

ENDIF
