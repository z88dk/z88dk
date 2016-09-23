;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;
;	$Id: f_ansi_attr.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;


        SECTION  code_clib
	PUBLIC	ansi_attr

	PUBLIC	z9001_attr
	

.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,7*16
        jr		setbk
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(z9001_attr)	; blink 1
        or      @10000000
        jr		setbk
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(z9001_attr)	; blink 0
        and     @01111111
        jr		setbk
.nodim
        cp      4
        jr      nz,nounderline
        ld      a,(z9001_attr)	; blink 1
        or      @10000000
        jr		setbk
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a,(z9001_attr)	; blink 0
        and     @01111111
        jr		setbk
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(z9001_attr)
        or      @10000000
        jr		setbk
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(z9001_attr)
        and     @01111111
        jr		setbk
.nocblink
        cp      7
        jr      nz,noreverse
		jr		swapattr
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
.swapattr
        ld      a,(z9001_attr)
		rla
		rla
		rla
		rla
        and     @11110000
		ld		e,a
        ld      a,(z9001_attr)
		rra
		rra
		rra
		rra
        and     @00001111
		or		e
		ld		(z9001_attr),a
        ret
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(z9001_attr)
        ld      (oldattr),a
        and     @00111000
        ld      e,a
        rra
        rra
        rra
        or      e
.setbk
		ld      (z9001_attr),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        jr		setbk
.nocinvis
        cp      40
        jp      m,nofore
        cp      47+1
        jp      p,nofore
        sub     40-8
        and     7
.ZBK
;''''''''''''''''''''''
        ld      e,a
        ld      a,(z9001_attr)
        and     @11110000
        or      e
        jr		setbk
.nofore
        cp      30
        jp      m,noback
        cp      37+1
        jp      p,noback
        sub     30-8
        and     7
.ZFR
;''''''''''''''''''''''
        rla
        rla
        rla
		rla
        ld      e,a
        ld      a,(z9001_attr)
        and     @00001111
        or      e
        jr		setbk
.noback
        ret

	SECTION  bss_clib
.z9001_attr	defb 7*16
