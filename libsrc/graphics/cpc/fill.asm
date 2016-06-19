;
;       Z88DK Graphics Functions - Small C+ stubs
;
;       Fill  - Stefano Bodrato
;
;
;198   &BD52   GRA FILL
;      Action: Fills an area of the  screen  starting from the current
;              graphics position and extending until it reaches either
;              the edge of the window or a pixel set to the PEN
;      Entry:  A holds a PEN to fill with, HL holds the address of the
;              buffer, and DE holds the length of the buffer
;      Exit:   If the area was filled properly, then Carry is true; if
;              the area was not filled, then Carry is false; in either
;              case, A, BC, DE, HL  and  the  other flags are corrupt,
;              and all others are preserved
;      Notes:  The buffer is  used  to  store  complex  areas to fill,
;              which are remembered and  filled  when  the basic shape
;              has been done;  each  entry  in  the  buffer uses seven
;              bytes and so the more complex  the shape the larger the
;              buffer; if it runs out of  space to store these complex
;              areas, it will fill what  it  can  and then return with
;              Carry false
;
;
;	$Id: fill.asm,v 1.5 2016-06-19 21:10:08 dom Exp $
;


;Usage: fill(struct *pixel)

        SECTION   code_clib
        PUBLIC    fill
        PUBLIC    _fill

        INCLUDE "cpcfirm.def"
        
        INCLUDE	"graphics/grafix.inc"


.fill
._fill
		push	ix
		ld      ix,2
		add     ix,sp
		
		ld      e,(ix+2)
		ld      d,(ix+3)

		ld      hl,maxy
		sbc     hl,de

		ld      e,(ix+4)
		ld      d,(ix+5)

		and     a		; double size (?)
		rl      l
		rl      h

		and     a
		rl      e
		rl      d

        call    firmware
        defw    gra_move_absolute

        ld      a,fcolor

		ld      hl,-3192	; create the buffer on stack
		add     hl,sp
		ld      sp,hl
		ld      d,h
		ld      e,l

        call    firmware
        defw    gra_fill        ; 664/6128 only

		ld      hl,3192		; restore the stack pointer
		add     hl,sp
		ld      sp,hl
		pop	ix
		ret
