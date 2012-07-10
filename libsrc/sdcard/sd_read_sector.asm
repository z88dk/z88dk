;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to dest address for data
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_read_sector.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;

	XLIB	sd_read_sector

	XREF	sd_card_info
	XREF	card_select
	
	LIB		sd_read_sector_main
	LIB		sd_set_sector_addr_regs
	LIB		sd_send_command_current_args
	LIB		sd_wait_data_token
	LIB		sd_deselect_card

    INCLUDE "sdcard.def"
    INCLUDE "osca.def"

sd_read_sector:

	ld	ix,0
	add	ix,sp
	
	ld	l,(ix+8)
	ld	h,(ix+9)	; MMC struct
	;ld	a,(hl)		; current sd_card number
	inc	hl			; ptr to MMC mask to be used to select port
	ld	a,(hl)		; or any other hw dependent reference to current slot
	ld	(card_select), a
	inc hl
	ld	a,(hl)
	ld	(sd_card_info), a
	
	;ld	l,(ix+2)
	;ld	h,(ix+3)	; RAM ptr
	;push hl

	ld	e,(ix+4)	; LSB
	ld	d,(ix+5)	; .
	ld	l,(ix+6)	; .
	ld	h,(ix+7)	; MSB
		
	call sd_set_sector_addr_regs
	

	ld a,CMD17			; Send CMD17 read sector command
	call sd_send_command_current_args
	ld a,sd_error_bad_command_response
	jr nz,read_end		; if ZF set command response is $00	

	call sd_wait_data_token		; wait for the data token
	ld a,sd_error_data_token_timeout
	jr nz,read_end		; ZF set if data token reeceived

	ld	l,(ix+2)
	ld	h,(ix+3)	; RAM ptr
	;ld hl,(sector_buffer_loc)
	call sd_read_sector_main

read_end:
	call sd_deselect_card		; Routines always deselect card on return

;	or a				; If A = 0 on SD routine exit, ZF set on return: No error
	ld h,0
	ld l,a
	ret

