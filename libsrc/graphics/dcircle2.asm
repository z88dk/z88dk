;       Z88 Small C+ Graphics Functions
;       Draw a circle on the Z88 map
;       Adapted from my Spectrum Routine
;       (C) 1995-1998 D.J.Morris
;
;	$Id: dcircle2.asm,v 1.2 2001-04-18 13:21:37 stefano Exp $
;


;	Alternate version. (Changes by Stefano)
;	Dirty hack to leave iy free and save the a' register
;	Not used anymore (I think)


                XLIB    draw_circle
		lib	plotpixel

DEFVARS 0
{
        x0      ds.b    1
        y0      ds.b    1
        radius  ds.b    1
        scale   ds.b    1
        cx      ds.b    1
        da      ds.b    1
}


IF FORti83p
.a1save	defb	0
ENDIF

;ix points to table on stack (above)

;Entry:
;       b=x0 c=y0, d=radius, e=scale factor
;       ix=plot routine

.draw_circle

IF FORti83p
	ex	af,af
	ld	(a1save),a
	ex	af,af
ENDIF

        ld      ix,-6   ;create buffer on stack
        add     ix,sp
        ld      sp,ix
        ld      (ix+x0),b  
        ld      (ix+y0),c  
        ld      (ix+radius),d  
        ld      (ix+scale),e        ;step factor - usually 1
        call    l9900
        ld      hl,6
        add     hl,sp
        ld      sp,hl
        
IF FORti83p
	ex	af,af
	ld	a,(a1save)
	ex	af,af
ENDIF

        ret

;Line 9900
.l9900
          ld    (ix+cx),0  
          srl   d  
          ld    (ix+da),d  
;Line 9905
.l9905    ld    a,(ix+cx)  
          cp    (ix+radius)  
          ret   nc  
;Line 9910
          ld    a,(ix+da)  
          and   a  
          jp    p,l9915  
          add   a,(ix+radius)  
          ld    (ix+da),a  
          ld    a,(ix+radius)  
          sub   (ix+scale)  
          ld    (ix+radius),a  
;Line 9915
.l9915    ld    a,(ix+da)  
          dec   a  
          sub   (ix+cx)  
          ld    (ix+da),a  
          
.l9920    ld    a,(ix+y0)  
          add   a,(ix+radius)  
          ld    l,a  
          ex    af,af'
          ld    a,(ix+x0)  
          add   a,(ix+cx)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(ix+x0)  
          sub   (ix+cx)  
          ld    h,a  
          call  doplot  
          
          ld    a,(ix+y0)  
          sub   (ix+radius)  
          ld    l,a  
          ex    af,af'
          ld    a,(ix+x0)  
          add   a,(ix+cx)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(ix+x0)  
          sub   (ix+cx)  
          ld    h,a  
          call  doplot  
          
;Line 9925
          
          ld    a,(ix+y0)  
          add   a,(ix+cx)  
          ld    l,a  
          ex    af,af'
          ld    a,(ix+x0)  
          add   a,(ix+radius)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(ix+x0)  
          sub   (ix+radius)  
          ld    h,a  
          call  doplot  
          
          ld    a,(ix+y0)  
          sub   (ix+cx)  
          ld    l,a  
          ex    af,af'
          ld    a,(ix+x0)  
          add   a,(ix+radius)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(ix+x0)  
          sub   (ix+radius)  
          ld    h,a  
          call  doplot  
          
;Line 9930
          ld    a,(ix+cx)  
          add   a,(ix+scale)  
          ld    (ix+cx),a  
          jp    l9905  


;Sorry for this, Dom...

.doplot
        ret     c
        jp      plotpixel
