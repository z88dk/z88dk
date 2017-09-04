
; Substitute for z80 rrd instruction
; aralbrec 06.2007

SECTION code_crt0_sccz80
PUBLIC rcmx_rrd
EXTERN __z80asm__rrd


defc rcmx_rrd = __z80asm__rrd
