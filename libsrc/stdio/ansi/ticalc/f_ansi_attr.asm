;
; 	ANSI Video handling for the TI calculators
;	By Stefano Bodrato - Dec. 2000
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;
;	$Id: f_ansi_attr.asm,v 1.5 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	INVRS

.ansi_attr
;        and     a
;        jr      nz,noreset
;        ret
;.noreset
;        cp      1
;        jr      nz,nobold
;        ret
;.nobold
;        cp      2
;        jr      z,dim
;        cp      8
;        jr      nz,nodim
.dim
;        ret
;.nodim
        cp      4
        jr      nz,nounderline
        ld      a,32
        ld      (INVRS+2),a   ; underline 1
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a, 24
        ld      (INVRS+2),a   ; underline 0
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,32
        ld      (INVRS+2),a   ; underline (blink emulation) 1
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a, 24
        ld      (INVRS+2),a   ; underline (blink emulation) 0
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,47
        ld      (INVRS),a     ; inverse 1
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        xor     a
        ld      (INVRS),a      ; inverse 0
        ret
.noCreverse
        ret
