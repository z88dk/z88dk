;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;	$Id: lscroll.asm,v 1.7 2017-01-02 21:51:24 aralbrec Exp $
;


;Usage: lscroll(struct *pixels)

IF !__CPU_GBZ80__ & !__CPU_INTEL__

       SECTION code_graphics
             PUBLIC    lscroll
             PUBLIC    _lscroll

             EXTERN    scroll_left



.lscroll
._lscroll
    push	ix
    ld	ix,2
    add	ix,sp
    ld	a,(ix+2)
    ld	c,(ix+4)
    ld	b,(ix+6)
    ld	l,(ix+8)
    ld	h,(ix+10)
    pop	ix
             jp     scroll_left

ENDIF
