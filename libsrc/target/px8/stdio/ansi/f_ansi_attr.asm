;
; 	ANSI Video handling for the Epson PX-8
;	By Stefano Bodrato - 2019
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;
;	$Id: f_ansi_attr.asm  $
;

	SECTION code_clib
	
	PUBLIC	ansi_attr

	EXTERN	INVRS
	EXTERN	BOLD
	EXTERN	UNDRLN


.ansi_attr
        and     a
        jr      nz,noreset
        ld	(BOLD),a
        ld	(BOLD+1),a
;        xor     a
        ld      (INVRS),a      ; inverse 0
        ld      a, 6
        ld      (UNDRLN+1),a   ; underline 0
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld	a,23
        ld	(BOLD),a
        ld	a,182
        ld	(BOLD+1),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld	(BOLD),a
        ld	(BOLD+1),a
        ret
.nodim
        cp      4
        jr      nz,nounderline
        inc		a		;ld      a,5
		ld		(UNDRLN+1),a
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a, 6
        ld      (UNDRLN+1),a   ; underline 0
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      (UNDRLN+1),a   ; underline (blink emulation) 1
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a, 6
        ld      (UNDRLN+1),a   ; underline 0  (blink emulation)
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
.noCreverse
        ret
