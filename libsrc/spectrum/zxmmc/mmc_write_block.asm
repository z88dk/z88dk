; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Mar 2010
;
;	$Id: mmc_write_block.asm,v 1.1 2010-03-12 15:21:14 stefano Exp $ 
;
; Write a 512 byte data block to the MMC card
; extern int __LIB__ mmc_write_block(struct MMC mmc_descriptor, long card_address, unsigned char *address);
;
;-----------------------------------------------------------------------------------------
; WRITE BLOCK OF DATA subroutine. By now, we don't use the MULTIPLE_BLOCK transfer.
;
; This routine only works for blocksize = 512 (two OUTI sequence).
;
; HL, DE= MSB, LSB of 32bit address in MMC memory
; IX    = ram buffer address
;
; RETURN code in A:
; 0 = OK
; 1 = read_block command error
; 2 = write error (no "5" response from MMC)
;
; Destroys AF, B, DE, HL, IX.
;-----------------------------------------------------------------------------------------
;

	XLIB   mmc_write_block

	LIB    mmc_write_command
	LIB    mmc_write_data
	LIB    mmc_send_command
	LIB    mmc_wait_response
	LIB    clock32
	LIB    cs_high

	XREF   card_select

	INCLUDE "zxmmc.def"

	
mmc_write_block:


	ld	ix,0
	add	ix,sp
	
	ld	l,(ix+8)
	ld	h,(ix+9)	; MMC struct
	ld	a,(hl)
	inc	hl			; ptr to MMC mask to be used to select port
	ld	a,(hl)
	ld	(card_select), a
	
	ld	l,(ix+6)
	ld	h,(ix+7)	; RAM ptr
	push hl
	ld	e,(ix+2)	; LSB
	ld	d,(ix+3)	; .
	ld	l,(ix+4)	; .
	ld	h,(ix+5)	; MSB
	;;pop ix


        ld a,MMC_WRITE_SINGLE_BLOCK     ; Command code for block read
        call mmc_send_command
        and a
		jr	z,noerror
		pop	hl
        ld	h,0
		ld	l,a
		ret
		
noerror:
        ld a,$FE
        out (SPI_PORT),a                ; first byte to be sent = DATA TOKEN

;;;write_mmc_block:
        ;;push bc
        ld bc,SPI_PORT                  ; C = PORT, B = 0 for 256 bytes on first OTIR
        ;push hl
        ;push ix
        ;pop hl
		
		pop	hl

        otir
        nop                             ; without this NOP, the 2nd half of the 512 bytes block would miss some write cycles
        otir                            ; on the CPLD if Z80 runs at 21MHz

        ;push hl
        ;pop ix
        ;pop hl

        ld a,$95                        ; CRC... (!)
        out (SPI_PORT),a
        nop
        nop
        out (SPI_PORT),a

        call mmc_wait_response

        ;;pop bc

        and $1F                         ; masks useful response bits
        cp 5
        ;jr z,write_mmc_block             ; OK
		jr z,wait_busy             ; OK
        ld hl,2                          ; no data token from MMC
        ret

;write_mmc_block:
;        ld a,d                          ; update the pointer with the block to be written
;        add BLOCKSIZE/256               ; 2 if blocksize = 512
;        jr nc,no_overw
;        inc hl
;no_overw:
;        ld d,a

wait_busy:
        call mmc_wait_response          ; MMC will report "00" until busy
        and a
        jr z,wait_busy

        call cs_high
        call clock32                    ; 32 more clock cycles

        ld	hl,0
        ret
