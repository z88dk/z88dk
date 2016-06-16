;       Z88 Small C+ Run Time Library 
;       Long functions
;	"8080" mode
;	Stefano - 29/4/2002
;	$Id: l_long_sub.asm,v 1.3 2016-06-16 20:31:05 dom Exp $
;

                SECTION   code_crt0_sccz80
	PUBLIC l_long_sub


;primary = secondary - primary
;enter with secondary, primary on stack

.l_long_sub
	ex	(sp),hl
	ld	(retloc+1),hl
	pop	bc
        
        ld      hl,0
        add     hl,sp   ;points to hl on stack
	
        ld      a,(hl)
        sub     c
        inc     hl
        ld      c,a
	
        ld      a,(hl)
        sbc     a,b
        inc     hl
        ld      b,a
	
        ld      a,(hl)
        sbc     a,e
        inc     hl
        ld      e,a
	
        ld      a,(hl)
        sbc     a,d
	inc	hl
        ld      d,a
        
	ld	sp,hl
	
        ld      l,c     ;get the lower 16 back into hl
        ld      h,b

.retloc	jp	0

