;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2025
;
; 	Handles colors referring to current PAPER/INK/etc. settings
;
;
;	f_ansi_scrollup_815.asm
;
;

    section code_graphics
    PUBLIC  ansi_SCROLLUP
	
	EXTERN scrollup_6px



ansi_SCROLLUP:

	jp  scrollup_6px
	
