
; Substitute for z80 rld instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_rld
EXTERN __z80asm__rld


defc rcmx_rld = __z80asm__rld
