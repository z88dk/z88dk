;
; 	ANSI Video handling for the Philips VG-5000
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_attr.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	PUBLIC	vg5k_attr
	;PUBLIC	vg5k_inverse
	

        SECTION bss_clib
.vg5k_attr	defb 0
.vg5k_inverse	defb 0

        SECTION code_crt_init
	ld	a,7		; White on black
	ld	(vg5k_attr),a


        SECTION code_clib

.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,7
        ld      (vg5k_attr),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(vg5k_attr)
        or      @00001000
        ld      (vg5k_attr),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(vg5k_attr)
        and     @11110111
        ld      (vg5k_attr),a
        ret
.nodim
        cp      4
        jr	nz,nounderline
        ld      a,(vg5k_attr)	; Underline
        or      @00001000
        ld      (vg5k_attr),a
        ret
.nounderline
        cp      24
        jr	nz,noCunderline
        ld      a,(vg5k_attr)	; Cancel Underline
        and     @11110111
        ld      (vg5k_attr),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(vg5k_attr)
        or      @00001000
        ld      (vg5k_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(vg5k_attr)
        and     @11110111
        ld      (vg5k_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld	a,(vg5k_inverse)
        and	a
        ret	nz
        ld      a,1
        ld      (vg5k_inverse),a     ; inverse 1
.attrswap
        ld      a,(vg5k_attr)
        xor      @00001000
        ld      (vg5k_attr),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld	a,(vg5k_inverse)
        and	a
        ret	z
        xor	a
        ld      (vg5k_inverse),a     ; inverse 1
        jr	attrswap
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(vg5k_attr)
        ld      (oldattr),a
        and     @1111
        ld      e,a
        rla
        rla
        rla
        rla
        or      e
        ld      (vg5k_attr),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        ld      (vg5k_attr),a
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
        ld      e,a
        ld      a,(vg5k_attr)
        and     @11111000
        or      e
        ld      (vg5k_attr),a

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
        ld      a,(vg5k_attr)
        and     @11111000
        or      e
        ld      (vg5k_attr),a
;
;
.noback
        ret
