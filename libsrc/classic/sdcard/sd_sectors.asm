;
;
;	ZX Spectrum ZXMMC specific routines
;	code by Stefano Bodrato,   Mar 2010
;	Modified November 2026 feilipu.
;
;	$Id: sd_sectors.asm,v 1.3 2017-01-03 00:27:43 aralbrec Exp $
;
; Get the size in sectors of an MMC/SD card
; unsigned long sd_size(struct SD_INFO descriptor);

; Offset in bytes for the CSD field in the MMC struct.
; 1 (slot number) + 1 (slot port) + 1 (flags) + 16 (CID) = 19

    defc    CSD_OFFSET = 19

;
;	Original code:
;
;	int	c_size;
;	int c_size_mult;
;	int block_len;
;
;	c_size = ((mmc->CSD[6]&3)<<10) + (mmc->CSD[7]<<2) + (mmc->CSD[8]>>6);
;	c_size_mult = 1<<(((mmc->CSD[9]&3)<<1) + (mmc->CSD[10]>>7));
;	block_len = 1 << ((mmc->CSD[5]&15)-8);
;
;	if (c_size == 0xFFF)  return (unsigned long)0;
;
;	return ( (unsigned long)++c_size * (unsigned long)c_size_mult * (unsigned long)block_len );
;

    PUBLIC  sd_sectors
    PUBLIC  _sd_sectors
    PUBLIC  asm_sd_csd_sectors

sd_sectors:
_sd_sectors:
    ld      de, CSD_OFFSET
    add     hl, de
    jp      asm_sd_csd_sectors

; HL points at CSD[0]. Result is a sector count in DEHL. L is the low byte.

asm_sd_csd_sectors:
    push    hl
    ld      a, (hl)
    and     $40
    jp      z, sd_csd_v1

    ld      de, 7
    add     hl, de
    ld      a, (hl+)
    and     63
    ld      b, a
    ld      a, (hl+)
    ld      e, a
    ld      a, (hl)
    ld      l, a
    ld      h, e
    ld      e, b
    ld      d, 0
    ld      a, l
    add     a, 1
    ld      l, a
    ld      a, h
    adc     a, 0
    ld      h, a
    ld      a, e
    adc     a, 0
    ld      e, a
    ld      a, d
    adc     a, 0
    jp      c, sd_csd_pop0
    ld      d, a
    ld      b, 10
sd_csd2sh:
    add     hl, hl
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    jp      c, sd_csd_pop0
    ld      d, a
    djnz    sd_csd2sh
    pop     bc
    ret

sd_csd_v1:
    ld      de, 5
    add     hl, de
    ld      a, (hl+)
    and     15
    ld      b, a
    ld      a, (hl+)
    and     3
    ld      d, a
    ld      e, (hl)
    inc     hl
    ld      a, (hl)
    and     $c0
    rlca
    ld      c, a
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    ld      d, a
    ld      a, c
    rlca
    ld      c, a
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    ld      d, a
    ld      a, d
    cp      $0f
    jr      nz, sd_csd_v1sz
    ld      a, e
    cp      $ff
    jp      z, sd_csd_pop0
sd_csd_v1sz:
    ld      a, e
    add     a, 1
    ld      e, a
    ld      a, d
    adc     a, 0
    jp      c, sd_csd_pop0
    ld      d, a
    inc     hl
    ld      a, (hl+)
    and     3
    add     a, a
    ld      c, a
    ld      a, (hl)
    rlca
    ld      a, c
    adc     a, 0
    add     a, b
    sub     7
    ld      hl, de
    ld      de, 0
    jr      c, sd_csd_right
    ld      b, a
    or      a
    jr      z, sd_csd_done
sd_csd_left:
    add     hl, hl
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    jp      c, sd_csd_pop0
    ld      d, a
    djnz    sd_csd_left
    jr      sd_csd_done

sd_csd_right:
    ld      b, a
    ld      a, 0
    sub     b
    ld      b, a
sd_csd_rsh:
    ld      a, h
    or      a
    rra
    ld      h, a
    ld      a, l
    rra
    ld      l, a
    djnz    sd_csd_rsh

sd_csd_done:
    pop     bc
    ret

sd_csd_pop0:
    pop     bc
    ld      de, 0
    ld      hl, 0
    ret
