;
; 	ANSI Video handling for the Galaksija
;	By Stefano Bodrato - 2017
;
; 	Text Attributes (useless unless a font is redefined in ROM)
;	m - Set Graphic Rendition
;
;
;	$Id: f_ansi_attr.asm $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	gal_inverse

	

.ansi_attr
        and     a
        jr      nz,noreset
        ld      (gal_inverse),a
        ret
.noreset
        cp      1
        jr      nz,nobold
	ld	a,128
        ld      (gal_inverse),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld      (gal_inverse),a
        ret
.nodim
        cp      5
        jr      nz,noblink
	ld	a,128
        ld      (gal_inverse),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
	xor	a
        ld      (gal_inverse),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
	ld	a,128
        ld      (gal_inverse),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
	xor	a
        ld      (gal_inverse),a
        ret
.noCreverse

        ret
		
        SECTION bss_clib
	PUBLIC	gal_inverse
.gal_inverse	defb 0

