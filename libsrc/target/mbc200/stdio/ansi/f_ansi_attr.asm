;
; 	ANSI Video handling for the Sanyo computers
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
;	$Id: f_ansi_attr.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_attr

	EXTERN  __sanyo_attr

.ansi_attr
        and     a
        jr      nz,noreset
		ld      (__sanyo_attr),a
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
		ld		a,(__sanyo_attr)
		set		1,a
		ld		(__sanyo_attr),a
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
		ld		a,(__sanyo_attr)
		res		1,a
		ld		(__sanyo_attr),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
		ld		a,9
		ld		(__sanyo_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
		xor		a
		ld		(__sanyo_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
		ld		a,(__sanyo_attr)
		set		2,a
		ld		(__sanyo_attr),a
		ret
.noreverse
        cp      27
        jr      nz,noCreverse
		ld		a,(__sanyo_attr)
		res		2,a
		ld		(__sanyo_attr),a
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

