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
;	$Id: sd_read_sector.asm,v 1.7 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_read_sector
    PUBLIC  _sd_read_sector

    EXTERN  sd_read_sector_callee

sd_read_sector:
_sd_read_sector:
    jp      sd_read_sector_callee
