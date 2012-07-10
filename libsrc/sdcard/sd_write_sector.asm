;
;	Old School Computer Architecture - SD Card driver
;	Taken from the OSCA Bootcode by Phil Ruston 2011
;	Port by Stefano Bodrato, 2012
;
;	set HL to src address for data
;
;	sd_card_info and card_select must be accessible, 
;	a good place to put them is in the vars declared in the CRT0 stub
;
;	on exit: 0 if all OK or error code
;
;	$Id: sd_write_sector.asm,v 1.1 2012-07-10 05:55:38 stefano Exp $
;

	XLIB	sd_write_sector

	XREF	sd_card_info
	XREF	card_select

	LIB		sd_write_sector_main
	LIB		sd_deselect_card
	LIB		sd_set_sector_addr_regs
	LIB		sd_send_command_current_args
	LIB		sd_send_eight_clocks
	LIB		sd_send_byte
	LIB		sd_get_byte

    INCLUDE "sdcard.def"

sd_write_sector:

	
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

	ld a,CMD24			; Send CMD24 write sector command
	call sd_send_command_current_args		
	ld a,sd_error_bad_command_response
	jr nz, write_end
	
	call sd_send_eight_clocks		; wait 8 clocks before proceding	

	ld a,$fe
	call sd_send_byte			; send $FE = packet header code

;..............................................................................................	

	ld	l,(ix+2)
	ld	h,(ix+3)	; RAM ptr
	;ld hl,(sector_buffer_loc)
	call sd_write_sector_main

;.............................................................................................	

	call sd_get_byte			; get packet response
	and $1f
	srl a
	cp $02
	jr z,sd_wr_ok

sd_write_fail:
	ld a,sd_error_write_failed
	jr write_end

sd_wr_ok:
	ld bc,65535			; read bytes until $ff is received
sd_wcbsy:
	call sd_get_byte			; until that time, card is busy
	cp $ff
	jr nz,sd_busy
	xor a				; A = 0, all OK
	jr write_end
	
sd_busy:
	dec bc
	ld a,b
	or c
	jr nz,sd_wcbsy

sd_card_busy_timeout:
	ld a,sd_error_write_timeout

write_end:
	call sd_deselect_card		; Routines always deselect card on return

;	or a				; If A = 0 on SD routine exit, ZF set on return: No error
	ld h,0
	ld l,a
	ret





