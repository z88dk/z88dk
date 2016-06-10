; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Mar 2010
;
;	$Id: mmc_read_block.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
; Read a 512 byte data block from the MMC card
; extern int __LIB__ mmc_read_block(struct MMC mmc_descriptor, long card_address, unsigned char *address);
;
;-----------------------------------------------------------------------------------------
; READ A SINGLE BLOCK OF DATA subroutine
;
; This routine only works for blocksize = 512 (two INIR sequence).
;
; HL, DE= MSB, LSB of 32bit address in MMC memory
; then, HL = ram buffer address
;
; RETURN code in HL:
; 0 = OK
; 1 = read_block command error
; 2 = no wait_data token from MMC
;
; DESTROYS AF, HL
;-----------------------------------------------------------------------------------------

	SECTION	 code_clib
	PUBLIC   mmc_read_block
	PUBLIC   _mmc_read_block
	
	EXTERN    mmc_send_command
	EXTERN    mmc_waitdata_token
	EXTERN    clock32
	EXTERN    cs_high

	EXTERN   __mmc_card_select

	INCLUDE "zxmmc.def"


mmc_read_block:
_mmc_read_block:

	ld	ix,0
	add	ix,sp
	
	ld	l,(ix+8)
	ld	h,(ix+9)	; MMC struct
	ld	a,(hl)
	inc	hl			; ptr to MMC mask to be used to select port
	ld	a,(hl)
	ld	(__mmc_card_select), a
	
	ld	l,(ix+2)
	ld	h,(ix+3)	; RAM ptr
	push hl
	ld	e,(ix+4)	; LSB
	ld	d,(ix+5)	; .
	ld	l,(ix+6)	; .
	ld	h,(ix+7)	; MSB

        ld a,MMC_READ_SINGLE_BLOCK      ; Command code for block read
        call mmc_send_command
        and a
		jr	z,noerror
        ld	l,a
		ld	h,0
noerror:
        call mmc_waitdata_token
        cp $FE
        jr z,read_mmc_block             ; OK
		pop hl
        ld hl,2                          ; no data token from MMC
        ret

read_mmc_block:
        pop hl                          ; HL = INIR write pointer

        ld bc,SPI_PORT                  ; B = 0 = 256 bytes for the first INIR; C = I/O port

        inir
        nop
        inir

        nop
        nop

        in a,(SPI_PORT)                 ; CRC
        nop
        nop
        in a,(SPI_PORT)                 ; CRC

        call cs_high                    ; set cs high
        call clock32                    ; 32 more clock cycles

        ld	hl,0
        ret
