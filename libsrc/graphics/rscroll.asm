;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: rscroll.asm,v 1.7 2017-01-02 21:51:24 aralbrec Exp $
;



        SECTION code_clib
                PUBLIC    rscroll
                PUBLIC    _rscroll

                EXTERN     scroll_right



.rscroll
._rscroll
		push	ix
		ld	ix,2
		add	ix,sp
		ld	a,(ix+2)
		ld	c,(ix+4)
		ld	b,(ix+6)
		ld	l,(ix+8)
		ld	h,(ix+10)
		pop	ix
                jp      scroll_right

