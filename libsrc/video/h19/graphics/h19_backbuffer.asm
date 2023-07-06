;
;	Heath/Zenith H19 specific code
;	Use the CP/M BIOS to send characters to screen.
;	L = character to be sent
;
;	Stefano Bodrato - 2023
;
;	$Id: h19_backbuffer.asm $
;

	SECTION	code_clib
	PUBLIC	h19_backbuffer

.h19_backbuffer
	defs 80*26
