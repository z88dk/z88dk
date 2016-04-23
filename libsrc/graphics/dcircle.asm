;       Z88 Small C+ Graphics Functions
;       Draw a circle on the Z88 map
;       Adapted from my Spectrum Routine
;       (C) 1995-1998 D.J.Morris
;
;	$Id: dcircle.asm,v 1.4 2016-04-23 21:05:46 dom Exp $
;

		SECTION   code_clib
                PUBLIC    draw_circle

DEFVARS 0
{
        x0      ds.b    1
        y0      ds.b    1
        radius  ds.b    1
        scale   ds.b    1
        cx      ds.b    1
        da      ds.b    1
}



;iy points to table on stack (above)

;Entry:
;       b=x0 c=y0, d=radius, e=scale factor
;       ix=plot routine

.draw_circle
        ld      iy,-6   ;create buffer on stack
        add     iy,sp
        ld      sp,iy
        ld      (iy+x0),b  
        ld      (iy+y0),c  
        ld      (iy+radius),d  
        ld      (iy+scale),e        ;step factor - usually 1
        call    l9900
        ld      hl,6
        add     hl,sp
        ld      sp,hl
        ret

;Line 9900
.l9900
          ld    (iy+cx),0  
          srl   d  
          ld    (iy+da),d  
;Line 9905
.l9905    ld    a,(iy+cx)  
          cp    (iy+radius)  
          ret   nc  
;Line 9910
          ld    a,(iy+da)  
          and   a  
          jp    p,l9915  
          add   a,(iy+radius)  
          ld    (iy+da),a  
          ld    a,(iy+radius)  
          sub   (iy+scale)  
          ld    (iy+radius),a  
;Line 9915
.l9915    ld    a,(iy+da)  
          dec   a  
          sub   (iy+cx)  
          ld    (iy+da),a  
          
.l9920    ld    a,(iy+y0)  
          add   a,(iy+radius)  
          ld    l,a  
          ex    af,af'
          ld    a,(iy+x0)  
          add   a,(iy+cx)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(iy+x0)  
          sub   (iy+cx)  
          ld    h,a  
          call  doplot  
          
          ld    a,(iy+y0)  
          sub   (iy+radius)  
          ld    l,a  
          ex    af,af'
          ld    a,(iy+x0)  
          add   a,(iy+cx)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(iy+x0)  
          sub   (iy+cx)  
          ld    h,a  
          call  doplot  
          
;Line 9925
          
          ld    a,(iy+y0)  
          add   a,(iy+cx)  
          ld    l,a  
          ex    af,af'
          ld    a,(iy+x0)  
          add   a,(iy+radius)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(iy+x0)  
          sub   (iy+radius)  
          ld    h,a  
          call  doplot  
          
          ld    a,(iy+y0)  
          sub   (iy+cx)  
          ld    l,a  
          ex    af,af'
          ld    a,(iy+x0)  
          add   a,(iy+radius)  
          ld    h,a  
          call  doplot  
          ex    af,af'
          ld    l,a
          ld    a,(iy+x0)  
          sub   (iy+radius)  
          ld    h,a  
          call  doplot  
          
;Line 9930
          ld    a,(iy+cx)  
          add   a,(iy+scale)  
          ld    (iy+cx),a  
          jp    l9905  

;Entry to my plot is the same as for the z88 plot - very convenient!

.doplot
        ret     c
        jp      (ix)

