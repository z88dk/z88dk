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


        SECTION bss_clib
	PUBLIC	pc6001_attr
	
.pc6001_attr	defb 0

        SECTION code_clib

.ansi_attr
        and     a
        jr      nz,noreset
        ld      (pc6001_attr),a
        ret
.noreset
        cp      1
        jr      nz,nobold
        ld      a,2
        ld      (pc6001_attr),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        xor     a
        ld      (pc6001_attr),a
        ret
.nodim
        cp      5
        jr      nz,noblink
        ld      a,2
        ld      (pc6001_attr),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        xor     a
        ld      (pc6001_attr),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,(pc6001_attr)
        or      1
        ld      (pc6001_attr),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld      a,(pc6001_attr)
        and     254
        ld      (pc6001_attr),a
        ret
.noCreverse

        ret
