;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	int sd_read_sectors(struct SD_INFO descriptor, long sector,
;	                    unsigned char *address, unsigned int count);
;
;	on exit: 0 if all OK or error code
;

    PUBLIC  sd_read_sectors
    PUBLIC  _sd_read_sectors

    EXTERN  sd_read_sectors_callee

sd_read_sectors:
_sd_read_sectors:
    jp      sd_read_sectors_callee
