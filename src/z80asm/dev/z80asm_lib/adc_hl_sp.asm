; Substitute for the z80 adc hl,sp instruction
; CPU   Min T Max T
; 8080  57    62
; 8085  60    63
; gbz80 52    60
; r2ka   4     4
; z180  10    10
; z80   15    15
; z80n  15    15

        SECTION code_l_sccz80
        PUBLIC  __z80asm__adc_hl_sp

__z80asm__adc_hl_sp:
        jr      nc, carry0
        inc     hl
carry0:
        inc     hl                      ; compensate for return address on the stack
        inc     hl

        add     hl, sp
        ret
