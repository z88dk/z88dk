;
;       OSCA C Library
;
; 	ANSI Video handling
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - June 2012
;
;	$Id: f_ansi_attr.asm,v 1.5 2016-07-14 17:44:18 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr
    INCLUDE "flos.def"

	;PUBLIC	INVRS
	;PUBLIC	UNDRL

;.UNDRL  defb 0
;.INVRS  defb 0

.ansi_attr
        and     a
        jr      nz,noreset
        xor     a
        ;ld      (UNDRL),a   ; underline 0
        ld      a,$b             ; white (light grey) on default background
        jp	kjt_set_pen
.noreset
        cp      1
        jr      nz,nobold
        ld      a,8             ; white on default background
        jp	kjt_set_pen
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim    ld      a,$b             ; white (light grey) on default background
        jp	kjt_set_pen

.nodim  cp      4
        jr      nz,nounderline
        ;ld      a,1
        ;ld      (UNDRL),a   ; underline 1
        ld      a,8             ; white on default background
        jp	kjt_set_pen
.nounderline
        cp      24
        jr      nz,noCunderline
        ;xor	a
        ;ld      (UNDRL),a   ; underline 0
        ld      a,$b             ; light grey on default background
        jp	kjt_set_pen
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,$e             ; light green on default background
        jp	kjt_set_pen
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,$b             ; light grey on default background
        jp	kjt_set_pen
.nocblink
        cp      7
        jr      nz,noreverse
.callinverse
        call	kjt_get_pen
        ld		e,a
        rla
        rla
        rla
        rla
        and		$f0
        ld		d,a
        ld		a,e
        rra
        rra
        rra
        rra
        and	$f
        or	d
        jp	kjt_set_pen
.noreverse
        cp      27
        jr      z,callinverse
.noCreverse
        cp      8
        jr      nz,noinvis

        call	kjt_get_pen
        ld      (oldattr),a
        xor		a	; transparent over transparent
        jp	kjt_set_pen
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        jp	kjt_set_pen
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30
;'' Palette Handling ''
        call	dopal
        push	af
        call	kjt_get_pen
        and		$f0
        ld		e,a
        pop		af
        or		e
        jp	kjt_set_pen
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40
;'' Palette Handling ''
        call	dopal
        push	af
        call	kjt_get_pen
        and		$0f
        ld		e,a
        pop		af
        rla
        rla
        rla
        rla
        call	kjt_set_pen
.noback ret

.dopal
;		add		a
;		ret		z
;		inc		a
;		cp		7
;		ret		c
;		srl		a
;		srl		a
;		ret

;
;0 black	0
;1 red  	3
;2 green	5
;3 yellow	7
;4 blue  	2
;5 magenta	4
;6 cyan   	6
;7 white  	8 <- better to use light grey

        ld      e,a
        ld      d,0
        ld      hl,ctable
        add     hl,de
        ld      a,(hl)
        ret

.ctable 
defb	1,3,5,7,2,4,6,$b
