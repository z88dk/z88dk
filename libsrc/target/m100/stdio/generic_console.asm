

        SECTION         code_clib

        PUBLIC          generic_console_cls
        PUBLIC          generic_console_printc
        PUBLIC          generic_console_scrollup
        PUBLIC          generic_console_set_ink
        PUBLIC          generic_console_set_paper
        PUBLIC          generic_console_set_attribute
	PUBLIC		generic_console_xypos
	PUBLIC		generic_console_ioctl


        EXTERN          CONSOLE_COLUMNS
        EXTERN          CONSOLE_ROWS

        ;EXTERN          generic_console_font32
        ;EXTERN          generic_console_udg32
	;EXTERN		generic_console_flags
	;EXTERN		conio_map_colour

         INCLUDE "ioctl.def"
         PUBLIC  CLIB_GENCON_CAPS
         defc    CLIB_GENCON_CAPS = 0

	INCLUDE "target/m100/def/romcalls.def"

generic_console_ioctl:
	scf
generic_console_set_paper:
generic_console_set_attribute:
generic_console_set_ink:
	ret



generic_console_scrollup:
	push	bc
	push	de
	ld	bc,$0808
	call generic_console_xypos
	ld	a,13
	ROMCALL
	defw	CHROUT
	ld	a,10
	ROMCALL
	defw	CHROUT
	pop	de
	pop	bc
	ret
  
generic_console_cls:
	ROMCALL
	defw	CLS
	ret

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	call generic_console_xypos
	ld	a,d
	ROMCALL
	defw	CHROUT
	ret


; Entry: b = row
;	 c = column
; Exit:	hl = address
generic_console_xypos:
	ld	a,c
	inc a
	ld	($f63a),a	; CSRY
	ld	a,b
	inc a
	ld	($f639),a	; CSRX
	ret

