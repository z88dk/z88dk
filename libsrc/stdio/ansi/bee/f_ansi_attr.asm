;
; 	ANSI Video handling for the MicroBEE
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 20161
;
;
;	$Id: f_ansi_attr.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_attr

	PUBLIC	bee_attr
	PUBLIC  INVRS

.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,15
        jr		setbk
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(bee_attr)
        or      @01000000
        jr		setbk
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(bee_attr)
        and     @10111111
        jr		setbk
.nodim
        cp      4
        jr      nz,nounderline
        ld      a,(bee_attr)
        or      @01001000
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a,(bee_attr)
        and     @10110111
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(bee_attr)
        or      @11000000
        jr		setbk
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(bee_attr)
        and     @00111111
        jr		setbk
.nocblink
        cp      7
        jr      nz,noreverse
		ld		a,128
		ld		(INVRS),a
		ret
.noreverse
        cp      27
        jr      nz,noCreverse
		xor		a
		ld		(INVRS),a
		ret
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(bee_attr)
        ld      (oldattr),a
        and     @00001111
        ld      e,a
        rla
        rla
        rla
		rla
		and		@11110000
        or      e
.setbk
		ld      (bee_attr),a
        ret
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        jr		setbk
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30
        and     15
.ZFR
;''''''''''''''''''''''
        ld      e,a
        ld      a,(bee_attr)
        and     @11110000
        or      e
        jr		setbk
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40
        and     15
.ZBK
;''''''''''''''''''''''
        rla
        rla
        rla
        rla
        ld      e,a
        ld      a,(bee_attr)
        and     @00001111
        or      e
        jr		setbk
.noback
        ret

		
	SECTION  bss_clib
	
.bee_attr
        defb 15
	
.oldattr
        defb     0

.INVRS
        defb     0
