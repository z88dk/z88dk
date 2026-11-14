;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	set HL to dest address for data
;	set B to number of bytes required
;
;	$Id: sd_set_sector_addr_regs.asm,v 1.6 2015-01-19 01:33:07 pauloscustodio Exp $
;
;	HL is the high word. H is the most significant byte.
;	DE is the low word. E is the least significant byte.
;	Carry set requests a byte address. That is the sector times 512.
;	Carry clear stores the words unchanged.
;	Bit 4 of sd_card_info selects block address and skips the shift.
;	The shift keeps 24 bits. The top byte is dropped.
;

    PUBLIC  sd_set_sector_addr_regs

    EXTERN  cmd_generic_args
    EXTERN  sd_card_info

sd_set_sector_addr_regs:
    ld      b, h
    ld      c, e
    ld      e, d
    ld      d, l
    jr      nc, sd_addr_store
    ld      a, (sd_card_info)
    and     $10
    jr      nz, sd_addr_store

; HL must be the low word for the shift. The shuffle left it in E and C.
    ld      h, e
    ld      l, c
    ld      a, d
    add     hl, hl
    adc     a, a
    ld      de, hl
    ld      b, a
    ld      c, 0

sd_addr_store:
    ld      hl, cmd_generic_args
    ld      (hl+), b
    ld      (hl+), d
    ld      (hl+), e
    ld      (hl), c
    ret
