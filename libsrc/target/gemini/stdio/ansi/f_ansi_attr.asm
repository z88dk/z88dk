;
; 	ANSI Video handling for the Gemini Galaxy
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 2022
;
;
;	$Id: f_ansi_attr.asm,v $
;

        SECTION  code_clib
	PUBLIC	ansi_attr

	EXTERN  __gemini_attr
	PUBLIC  INVRS

.ansi_attr
        and     a
        jr      nz,noreset
        ret
.noreset
        cp      1
        jr      nz,nobold
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ret
.nodim
        cp      4
        jr      nz,nounderline
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ret
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


.setbk
        ret

.noinvis
        cp      28
        jr      nz,nocinvis
        ret

.nocinvis
        ret

.nofore
        ret

		
	SECTION  bss_clib
	
	
.INVRS
        defb     0

