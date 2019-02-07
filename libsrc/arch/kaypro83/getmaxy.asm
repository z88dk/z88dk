;
;       Z88 Graphics Functions
;
;       Written around the Interlogic Standard Library
;
;	$Id: getmaxy.asm,v 1.5 2017-01-02 21:51:24 aralbrec Exp $
;



        SECTION code_graphics
        PUBLIC  getmaxy
        PUBLIC  _getmaxy
	EXTERN	CONSOLE_ROWS
	EXTERN	__kayproii_gfxmode

.getmaxy
._getmaxy
	ld	hl, CONSOLE_ROWS - 1
	ld	a,(__kayproii_gfxmode)
	and	a
	ret     z
	add	hl,hl
	inc	hl
	ret
