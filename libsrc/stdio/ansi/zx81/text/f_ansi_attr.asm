;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000 / Oct 2017
;
; 	Text Attributes
;	m - Set Graphic Rendition
;
;
;	$Id: f_ansi_attr.asm $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	zx_inverse

	

.ansi_attr
        and     a
        jr      nz,noreset
        ld      (zx_inverse),a
        ret
.noreset
        cp      1
        jr      nz,nobold
	ld	a,128
        ld      (zx_inverse),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld      (zx_inverse),a
        ret
.nodim
        cp      5
        jr      nz,noblink
	ld	a,128
        ld      (zx_inverse),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
	xor	a
        ld      (zx_inverse),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
	ld	a,128
        ld      (zx_inverse),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
	xor	a
        ld      (zx_inverse),a
        ret
.noCreverse

        ret
		
        SECTION data_clib
	PUBLIC	zx_inverse
.zx_inverse	defb 0

