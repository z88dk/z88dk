;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;
;	 - init the jump table
;
;	$Id: opus_rommap.asm,v 1.4 2015-01-19 01:33:11 pauloscustodio Exp $
;


		PUBLIC 	opus_rommap

		PUBLIC	P_DEVICE
		PUBLIC	P_TESTCH

opus_rommap:

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
		ld	(P_DEVICE+1),hl	; Self modifying code

		ld	b,8		; Table entry 8: "test channel parameters"
		rst	$30		; 'read table' restart
		defb	$12		; Table number 12h:  SYSTEM
		ld	(P_TESTCH+1),hl	; Self modifying code

		;jp	$1748		; Page out the Discovery ROM
mapped:
		pop hl
		pop de
		pop bc
		pop af
		ret


; Jump table

P_DEVICE: 	jp 0		; Call the hardware ('CALL A PHYSICAL DEVICE').
P_TESTCH: 	jp 0		; test channel
