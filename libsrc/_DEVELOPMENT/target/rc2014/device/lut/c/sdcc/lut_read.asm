SECTION code_driver

PUBLIC _lut_read

EXTERN asm_lut_read

;------------------------------------------------------------------------------
; Routines that talk to the LUT Module
;
; extern uint16_t lut_read(uint16_t location) __preserves_regs(d,e,yh,iyl);
;
;------------------------------------------------------------------------------
;
; entry : hl = 16-bit linear address or 8-bit x 8-bit table address
; exit  : hl = 16-bit result
;
; uses  : bc

._lut_read

    pop af
    pop hl
    push hl
    push af
    jp asm_lut_read
