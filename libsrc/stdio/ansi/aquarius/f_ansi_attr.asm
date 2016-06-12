;
; 	ANSI Video handling for the Mattel Aquarius
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Dec. 2000
;
;
;	$Id: f_ansi_attr.asm,v 1.3 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr


        SECTION data_clib
	PUBLIC	aquarius_attr
	PUBLIC	aquarius_inverse
	
.aquarius_inverse	defb 0
.aquarius_attr		defb $70	; White on Black

        SECTION code_clib

.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,$70
        ld      (aquarius_attr),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(aquarius_attr)
        or      @00001000
        ld      (aquarius_attr),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(aquarius_attr)
        and     @11110111
        ld      (aquarius_attr),a
        ret
.nodim
        cp      4
        jr	nz,nounderline
        ld      a,(aquarius_attr)	; Underline
        or      @00001000
        ld      (aquarius_attr),a
        ret
.nounderline
        cp      24
        jr	nz,noCunderline
        ld      a,(aquarius_attr)	; Cancel Underline
        and     @11110111
        ld      (aquarius_attr),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(aquarius_attr)
        or      @10000000
        ld      (aquarius_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(aquarius_attr)
        and     @01111111
        ld      (aquarius_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld	a,(aquarius_inverse)
        and	a
        ret	nz
        ld      a,1
        ld      (aquarius_inverse),a     ; inverse 1
.attrswap
        ld      a,(aquarius_attr)
	rla
	rla
	rla
	rla
	and	@11110000
	ld	e,a
	ld      a,(aquarius_attr)
	rra
	rra
	rra
	rra
	and	@1111
        or	e
        ld	(aquarius_attr),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld	a,(aquarius_inverse)
        and	a
        ret	z
        xor	a
        ld      (aquarius_inverse),a     ; inverse 1
        jr	attrswap
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(aquarius_attr)
        ld      (oldattr),a
        and     @1111
        ld      e,a
        rla
        rla
        rla
        rla
        or      e
        ld      (aquarius_attr),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        ld      (aquarius_attr),a
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30

;'' Palette Handling ''
        and     7
;''''''''''''''''''''''
        rla
        rla
        rla
        rla
        ld      e,a
        ld      a,(aquarius_attr)
        and     @10001111
        or      e
        ld      (aquarius_attr),a 

.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40

;'' Palette Handling ''
        and     7
;''''''''''''''''''''''
        ld      e,a
        ld      a,(aquarius_attr)
        and     @11111000
        or      e
        ld      (aquarius_attr),a
        ret

.noback
        ret
