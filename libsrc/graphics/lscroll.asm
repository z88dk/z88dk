;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: lscroll.asm,v 1.3 2001-04-18 13:21:37 stefano Exp $
;


;Usage: lscroll(struct *pixels)


                XLIB    lscroll

                LIB     scroll_left



.lscroll
		ld	ix,0
		add	ix,sp
		ld	a,(ix+2)
		ld	c,(ix+4)
		ld	b,(ix+6)
		ld	l,(ix+8)
		ld	h,(ix+10)
                jp      scroll_left

