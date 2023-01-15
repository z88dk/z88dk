
SECTION code_clib

PUBLIC nabu_get_interrupts
PUBLIC _nabu_get_interrupts

INCLUDE "target/nabu/def/nabu.def"

; uint8_t nabu_set_interrupts(void)
nabu_get_interrupts:
_nabu_get_interrupts:
    ld      a,PSG_REG_IO_A
    out     (IO_AY_LATCH),a
    ld      a,l
    in      a,(IO_AY_DATA),a
    ld      l,a
    ld      h,0
    ret
