;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;
;	 - init the jump table
;
;	$Id: opus_rommap.asm,v 1.1 2007-10-04 12:18:57 stefano Exp $
;


		XLIB 	opus_rommap

		XDEF	P_DEVICE
		XDEF	P_TESTCH

opus_rommap:	; start creating an 'M' channel

		;rst	8
		;defb 	$D4		; Create microdrive system vars
					; why does it crash ?!??

		call	$1708		; Page in the Discovery ROM

		ld	b,0		; Table entry 0: "call physical device"
		rst	$30		; 'read table' restart
		defb	$12		; Table number 12h:  SYSTEM
		ld	(P_DEVICE+1),hl	; Self modifying code

		ld	b,8		; Table entry 8: "test channel parameters"
		rst	$30		; 'read table' restart
		defb	$12		; Table number 12h:  SYSTEM
		ld	(P_TESTCH+1),hl	; Self modifying code

		jp	$1748		; Page out the Discovery ROM


; Jump table

P_DEVICE: 	jp 0		; set temporary "M" channel
P_TESTCH: 	jp 0		; test channel
