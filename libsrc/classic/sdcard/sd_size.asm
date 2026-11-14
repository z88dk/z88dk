;
;
;	ZX Spectrum ZXMMC specific routines
;	code by Stefano Bodrato,   Mar 2010
;	Modified November 2026 feilipu.
;
;	$Id: sd_size.asm,v 1.3 2017-01-03 00:27:43 aralbrec Exp $
;
; Get the size in bytes of an MMC/SD card
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

    PUBLIC  sd_size
    PUBLIC  _sd_size

    EXTERN  sd_sectors

sd_size:
_sd_size:
    call    sd_sectors
    ld      a, d
    or      a
    jr      nz, sd_sz0
    ld      a, e
    cp      $40
    jr      c, sd_sz_fit
    jr      nz, sd_sz0
    ld      a, h
    or      l
    jr      nz, sd_sz0
sd_sz_fit:
;	8080: add hl,hl and rla. djnz is the cheap synthetic. Above 2GB returns 0.
    ld      b, 9
sd_sz_sh:
    add     hl, hl
    ld      a, e
    rla
    ld      e, a
    ld      a, d
    rla
    ld      d, a
    jr      c, sd_sz0
    djnz    sd_sz_sh
    ret

sd_sz0:
    ld      de, 0
    ld      hl, 0
    ret
