;       CRT0 stub for the Jupiter ACE
;
;       Stefano Bodrato - Feb 2001
;
;	$Id: ace_crt0.asm,v 1.21 2016-06-21 20:49:06 dom Exp $
;


                MODULE  ace_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

         	defc    crt0 = 1
                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

        EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal



;--------
; Set an origin for the application (-zorg=) default to $4000
;--------

        IF      !myzorg
            IF (startup=2)                 ; ROM ?
                defc    myzorg  = 0
            ELSE
                defc    myzorg  = $4000
            ENDIF
        ENDIF


        org     myzorg

start:
IF (startup=2)
		;  ROM mode BOOT
	di
	ld	hl,$3c00	; RAM starts at $4000
	ld	a,$fc
ace_ramtest:
	inc	h			; step to a higher RAM block
	ld	(hl),a		; probe it
	cp	(hl)
	jr	z,ace_ramtest
	and	h
	ld	h,a			; use $fc to mask to the lower 1k boundary
	ld	sp,hl
ELSE
		;  set stack if in RAM mode
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
ENDIF
	call	crt0_init_bss
        ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


IF (startup=2)
	ld    hl,$2c00		; character set RAM
		; init the first 256 bytes with gfx blocks
gfx_bloop:
	ld    a,l
	and   $bf
	rrca
	rrca
	rrca
	jr    nc,nobit2
	rrca
	rrca

nobit2: rrca
	ld   b,a
	sbc  a,a		; 0 or $FF
	rr   b
	ld   b,a
	sbc  a,a
	xor  b
	and  $f0
	xor  b
	ld   (hl),a
	inc  l
	jr   nz,gfx_bloop

	; a bit of cleanup (we should load a font, here!)
	xor  a
blankloop:
	ld   (hl),a
	inc  hl
	cp   l
	jr nz,blankloop
		
	ld   h,$24
	ld   (base_graphics),hl

	EXTERN  cleargraphics
	call cleargraphics

ENDIF

        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF
	pop	bc
start1:
        ld      sp,0
IF (startup=2)
	di
	halt
ELSE
	jp (iy)		; To the Jupiter ACE FORTH system
ENDIF

l_dcal:
        jp      (hl)


	defm  "Small C+ J.ACE"
	defb  0
        INCLUDE "crt0_runtime_selection.asm"

;---------------------------------------------------------------------------
IF (startup=2) | (startup=3) ; ROM or moved system variables
;---------------------------------------------------------------------------


IF !DEFINED_sysdefvarsaddr
	defc sysdefvarsaddr = $2800-80   ; Close to the end of "PAD", the Forth interpreter workspace
ENDIF
IF !DEFINED_defvarsaddr
        defc defvarsaddr = 24576
ENDIF
	defc	bss_start = sysdefvarsaddr
	defc	bss_compiler_start = defvarsaddr
ENDIF

	INCLUDE	"crt0_section.asm"


IF (startup=2) | (startup=3) ; ROM or moved system variables
	SECTION	bss_crt
        PUBLIC	romsvc		; service space for ROM
romsvc:	defb	0 	; Pointer to the end of the sysdefvars
				; used by the ROM version of some library
ENDIF



