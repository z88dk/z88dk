;
; 	ANSI Video handling for the Amstrad CPC
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Jul. 2004
;
;
;	$Id: f_ansi_attr.asm,v 1.1 2004-07-15 10:03:49 stefano Exp $
;

	XLIB	ansi_attr

	XDEF	INVRS
	XDEF	UNDRL

.UNDRL  defb 0

.ansi_attr
        and     a
        jr      nz,noreset
        xor	a
        ld      (UNDRL),a   ; underline 0
        ld      a,2
        call	$BB90 	;ink	bright cyan
        ld	a,0
        jp	$BB96	;paper	blue
.noreset
        cp      1
        jr      nz,nobold
	ld	a,1
        call	$BB90 	;ink	bright yellow
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,2
        call	$BB90 	;ink	bright cyan
        ret
.nodim
        cp      4
        jr      nz,nounderline
        ld	a,1
        ld      (UNDRL),a   ; underline 1
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        xor	a
        ld      (UNDRL),a   ; underline 0
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        call	$BB93	; get pen
        xor	3
	call	$BB96	; set pen
        ret
.noblink
        cp      25
        jr      nz,nocblink
        call	$BB93	; get pen
        xor	3
	call	$BB96	; set pen
        ret
.nocblink
        cp      7
        jr      nz,noreverse
	jp	$BB9C	; swap ink and paper
.noreverse
        cp      27
        jr      nz,noCreverse
	jp	$BB9C	; swap ink and paper
.noCreverse
        cp      8
        jr      nz,noinvis
        call	$BB93	; get pen
        ld      (oldattr),a
	call	$BB99	; get paper
	call	$BB90	; set pen
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
	call	$BB90	; set pen
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30
;'' Palette Handling ''
	call	dopal
        call	$BB90	; set pen
        ret
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40
;'' Palette Handling ''
	call	dopal
	call	$BB96	; set paper
.noback
        ret

.dopal
	ld	e,a
	ld	d,0
	ld	hl,ctable
	add	hl,de
	ld	a,(hl)
	ret
.ctable
	defb	5,3,12,1,0,7,2,4
	
;0       Blue                    1
;1       Bright Yellow           24
;2       Bright Cyan             20
;3       Bright Red              6
;4       Bright White            26
;5       Black                   0
;6       Bright Blue             2
;7       Bright Magenta          8
;8       Cyan                    10
;9       Yellow                  12
;10      Pastel blue             14
;11      Pink                    16
;12      Bright Green            18
;13      Pastel Green            22
;
;0 black   5
;1 red     3
;2 green   12-13
;3 yellow  1
;4 blue    0
;5 magenta 7
;6 cyan    2
;7 white   4
