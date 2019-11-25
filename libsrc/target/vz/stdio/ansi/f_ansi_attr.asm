;
; 	ANSI Video handling for the VZ200
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: f_ansi_attr.asm,v 1.5 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
        SECTION code_clib
	PUBLIC	ansi_attr



.ansi_attr
        and     a
        jr      nz,noreset
        ld      (vz_inverse),a
        ret
.noreset
        cp      1
        jr      nz,nobold
	ld	a,@01000000
        ld      (vz_inverse),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld      (vz_inverse),a
        ret
.nodim
        cp      5
        jr      nz,noblink
	ld	a,@01000000
        ld      (vz_inverse),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
	xor	a
        ld      (vz_inverse),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
	ld	a,@01000000
        ld      (vz_inverse),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
	xor	a
        ld      (vz_inverse),a
        ret
.noCreverse

        ret

        SECTION bss_clib	
	PUBLIC	vz_inverse
.vz_inverse	defb 0
