;
;       Spectrum C Library
;
; 	ANSI Video handling for ZX Spectrum
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.4 2014-01-03 15:20:43 stefano Exp $
;

	XLIB	ansi_SCROLLUP

	XREF  call_rom3


.ansi_SCROLLUP
	 ;ld     a,(23693)
	 ;ld     (23624),a
	 ld		a,($dff)
	 cp		$17
	 jr		nz,ts2068_rom
	 call    call_rom3
	 defw	3582	;scrollup
	 ret
.ts2068_rom
	 call    call_rom3
     defw	$939	; TS2068 scrollup
	 ret
 
