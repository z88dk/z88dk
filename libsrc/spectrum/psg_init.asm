;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int psg_init();
;
;	Set up the PSG
;
;
;	$Id: psg_init.asm,v 1.1 2013-11-18 10:59:06 stefano Exp $
;

	XLIB	psg_init
	LIB		zx_fullerstick
	LIB		zx_timexsound

	LIB		set_psg
	LIB		get_psg
	
	XREF	psg_patch0
	XREF	psg_patch1
	XREF	psg_patch2
	XREF	psg_patch3
	

; Let's force the linker to include set and get, so we can patch them
; We're wasting a lot of bytes Alvin, I know..  :P
call set_psg
call get_psg
	

psg_init:
	
	call zx_timexsound
	xor	a
	or l
	jr	z,notimex
	ld	a,$f5
	ld  (psg_patch0+1),a
	ld  (psg_patch2+1),a
	ld	hl,$f60e	; ld c,$f6
	ld	(psg_patch1),hl
	ld  (psg_patch3),a
notimex:

	call zx_fullerstick
	xor	a
	or l
	jr	z,nofuller
	ld	a,$3f
	ld  (psg_patch0+1),a
	ld	hl,$5f0e	; ld c,$5f
	ld	(psg_patch1),hl
nofuller:



	ld	e,@01010101
	xor a 	; R0: Channel A frequency low bits
	call outpsg

	ld	e,a

	ld d,12
psg_iniloop:
	inc a	; R1-13: set all to 0 but 7 and 11
	;cp 7
	;jr z,skip
	;cp 11
	;jr z,skip
	call outpsg
skip:
	dec d
	jr	nz,psg_iniloop

	ld	e,@11111000	; R7: Channel setting.  Enable sound channels ABC and input on ports A and B
	ld	a,7
	call outpsg

	ld	e,@00001011	; R11: Envelope
	ld	a,11

outpsg:
    LD	BC,$fffd
	OUT	(C),a
	LD	BC,$bffd
	OUT	(C),e
	ret

