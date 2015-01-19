;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int psg_init();
;
;	Set up the PSG
;
;
;	$Id: psg_init.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	psg_init
	EXTERN		zx_fullerstick

	EXTERN		set_psg_callee
	EXTERN		get_psg
	
	EXTERN	psg_patch0
	EXTERN	psg_patch1
	

; Let's force the linker to include set and get, so we can patch them
; We're wasting a lot of bytes Alvin, I know..  :P
call set_psg_callee
call get_psg
	

psg_init:
	
	call zx_fullerstick
	xor	a
	or l
	jr	z,nofuller
	ld	a,$3f
	ld  (psg_patch0+1),a
	ld  (psg_patch2+1),a
	ld	hl,$5f0e	; ld c,$5f
	ld	(psg_patch1),hl
	ld	(psg_patch3),hl
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
psg_patch2:
    LD	BC,$fffd
	OUT	(C),a
psg_patch3:
	ld b,$bf
	OUT	(C),e
	ret

