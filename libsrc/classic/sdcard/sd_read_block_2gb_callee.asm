;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	int sd_read_sector(struct SD_INFO descriptor, long sector, unsigned char *address);
;
;	sd_card_info and card_select must be accessible,
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_read_block_2gb_callee.asm,v 1.5 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_read_block_2gb_callee
    PUBLIC  _sd_read_block_2gb_callee
    PUBLIC  asm_sd_read_block_2gb

    EXTERN  asm_sd_read_lba
    EXTERN  sd_card_info
    EXTERN  sd_c_return_hl

    INCLUDE "sdcard.def"

sd_read_block_2gb_callee:
_sd_read_block_2gb_callee:
    defc    SD_WANT_COUNT = 0
    INCLUDE "sd_pop_sector.inc"
    call    asm_sd_read_block_2gb
    jr      z, sd_rb_ok
    ld      l, a
    ld      h, 0
    jp      sd_c_return_hl

sd_rb_ok:
    ld      hl, 0
    jp      sd_c_return_hl

asm_sd_read_block_2gb:
    ld      a, (sd_card_info)
    and     $10
    jr      z, sd_rb_go
    ld      a, sd_error_too_big
    or      a
    ret

sd_rb_go:
    or      a
    jp      asm_sd_read_lba
