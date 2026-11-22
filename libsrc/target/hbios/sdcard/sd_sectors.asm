;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	unsigned long sd_sectors(struct SD_INFO *descriptor)
;	RomWBW DIOCAP returns DE:HL as the block count and BC as the block size.
;	A size other than 512 returns 0. Mini-FAT moves 512-byte sectors.
;	L of the descriptor is the unit.
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
    jr      nz, sd_sec_none
    ld      a, c                        ; 512 is BC = $0200
    or      a
    jr      nz, sd_sec_none
    ld      a, b
    cp      2
    ret     z
sd_sec_none:
    ld      de, 0
    ld      hl, 0
    ret
