
; Substitute for z80 cpi instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_cpi
EXTERN __z80asm__cpi

defc rcmx_cpi = __z80asm__cpi
