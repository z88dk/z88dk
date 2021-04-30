;
;       Bondwell 2 graphics routines
;
;       Stefano Bodrato 2021
;

        SECTION   code_graphics
	
	PUBLIC	cleargraphics
	PUBLIC	_cleargraphics
	PUBLIC	clg
	PUBLIC	_clg

	EXTERN	generic_console_cls

	defc	clg = _clg
	defc	_clg = cleargraphics
	defc	cleargraphics = _cleargraphics


	defc	_cleargraphics = generic_console_cls
