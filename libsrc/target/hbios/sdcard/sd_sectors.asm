;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	unsigned long sd_sectors(struct SD_INFO *descriptor)
;	Ask RomWBW for the block count. L is the low byte.
;

    SECTION code_clib
    SECTION code_arch

    PUBLIC  sd_sectors
    PUBLIC  _sd_sectors

    EXTERN  asm_hbios
    EXTERN  sd_hbios_unit

    defc    HB_DIOCAP = $1a

sd_sectors:
_sd_sectors:
    ld      a, (hl)
    ld      (sd_hbios_unit), a
    ld      c, a
    ld      b, HB_DIOCAP
    ld      de, 0
    ld      hl, 0
    call    asm_hbios
    or      a
    ret     z
    ld      de, 0
    ld      hl, 0
    ret
