;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;	Modified November 2026 feilipu.
;
;	Init SD card communications
;	Input: HL = card slot number
;
;	$Id: sd_initialize.asm,v 1.8 2017-01-03 00:27:43 aralbrec Exp $
;

    PUBLIC  sd_initialize
    PUBLIC  _sd_initialize

    EXTERN  sd_init_main
    EXTERN  sd_power_off
    EXTERN  sd_spi_port_fast
    EXTERN  sd_deselect_card

sd_initialize:
_sd_initialize:
    ld      a, l
    call    sd_init_main
    or      a                           ; if non-zero returned in A, there was an error
    jr      z, sd_inok
    call    sd_power_off                ; if init failed shut down the SPI port
    ld      hl, -1
    or      a
    ret

sd_inok:
    call    sd_spi_port_fast            ; on initializtion success -  switch to fast clock

;	call sd_read_cid			; and read CID/CSD
;	jr nz,sd_done
;	push hl				; cache the location of the ID string
;	call sd_read_csd
;	pop hl

sd_done:
    call    sd_deselect_card            ; Routines always deselect card on return
    xor     a
    ld      hl, 0
    ret
