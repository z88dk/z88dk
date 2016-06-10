; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Alessandro Poppi
;	ported to z88dk by Stefano Bodrato - Mar 2010
;
;	$Id: mmc_read_multidata.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
;	extern int __LIB__ mmc_read_multidata(struct MMC mmc_descriptor, long card_address, unsigned char *address, int block_count);
;
;-----------------------------------------------------------------------------------------
; READ MULTIPLE BLOCK OF DATA subroutine
;
; This routine only works for blocksize = 512 (two INI sequence).
;
; HL, DE= MSB, LSB of 32bit address in MMC memory
; B     = number of 512 bytes blocks to be read
; IX    = ram buffer address
;
; RETURN code in A:
; 0 = OK
; 1 = read_block command error
; 2 = no wait_data token from MMC
;
; DESTROYS AF, B
;-----------------------------------------------------------------------------------------
;

	SECTION  code_clib
	PUBLIC   mmc_read_multidata
	PUBLIC   _mmc_read_multidata

	EXTERN    mmc_write_command
	EXTERN    mmc_send_command
	EXTERN    mmc_waitdata_token
	EXTERN    mmc_wait_response
	EXTERN    clock32
	EXTERN    cs_high

	EXTERN   __mmc_card_select

	INCLUDE "zxmmc.def"

	defc USE_INI = 1	; 1 = code unrolling for maximum SD-CARD SPI port throughput
						; 0 = slower but a little smaller

	
tmp_reg:	defs	7


mmc_read_multidata:
_mmc_read_multidata:

	ld	ix,2
	add	ix,sp
	
	ld	l,(ix+8)
	ld	h,(ix+9)	; MMC struct
	ld	a,(hl)
	inc	hl			; ptr to MMC mask to be used to select port
	ld	a,(hl)
	ld	(__mmc_card_select), a
	
	ld	b,(ix+0)	; block count
	ld	l,(ix+2)
	ld	h,(ix+3)	; RAM ptr
	push hl
	ld	e,(ix+4)	; LSB
	ld	d,(ix+5)	; .
	ld	l,(ix+6)	; .
	ld	h,(ix+7)	; MSB
	pop ix
	

        ld (tmp_reg),bc                 ; temporary parameter's saveplace for retry function
        ld (tmp_reg+2),de
        ld (tmp_reg+4),hl
        ld a,5                          ; # of retries
        ld (tmp_reg+6),a
        jr readtry_again

read_bsod:
        ld a,MCC_TERMINATE_MULTI_READ
        call mmc_write_command
        call cs_high                    ; set cs high
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles
        ld bc,(tmp_reg)
        ld de,(tmp_reg+2)
        ld hl,(tmp_reg+4)
        ld a,(tmp_reg+6)
        dec a
        ld (tmp_reg+6),a
        and a
        jr nz,readtry_again
        ;ld a,2                          ; no data token from MMC
        ;ld hl,(tmp_reg+4)               ; HL should be restored. DE was not modified.
		ld hl,2
        ret

readtry_again:
        ld a,MMC_READ_MULTIPLE_BLOCK    ; Command code for multiple block read
        call mmc_send_command
        and a
		jr z,noerror
        ld l,a                          ; ERROR
		ld h,0
		ret
noerror:

        push ix
        pop hl                          ; INI uses HL as pointer

jrhere:
        call mmc_waitdata_token
        cp $FE
        jr nz,read_bsod                 ; error

read_mmc_multiblock:
        push bc
        ld bc,SPI_PORT                  ; B = 0 = 256 bytes for the first INI; C = I/O port

        IF USE_INI = 0
        inir
        nop
        inir
        ENDIF

        IF USE_INI = 1
ini_loop1:
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        jr nz,ini_loop1
ini_loop2:
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        ini
        jr nz,ini_loop2
        ENDIF

        nop
        nop

        in a,(SPI_PORT)                 ; CRC
        nop
        nop
        in a,(SPI_PORT)                 ; CRC

        pop bc
        djnz jrhere

        ld a,MCC_TERMINATE_MULTI_READ
        call mmc_write_command

        in a,(SPI_PORT)                 ; CRC?
        nop
        nop
        in a,(SPI_PORT)

        call mmc_wait_response          ; waits for the MMC to reply "0"
        ld b,a                          ; error code

        call cs_high                    ; set cs high
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles
        call clock32                    ; 32 more clock cycles

        ;ld hl,(tmp_reg+4)               ; HL should be restored. DE was not modified.
        ;ld a,b
		ld l,b							; error code
		ld h,0

        ret
