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
;	$Id: f_ansi_attr.asm,v 1.6 2016-06-12 16:06:42 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr

    INCLUDE "cpcfirm.def"

        SECTION bss_clib
	PUBLIC	UNDRL

.UNDRL  defb 0

        SECTION code_clib

.ansi_attr
        and     a
        jr      nz,noreset
        xor     a
        ld      (UNDRL),a   ; underline 0
        ld      a,2             ; ink bright cyan
        call    firmware
        defw    txt_set_pen
        xor     a               ; paper blue
        call    firmware
        defw    txt_set_paper
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld      a,1             ; ink bright yellow
        call    firmware
        defw    txt_set_pen
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim    ld      a,2             ; ink bright cyan
        call    firmware
        defw    txt_set_pen
        ret
.nodim  cp      4
        jr      nz,nounderline
        ld      a,1
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
        call    firmware
        defw    txt_get_pen
        xor     3
        call    firmware
        defw    txt_set_pen
        ret
.noblink
        cp      25
        jr      nz,nocblink
        call    firmware
        defw    txt_get_pen
        xor     3
        call    firmware
        defw    txt_set_pen
        ret
.nocblink
        cp      7
        jr      nz,noreverse
.callinverse
	call    firmware
        defw	txt_inverse
        ret
.noreverse
        cp      27
        jr      z,callinverse
.noCreverse
        cp      8
        jr      nz,noinvis
        call    firmware
        defw    txt_get_pen
        ld      (oldattr),a
        call    firmware
        defw    txt_get_paper
        call    firmware
        defw    txt_set_pen
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        call    firmware
        defw    txt_set_pen
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30
;'' Palette Handling ''
        call	dopal
        call    firmware
        defw    txt_set_pen
        ret
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40
;'' Palette Handling ''
        call	dopal
        call    firmware
        defw    txt_set_paper
.noback ret

.dopal
        ld      e,a
        ld      d,0
        ld      hl,ctable
        add     hl,de
        ld      a,(hl)
        ret
.ctable defb	5,3,12,1,0,7,2,4
	
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
