
; Substitute for z80 cpdr instruction
; aralbrec 02.2008
; flag-perfect emulation of cpdr

SECTION code_crt0_sccz80
PUBLIC rcmx_cpdr
EXTERN __z80asm__cpdr


defc rcmx_cpdr = __z80asm__cpdr
