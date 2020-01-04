;
;	TRS-80 (EG2000+HT1080) specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int psg_init();
;
;	Set up the PSG
;
;
;	$Id: psg_init.asm,v 1.2 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	
	EXTERN	get_psg
	EXTERN	get_psg2


psg_init:
_psg_init:
	

	ld	e,@01010101
	xor a 	; R0: Channel A frequency low bits
	call outpsg

    LD	BC,31
	OUT	(C),a
    LD	c,30
	in	a,(C)
	and a
	jr  z,htmode
	
	; HT1080 not found, try in "Colour Genie" mode
	ld	a,$f8
	ld	(get_psg+1),a
	inc a
	ld	(get_psg2+1),a
	
htmode:

	xor a
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
    LD	BC,31
	OUT	(C),a
	LD	C,30
	OUT	(C),e
	
    LD	BC,$f8
	OUT	(C),a
	LD	C,$f9
	OUT	(C),e
	
	ret

