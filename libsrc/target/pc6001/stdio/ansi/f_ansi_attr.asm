;
; 	ANSI Video handling for the PC6001
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Jan 2013
;
;
;	$Id: f_ansi_attr.asm,v 1.3 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_attr

	EXTERN	__pc6001_attr

        SECTION code_clib


reset_attr:
	ld	a,32
set_attr:
	ld	(__pc6001_attr),a
	ret

.ansi_attr
        and     a
	jr	z,reset_attr
.noreset
        cp      1
        jr      nz,nobold
        ld      a,32 + 2
	jr	set_attr
.nobold
        cp      2
        jr      z,reset_attr
        cp      8
	jr	z,reset_attr
.nodim
        cp      5
        jr      nz,noblink
        ld      a,32 + 2
	jr	set_attr
.noblink
        cp      25
	jr	z,reset_attr
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,(__pc6001_attr)
        or      1
	jr	set_attr
.noreverse
        cp      27
        jr      nz,noCreverse
        ld      a,(__pc6001_attr)
        and     254
	jr	set_attr
.noCreverse

        ret
