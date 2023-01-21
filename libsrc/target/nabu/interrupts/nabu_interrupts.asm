
SECTION code_clib

PUBLIC nabu_get_interrupts
PUBLIC _nabu_get_interrupts
PUBLIC nabu_set_interrupts
PUBLIC _nabu_set_interrupts
PUBLIC nabu_enable_interrupt
PUBLIC _nabu_enable_interrupt
PUBLIC nabu_disable_interrupt
PUBLIC _nabu_disable_interrupt

INCLUDE "target/nabu/def/nabu.def"

; uint8_t nabu_set_interrupts(void)
nabu_get_interrupts:
_nabu_get_interrupts:
    ld      hl,(__nabu_interrupt_state)
    ld      h,0
    ret

; void nabu_set_interrupts(uint8_t flags) __z88dk_fastcall
nabu_set_interrupts:
_nabu_set_interrupts:
    ld      a,PSG_REG_IO_A
    out     (IO_AY_LATCH),a
    ld      a,l
    out     (IO_AY_DATA),a
    ld      (__nabu_interrupt_state),a
    ret

; void nabu_enable_interrupt(uint8_t flags) __z88dk_fastcall
nabu_enable_interrupt:
_nabu_enable_interrupt:
    ld      a,(__nabu_interrupt_state)
    or      l
    push    af
    ld      a,PSG_REG_IO_A
    out     (IO_AY_LATCH),a
    pop     af
    out     (IO_AY_DATA),a
    ld      (__nabu_interrupt_state),a
    ret

; void nabu_disable_interrupt(uint8_t flags) __z88dk_fastcall
nabu_disable_interrupt:
_nabu_disable_interrupt:
    ld      a,l
    cpl
    ld      l,a
    ld      a,(__nabu_interrupt_state)
    and     l
    push    af
    ld      a,PSG_REG_IO_A
    out     (IO_AY_LATCH),a
    pop     af
    out     (IO_AY_DATA),a
    ld      (__nabu_interrupt_state),a
    ret



    SECTION bss_clib

__nabu_interrupt_state:
    defb    0