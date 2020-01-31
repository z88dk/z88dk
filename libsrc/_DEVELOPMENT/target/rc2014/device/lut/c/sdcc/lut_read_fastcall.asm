SECTION code_driver

PUBLIC _lut_read_fastcall

EXTERN asm_lut_read

;------------------------------------------------------------------------------
; Routines that talk to the LUT Module
;
; extern uint16_t lut_read_fastcall(uint16_t location) __preserves_regs(d,e,iyh,iyl) __z88dk_fastcall;
;
;------------------------------------------------------------------------------
;
; entry : hl = 16-bit linear address or 8-bit x 8-bit table address
; exit  : hl = 16-bit result
;
; uses  : bc

defc _lut_read_fastcall = asm_lut_read
