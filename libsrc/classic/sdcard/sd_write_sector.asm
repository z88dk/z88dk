;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	int sd_write_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible,
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_write_sector.asm,v 1.6 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_write_sector
    PUBLIC  _sd_write_sector

    EXTERN  asm_sd_write_sector
    EXTERN  sd_c_return_hl

sd_write_sector:
_sd_write_sector:
    defc    SD_WANT_COUNT = 0
    INCLUDE "sd_keep_sector.inc"
    call    asm_sd_write_sector
    jr      z, sd_wr_caller_ok
    ld      l, a
    ld      h, 0
    jp      sd_c_return_hl

sd_wr_caller_ok:
    ld      hl, 0
    jp      sd_c_return_hl
