
SECTION code_clib

PUBLIC nabu_set_interrupts
PUBLIC _nabu_set_interrupts

INCLUDE "target/nabu/def/nabu.def"

; void nabu_set_interrupts(uint8_t flags) __z88dk_fastcall
nabu_set_interrupts:
_nabu_set_interrupts:
    ld      a,0x0e
    out     (IO_AY_LATCH),a
    ld      a,l
    out     (IO_AY_DATA),a
    ret
