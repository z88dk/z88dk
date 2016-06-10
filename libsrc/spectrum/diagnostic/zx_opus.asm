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
;	If so, tries the short style command LOAD *PI;"A"
;	Shouldn't conflict with other interfaces.
;
;	$Id: zx_opus.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_opus
	PUBLIC	_zx_opus
	EXTERN	zx_syntax

zx_opus:
_zx_opus:
		ld	hl,testcmd
		call	zx_syntax
		xor	a
		or	l
		ret	z
		ld	hl,testcmd2	; further test (Disciple might accept "POINT")
		jp	zx_syntax


testcmd:	defb	169,35,195,167,44,188,167,13    ; POINT # NOT PI,SGN PI <CR>
testcmd2:	defb	239,42,167,59,34,65,34,13	; LOAD *PI;"A"

