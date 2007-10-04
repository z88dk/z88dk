;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	void opus_testchannel (struct X_CHAN channel);
;	test channel parameters, return 0 if no errors
;	
;	$Id: opus_testchannel.asm,v 1.1 2007-10-04 12:18:57 stefano Exp $
;


		XLIB 	opus_testchannel

		LIB	opus_rommap

		XREF	P_TESTCH
		

opus_testchannel:
		
		call	opus_rommap

		ld	ix,2
		add	ix,sp

		call	$1708		; Page in the Discovery ROM
		ld	e,(ix+0)	; channel address
		ld	d,(ix+0)	; channel address
		call	P_TESTCH
		ld	hl,0
		jr	nc,noerr
		inc	hl		; some error
		jr	nz,noerr
		inc	hl		; error in second part
noerr:
		call	$1748		; Page out the Discovery ROM
					; HL = zero or error code
		ret
