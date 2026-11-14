;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	int sd_write_sectors(struct SD_INFO descriptor, long sector,
;	                     unsigned char *address, unsigned int count);
;
;	on exit: 0 if all OK or error code
;

    PUBLIC  sd_write_sectors
    PUBLIC  _sd_write_sectors

    EXTERN  sd_write_sectors_body

sd_write_sectors:
_sd_write_sectors:
    defc    SD_WANT_COUNT = 1
    INCLUDE "sd_keep_sector.inc"
    jp      sd_write_sectors_body
