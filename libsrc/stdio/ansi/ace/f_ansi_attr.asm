;
; 	ANSI Video handling for the Jupiter ACE
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Feb. 2001
;

	XLIB	ansi_attr

	XDEF	ace_inverse
	
.ace_inverse	defb 0

.ansi_attr
        and     a
        jr      nz,noreset
        ld      (ace_inverse),a
        ret
.noreset
        cp      1
        jr      nz,nobold
	ld	a,@10000000
        ld      (ace_inverse),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
	xor	a
        ld      (ace_inverse),a
        ret
.nodim
        cp      5
        jr      nz,noblink
	ld	a,@10000000
        ld      (ace_inverse),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
	xor	a
        ld      (ace_inverse),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
	ld	a,@10000000
        ld      (ace_inverse),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
	xor	a
        ld      (ace_inverse),a
        ret
.noCreverse

        ret
