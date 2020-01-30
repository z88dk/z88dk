;
;       Generic pseudo graphics routines for text-only platforms
;
;       Written by Stefano Bodrato 30/01/2002
;
;
;       Clears graph screen.
;
;


			INCLUDE	"graphics/grafix.inc"

		        SECTION code_clib
			PUBLIC	cleargraphics
        		PUBLIC   _cleargraphics
			EXTERN	generic_console_cls


.cleargraphics
._cleargraphics
	call	generic_console_cls
	ret
