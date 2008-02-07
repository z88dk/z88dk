;
;	ZX Spectrum specific routines
;	Stefano Bodrato - 5/2/2008
;
;	int opus_installed();
;
;	The result is:
;	- 0 (false) if the Opus Discovery Interface is missing
;	- 1 (true) if the Opus Discovery Interface is connected
;
;	Tries to issue a POINT #0,1 command, to see if the syntax is accepted.
;	Shouldn't conflict with other interfaces.
;
;	$Id: zx_opus.asm,v 1.2 2008-02-07 11:18:07 stefano Exp $
;

	XLIB	zx_opus
	LIB	zx_syntax

zx_opus:
		ld	hl,testcmd
		push	hl
		call	zx_syntax
		pop	bc
		ret
		
testcmd:	defb	169,35,195,167,44,188,167,13    ; POINT # NOT PI,SGN PI <CR>

