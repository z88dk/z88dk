;
; 	ANSI Video handling for the MSX
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Sept. 2017
;
;
;	$Id: f_ansi_attr.asm $
;

        SECTION code_video_vdp
	PUBLIC	ansi_attr
	EXTERN	__tms9918_attribute
	EXTERN	INVRS
	EXTERN	BOLD


.ansi_attr
        and     a
        jr      nz,noreset
        ld	(BOLD),a
        ld	(BOLD+1),a
        ld      a,$F1
        ld      (__tms9918_attribute),a
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
        ld      a,(__tms9918_attribute)
        or      @10000000
        ld      (__tms9918_attribute),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(__tms9918_attribute)
        and     @01111111
        ld      (__tms9918_attribute),a
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
        cp      8
        jr      nz,noinvis
        ld      a,(__tms9918_attribute)
        ld      (oldattr),a
        and     @1111
        ld      e,a
        rla
        rla
        rla
        rla
        or      e
        ld      (__tms9918_attribute),a
        ret
.oldattr
        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        ld      (__tms9918_attribute),a
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore
        sub     30

;'' Palette Handling ''
        and     7
;''''''''''''''''''''''
		inc a	;(1,3,5,7: black, green, blue, cyan)
		bit 0,a
		jr nz,odd_code
		add 7	; (2,4,6,8 -> 9,11,13,15; red, yellow, magenta, white)
.odd_code
        rla
        rla
        rla
        rla
        ld      e,a
        ld      a,(__tms9918_attribute)
        and     @00001111
        or      e
        ld      (__tms9918_attribute),a 

.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback
        sub     40

;'' Palette Handling ''
        and     7
;''''''''''''''''''''''
		inc a	;(1,3,5,7: black, green, blue, cyan)
		bit 0,a
		jr nz,odd_attr
		add 7	; (2,4,6,8 -> 9,11,13,15; red, yellow, magenta, white)
.odd_attr
        ld      e,a
        ld      a,(__tms9918_attribute)
        and     @11110000
        or      e
        ld      (__tms9918_attribute),a
        ret

.noback
        ret

