;
;      Colour graphics routines
;
;      cls ()  -- clear screen
;
;      Stefano Bodrato - 2018
;
;
;      $Id: cclg.asm $
;

    	SECTION	code_graphics
    	PUBLIC    cclg
        PUBLIC    _cclg

	EXTERN	clg
	
.cclg
._cclg

	jp clg
