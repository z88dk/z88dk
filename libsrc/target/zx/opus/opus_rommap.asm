;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;
;	 - init the jump table
;
;	$Id: opus_rommap.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC 	opus_rommap
		PUBLIC 	_opus_rommap

		PUBLIC	P_DEVICE
		PUBLIC	P_TESTCH

opus_rommap:
_opus_rommap:

		; start creating an 'M' channel
		;rst	8
		;defb 	$D4		; Create microdrive system vars
					; why does it crash ?!??

		push	af
		push	bc
		push	de
		push	hl

		call	$1708		; Page in the Discovery ROM

		ld		a,(P_DEVICE+2)
		and		a
		jr		nz,mapped		; exit if already initialized

		ld	b,0		; Table entry 0: "call physical device"
		rst	$30		; 'read table' restart
		defb	$12		; Table number 12h:  SYSTEM
		ld	a,195		; jp
		ld	(P_DEVICE),a
		ld	(P_DEVICE+1),hl	; Self modifying code

		ld	b,8		; Table entry 8: "test channel parameters"
		rst	$30		; 'read table' restart
		defb	$12		; Table number 12h:  SYSTEM
		ld	a,195		; jp
		ld	(P_TESTCH),a
		ld	(P_TESTCH+1),hl	; Self modifying code

		;jp	$1748		; Page out the Discovery ROM
mapped:
		pop hl
		pop de
		pop bc
		pop af
		ret


; Jump table
		SECTION	bss_clib
P_DEVICE: 	defs	3	; Call the hardware ('CALL A PHYSICAL DEVICE').
P_TESTCH: 	defs	3	; test channel
