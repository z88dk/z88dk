;
; Rabbit Control Module bootstrap program
;
; This module is included by rcmx000_crt0.asm
;
; $Id: rcmx000_boot.asm,v 1.6 2016-06-02 22:24:57 dom Exp $
;


; PLEASE NOTE: If you ever change this file, please also review
; the boot.c utility in the support/rcmx000 section cause it makes
; assumptions on where the code lies in memory...


__start_prog:

	ld sp,8000h

	; If boot uses raw (-r) option we will patch this into
	; jp _end_prog. 
	; If we are not in raw option, this will not do anything useful
	ld hl, __end_prog

	jr skip_data_bytes

	; The command byte should be at 8
command:   defb 0

	; N.B: The "end_prog" is the end of this file's program but the
	; beginning of the users stuff

skip_data_bytes:
	; Tell host we have loaded!! Send the 'babe' magic pattern
	ld a,0bah
	call __sendchar
	nop

	ld a,0beh
	call __sendchar
	nop

	; Here we receive the baudrate divisor from host
	call __recvchar
	nop	

	; Save the divisor for later echoing back to host
	ld b,a

	; This character is used for the baudrate divisor,
	; the host must know this in some way, the best is to use 
	; the meassurebaud.asm utility for each new target connected
	; An example: for a CPU @ 14.7456 MHz
	; a divisor of 192 should be used, i.e. the register should
	; be loaded with 192-1 = 191
	;
	; The base frequency is thus 14745600/32 = 460800
	; To be further divided into (460800/2400) = 192 = 8*3*2*2*2
	; To reach 2400 baud
	;
	; N.B. This example may only be true to a factor or divisor of
	; two, since there is some talk in the manuals about internal
	; clockdoublers etc, which might complicate this further!!!
	;
	;
	defb 0d3h ; ioi
	ld (0a9h),a 			; TAT4R baud divisor

	; Receive a character at the new baudrate...
	call __recvchar
	nop
	
	call __sendchar		; Just echo back same char...
	nop

	ld a,b
	call __sendchar		; Here we echo the baudrate number for the
				; host to check that we are still in sync
	nop

	xor 0ffh
	call __sendchar		; Complement just to show signs of intelligence
	nop

	; From this point the target first accepts two characters
	; to represent the length of the rest of the download, then the
	; download itself and finally a 16 bit checksum of all numbers 
	; added together 8-bit wise

	call __recvchar	
	nop
	ld c,a

	call __recvchar
	nop
	ld b,a


	ld ix,0				; We will reload whole program and
					; even pass over this code on the way

	; Checksum is stored here
	ld iy,0

	ld d,0
	ld e,c			; Add length bytes to checksum
	add iy,de
	ld e,b
	add iy,de
	
again:
	call __recvchar
	nop
	ld e,a

	add iy,de
	ld (ix+0),e
	dec bc
	ld a,b
	or c
	inc ix
	jr nz,again

	push iy
	pop bc
	ld a,c
	call __sendchar
	nop
	
	ld a,b
	call __sendchar
	nop

	call __end_prog 	; This will jump to main
	jp 0

__recvchar:
	defb 0d3h ; ioi
	ld a,(0c3h)		; SASR  Serial status
	bit 7,a
	jr z,__recvchar
	defb 0d3h ; ioi
	ld a,(0c0h)		; SADR  Serial data read
	ret

__sendchar:
	push hl
	ld hl,0c3h
__waitready:
	defb 0d3h ; ioi
	bit 3,(hl)		; SASR, Serial status, bit 3
	jr nz,__waitready
	defb 0d3h ; ioi
	ld (0c0h),a		; SADR Serial data write (checksum)
	pop hl
	ret
	
	; This is the I/O operations necessary to set the system in a decent mode, such
	; as asserting that there is RAM at address zero before downloading the code at
	; org 0h mk_boot_code actually uses assembler symbol table to locate "prefix" 
	; and "postfix"
	; 
	; The coldboot utility need to transfer the binary file
	; up until this point, from address 0 and on
	; Remember, a program starts with the crt0 file,
	; which then includes this file!!

__endbootstrap:
	
__prefix:

	defb 080h, 000h, 008h			; GCSR Clock select, bit 4-2: 010 (osc)
	defb 080h, 009h, 051h			; Watchdog
	defb 080h, 009h, 054h


	defb 080h, 010h, 000h			; MMU            MMIDR
	defb 080h, 014h, 045h			; Memory bank    MB0CR
	defb 080h, 015h, 045h			; Memory bank    MB1CR
	defb 080h, 016h, 040h			; Memory bank    MB2CR
	defb 080h, 017h, 040h			; Memory bank    MB3CR
	defb 080h, 013h, 0c8h			; MMU            SEGSIZE
	defb 080h, 011h, 074h			; MMU            STACKSEG
	defb 080h, 012h, 03ah			; MMU            DATASEG



	defb 080h
	defb 0a9h
	; Below the bootstrap utility should patch the correct divisor for
	; a 2400 Baud operation in non-cold boot mode,
	; If the host hardware supports on-the-fly baudrate changes
	; we set them at a later point in the bootstrap code
	; obtained via meassurebaud.c, we have it set here to an insane value
	; so this it not forgotten...
__patch_baudrate:
	defb 42					; TAT4R <= baud divisor

	defb 080h, 0a0h, 001h			; TACSR <= 1

	defb 080h, 0c4h, 000h			; SACR <= 0
	defb 080h, 009h, 051h			; WDTTR <= 51h
	defb 080h, 009h, 054h			; WDTTR <= 54h
	defb 080h, 055h, 040h			; PCFR <= 40h


	;; This is the standard final I/O operation that kick starts the Rabbit from address zero in RAM
__postfix:
	defb 080h, 024h, 080h			; SPCR <= 80h

__end_prog:

	; Here we put some utils for flashing and start from flash
	; We do not want them in the 2400 baud loader since we dont need
	; them for the baudrate change so we put them here instead


	; TODO: Here we should include and "ifdef" so
	; we dont download this part when doing raw mode
	; (raw mode is slow @2400 bps and 3 bytes per byte :-)

	;; 
IF !DEFINED_NOFLASH
	INCLUDE	"rcmx000_flash.asm"
ENDIF
