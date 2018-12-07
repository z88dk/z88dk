;
;	PC-8801 specific routines
;
;	int psg_init();
;
;	Set up the PSG.
;	There are lost of sound interfaces out there, 
;	this driver will probably work only with the factory configurations.
;
;
;	$Id: psg_init.asm $
;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	
	EXTERN _pc88_fm_addr


psg_init:
_psg_init:
	
	call _pc88_fm_addr
	ld (__psg_port),hl


do_init:
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
	ld	bc,(__psg_port)	
	
	ld	b,a
busyloop:
	in a,(c) 
	rlca 
	jr c, busyloop
	ld	a,b

	OUT	(C),a
	inc bc
	ld a,(ix+0)		; dummy instruction used to pause
	OUT	(C),e

	ret
	
	
	SECTION	bss_clib
	PUBLIC	__psg_port

__psg_port:   defw	0
