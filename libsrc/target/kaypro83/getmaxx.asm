;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxx.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;


                SECTION   code_graphics
                PUBLIC    getmaxx
                PUBLIC    _getmaxx
		EXTERN	CONSOLE_COLUMNS

.getmaxx
._getmaxx
		ld	hl,CONSOLE_COLUMNS - 1
		ret
