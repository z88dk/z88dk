;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	void opus_testchannel (struct X_CHAN channel);
;	test channel parameters, return 0 if no errors
;	
;	$Id: opus_testchannel.asm,v 1.5 2016-06-27 19:16:34 dom Exp $
;

		SECTION code_clib
		PUBLIC 	opus_testchannel
		PUBLIC 	_opus_testchannel

		EXTERN	opus_rommap

		EXTERN	P_TESTCH
		

opus_testchannel:
_opus_testchannel:
		push	ix		;save callers
		ld	ix,4
		add	ix,sp

		call	opus_rommap
		;call	$1708		; Page in the Discovery ROM
		ld	e,(ix+0)	; channel address
		ld	d,(ix+0)	; channel address
		call	P_TESTCH
		ld	hl,0
		jr	nc,noerr
		inc	hl		; some error
		jr	nz,noerr
		inc	hl		; error in second part
noerr:
		pop	ix		; restore callers
		jp	$1748		; Page out the Discovery ROM
					; HL = zero or error code
		;ret
