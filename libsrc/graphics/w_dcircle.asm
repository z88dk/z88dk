;       Z88 Small C+ Graphics Functions
;       Draw a circle on the Z88 map
;       Adapted from my Spectrum Routine
;       (C) 1995-1998 D.J.Morris
;
;	$Id: w_dcircle.asm,v 1.4 2016-04-13 21:09:09 dom Exp $
;


        SECTION code_clib
	PUBLIC w_draw_circle
	EXTERN l_cmp

DEFVARS 0
{
        x0l     ds.b    1
        x0h     ds.b    1
        y0l     ds.b    1
        y0h     ds.b    1
        rlv      ds.b    1
        rh      ds.b    1
        cxl     ds.b    1
        cxh     ds.b    1
        dal     ds.b    1
        dahi    ds.b    1
        scale   ds.b    1
}



;iy points to table on stack (above)

;Entry:
;       de = x0, hl = y0, bc = radius, a = scale factor
;       b=x0 c=y0, d=radius, e=scale factor
;       ix=plot routine

.w_draw_circle
		ld iy,-11   ;create buffer on stack
		add iy,sp
		ld sp,iy

		ld (iy+x0l),e
		ld (iy+x0h),d
		ld (iy+y0l),l
		ld (iy+y0h),h
		ld (iy+rlv),c
		ld (iy+rh),b
		ld (iy+scale),a        ;step factor - usually 1

		call l9900
		ld hl,11
		add hl,sp
		ld sp,hl
		ret

;Line 9900
.l9900
		ld (iy+cxl),0
		ld (iy+cxh),0
		srl b
		rr c
		ld (iy+dal),c
		ld (iy+dahi),b
;Line 9905
.l9905
		ld b,(iy+rh)
		ld c,(iy+rlv)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		ld h,b
		ld l,c
		call l_cmp
		ret nc
;Line 9910
		bit 7,(iy+dahi)
		jr z,l9915

		ld c,(iy+dal)
		ld b,(iy+dahi)
		ld e,(iy+rlv)
		ld h,(iy+rh)
		add hl,bc
		ld b,h
		ld c,l
		ld (iy+dal),c
		ld (iy+dahi),b

		ld d,(iy+rh)
		ld e,(iy+rlv)
		ld c,(iy+scale)
		ld b,0
		ld h,d
		ld l,e
		or a; CY = 0
		sbc hl,bc
		ld b,h
		ld c,l
		ld (iy+rlv),c
		ld (iy+rh),b
;Line 9915
.l9915
		ld b,(iy+dahi)
		ld c,(iy+dal)
		dec bc
		ld h,b
		ld l,c
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		or a
		sbc hl,de
		ld b,h
		ld c,l
		ld (iy+dal),c
		ld (iy+dahi),b

.l9920
		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		srl d
		rr e
		ld h,b
		ld l,c
		add hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		ld h,b
		ld l,c
		add hl,de
		pop de

		call do_w_plot; (cx,r)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		srl d
		rr e
		ld h,b
		ld l,c
		add hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		ld h,b
		ld l,c
		or a
		sbc hl,de
		pop de

		call do_w_plot; (-cx,r)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		srl d
		rr e
		ld h,b
		ld l,c
		or a
		sbc hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		ld h,b
		ld l,c
		add hl,de
		pop de

		call do_w_plot; (cx,-r)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		srl d
		rr e
		ld h,b
		ld l,c
		or a
		sbc hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		ld h,b
		ld l,c
		or a
		sbc hl,de
		pop de

		call do_w_plot; (-cx,-r)



		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		srl d
		rr e
		ld h,b
		ld l,c
		add hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		ld h,b
		ld l,c
		add hl,de
		pop de

		call do_w_plot; (r,cx)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		srl d
		rr e
		ld h,b
		ld l,c
		add hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		ld h,b
		ld l,c
		or a
		sbc hl,de
		pop de

		call do_w_plot; (-r,cx)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		srl d
		rr e
		ld h,b
		ld l,c
		or a
		sbc hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		ld h,b
		ld l,c
		add hl,de
		pop de

		call do_w_plot; (r,-cx)

		ld b,(iy+y0h)
		ld c,(iy+y0l)
		ld d,(iy+cxh)
		ld e,(iy+cxl)
		srl d
		rr e
		ld h,b
		ld l,c
		or a
		sbc hl,de
		push hl

		ld b,(iy+x0h)
		ld c,(iy+x0l)
		ld d,(iy+rh)
		ld e,(iy+rlv)
		ld h,b
		ld l,c
		or a
		sbc hl,de
		pop de

		call do_w_plot ; (-r,-cx)

		ld b,(iy+cxh)
		ld c,(iy+cxl)
		ld e,(iy+scale)
		ld d,0
		ld h,b
		ld l,c
		add hl,de
		ld b,h
		ld c,l
		ld (iy+cxh),b
		ld (iy+cxl),c
		jp l9905

.do_w_plot
		jp (ix)
