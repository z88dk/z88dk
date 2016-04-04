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
;	$Id: f_ansi_scrollup.asm,v 1.6 2016-04-04 18:31:23 dom Exp $
;

	SECTION	code_clib
	PUBLIC	ansi_SCROLLUP

	EXTERN  call_rom3


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
 
