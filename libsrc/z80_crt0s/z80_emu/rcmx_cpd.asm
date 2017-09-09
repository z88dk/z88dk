
; Substitute for z80 cpd instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_cpd
EXTERN __z80asm__cpd

defc rcmx_cpd = __z80asm__cpd
