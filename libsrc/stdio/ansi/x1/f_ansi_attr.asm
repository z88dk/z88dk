;
; 	ANSI Video handling for the Sharp X1
;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	$Id: f_ansi_attr.asm,v 1.6 2016-07-14 17:44:18 pauloscustodio Exp $
;

	SECTION code_clib
	PUBLIC	ansi_attr

	;EXTERN	INVRS
	EXTERN	__x1_attr

.ansi_attr
        and     a
        jr      nz,noreset
        ;ld      a,15		;White on black
        ld      a,7		;White on black
        ld      (__x1_attr),a
;	xor	a
;	ld	(INVRS+1),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld		a,(__x1_attr)
        set		3,a
        ld      (__x1_attr),a
;	ld	a,128
;	ld	(INVRS+1),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld		a,(__x1_attr)
        res		3,a
        ld      (__x1_attr),a
        ret
.nodim
        cp      4
        jr      nz,nounderline
        ld		a,(__x1_attr)
        set		4,a
        ld      (__x1_attr),a
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld		a,(__x1_attr)
        res		4,a
        ld      (__x1_attr),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld		a,(__x1_attr)
        set		4,a
        ld      (__x1_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld		a,(__x1_attr)
        res		4,a
        ld      (__x1_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld		a,(__x1_attr)
        set		3,a
        ld      (__x1_attr),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld		a,(__x1_attr)
        res		3,a
        ld      (__x1_attr),a
        ret
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(__x1_attr)
        ld      (oldattr),a
        and     @11110000
        ld      e,a
        rra
        rra
        rra
        rra
        or      e
        ld      (__x1_attr),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        ld      (__x1_attr),a
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30
        call	palette
;''''''''''''''''''''''
        ld      (__x1_attr),a
        ret
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40		; Workaround for background: we force to inverse video.
        call	palette		; could work in some cases, but isn't much compatible !
        set		3,a
;''''''''''''''''''''''
;	ld	(53280),a	;border
;	ld	(53281),a	;background
        ld      (__x1_attr),a
	;ld	a,128
	;ld	(INVRS+1),a
.noback
        ret


.palette
;'' Palette Handling ''
	ld	e,a
	ld	d,0
	ld	hl,attrtab
	add	hl,de
	ld	a,(hl)
	ret
.attrtab
	defb	0
	defb	2
	defb	4
	defb	6
	defb	1
	defb	3
	defb	5
	defb	7
