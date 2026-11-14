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
;	$Id: sd_write_block_2gb.asm,v 1.5 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_write_block_2gb
    PUBLIC  _sd_write_block_2gb

    EXTERN  sd_write_block_2gb_callee

sd_write_block_2gb:
_sd_write_block_2gb:
    jp      sd_write_block_2gb_callee
