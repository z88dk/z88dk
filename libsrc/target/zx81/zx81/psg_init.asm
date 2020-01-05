;
;	ZX81 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int psg_init();
;
;	Set up the PSG
;
;
;	$Id: psg_init.asm,v 1.3 2016-06-26 20:32:08 dom Exp $
;

        SECTION code_clib
	PUBLIC  psg_init
	PUBLIC _psg_init


psg_init:
_psg_init:
	

	ld	e,@01010101
	xor a 	; R0: Channel A frequency low bits
	call outpsg

	ld	e,a

	ld d,12
psg_iniloop:
	inc a	; R1-13: set all to 0 but 7 and 11
	cp 7
	jr z,skip
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
    ;LD	BC,$cf
    LD	BC,$df
	OUT	(C),a
	LD	C,$0f
	;LD	C,$1f
	OUT	(C),e
	ret

