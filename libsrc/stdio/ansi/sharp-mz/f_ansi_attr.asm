;
;       Spectrum C Library
;
; 	ANSI Video handling for The Sharp MZ
;	(Hey, I've been lucky.. the Aquarius port works in the same way!)
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	Stefano Bodrato - May 2000
;	Stefano Bodrato - Jan 2002..fixed
;
;	$Id: f_ansi_attr.asm,v 1.6 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr
	PUBLIC	current_attr

	SECTION bss_clib

.current_attr	defb	0 
.mz_inverse	defb	0

	SECTION code_crt_init
	ld	a,$70	;  White text on black background
	ld	(current_attr),a

        SECTION code_clib

.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,$70
        ld      (current_attr),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(current_attr)
        or      @00001000
        ld      (current_attr),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(current_attr)
        and     @11110111
        ld      (current_attr),a
        ret
.nodim
        cp      4
        jr	nz,nounderline
        ld      a,(current_attr)	; Underline
        or      @00001000
        ld      (current_attr),a
        ret
.nounderline
        cp      24
        jr	nz,noCunderline
        ld      a,(current_attr)	; Cancel Underline
        and     @11110111
        ld      (current_attr),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(current_attr)
        or      @10000000
        ld      (current_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(current_attr)
        and     @01111111
        ld      (current_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld	a,(mz_inverse)
        and	a
        ret	nz
        ld      a,1
        ld      (mz_inverse),a     ; inverse 1
.attrswap
        ld      a,(current_attr)
	rla
	rla
	rla
	rla
	and	@11110000
	ld	e,a
	ld      a,(current_attr)
	rra
	rra
	rra
	rra
	and	@1111
        or	e
        ld	(current_attr),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld	a,(mz_inverse)
        and	a
        ret	z
        xor	a
        ld      (mz_inverse),a     ; inverse 1
        jr	attrswap
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(current_attr)
        ld      (oldattr),a
        and     @1111
        ld      e,a
        rla
        rla
        rla
        rla
        or      e
        ld      (current_attr),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        ld      (current_attr),a
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30

;'' Palette Handling ''
        rla
        bit     3,a
        jr      z,ZFR
        set     0,a
.ZFR
        and     7
;''''''''''''''''''''''
        rla
        rla
        rla
        rla
        ld      e,a
        ld      a,(current_attr)
        and     @10001111
        or      e
        ld      (current_attr),a 

.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40

;'' Palette Handling ''
        rla
        bit     3,a
        jr      z,ZBK
        set     0,a
.ZBK
        and     7
;''''''''''''''''''''''
        ld      e,a
        ld      a,(current_attr)
        and     @11111000
        or      e
        ld      (current_attr),a
        ret

.noback
        ret
