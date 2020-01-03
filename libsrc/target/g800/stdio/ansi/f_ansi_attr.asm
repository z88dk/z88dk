;
; 	ANSI Video handling for the Sharp PC G-800 family
;
;	Stefano Bodrato - 2019
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;
;
;	$ Id: f_ansi_attr.asm $
;


	SECTION code_clib
	PUBLIC	ansi_attr
	

	; Enabling text attributes costs about extra 480 bytes for the attribute page and the extra code.

	
IF USE_ATTR

;ATTR_REVERSE_MASK=0x01
;ATTR_UNDERLINE_MASK=0x02
;ATTR_BLINK_MASK=0x04
;ATTR_BOLD_MASK=0x08

;;ATTR_KANJIH_MASK=0x10
;;ATTR_KANJIL_MASK=0x20

	EXTERN	g850_attr
	
.g850_attr	defb	0

ENDIF


.ansi_attr

	
IF USE_ATTR
		
		ld	hl,g850_attr
		
        and     a
        jr      nz,noreset
		ld		(g850_attr),a
        ret
.noreset
        cp      1
        jr      nz,nobold
		ld	a,8
		or	(hl)
		ld	(hl),a
        ret
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
		ld	a,$F7		; reset bit 8
		and	(hl)
		ld	(hl),a
        ret
.nodim
        cp      4
        jr      nz,nounderline
		ld	a,2
		or	(hl)
		ld	(hl),a
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
		ld	a,$FD		; reset bit 2
		and	(hl)
		ld	(hl),a
        ret
.noCunderline
        cp      5
        jr      nz,noblink
		ld	a,4
		or	(hl)
		ld	(hl),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
		ld	a,$FB		; reset bit 4
		and	(hl)
		ld	(hl),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
		ld	a,1
		or	(hl)
		ld	(hl),a
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
		ld	a,$FE		; reset bit 4
		and	(hl)
		ld	(hl),a
.noCreverse

ENDIF
        ret
