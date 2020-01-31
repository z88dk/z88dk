SECTION code_driver

PUBLIC lut_read

EXTERN asm_lut_read

;------------------------------------------------------------------------------
; Routines that talk to the LUT Module
;
; uint16_t __LIB__ lut_read(uint16_t location) __smallc __z88dk_fastcall;
;
;------------------------------------------------------------------------------
;
; entry : hl = 16-bit linear address or 8-bit x 8-bit table address
; exit  : hl = 16-bit result
;
; uses  : bc

defc lut_read = asm_lut_read
