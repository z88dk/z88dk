;
; NANOS graphics
;
; Charmap located at 0xf800, organised by rows
;
; Video2 64x32
; Video3 80x24
; Video3 80x25
; Poppe_64x32_80x24 
;
; Poppe graphics also has colour table allocated
;
; Poppe: Toggle between text/colour with port 0xf2, 1
; Poppe: Toggle between 64x32 and 80x24 with port 0xf1, 2
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                PUBLIC          generic_console_plotc
                PUBLIC          generic_console_pointxy
                EXTERN		generic_console_flags

                EXTERN          __console_w
                EXTERN          __console_h
		
		defc		DISPLAY = $f800
       

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = CAP_GENCON_INVERSE

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl,DISPLAY
	ld	de,DISPLAY+1
        ld      bc,(__console_w)
cls1:
        push    bc
        ld      b,0
        ld      (hl),32
        ldir
        pop     bc
        djnz    cls1
        ; TODO: Colour
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
	call	xypos
	ld	(hl),d
	ret

generic_console_printc:
	call	xypos
        ld      a,(generic_console_flags)
        and     128
        or      d
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        call    xypos
	ld	a,(hl)
	and	a
	ret

generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	127
	ret


; b = row
; c = column
;
; Exit: hl = screen position
; Uses: abchl
xypos:
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
        ld      a,(__console_w)
        cp      80
        jr      z,xypos_80col
	add	hl,hl
	add	hl,hl
	ld	b,+(DISPLAY / 256)
	add	hl,bc
	ret

xypos_80col:
        ;Enter in here holding hl = 16 * 32
        ld      a,c   ;Save x position
        ld      c,l
        ld      b,h
	add     hl,hl ;*32
        add     hl,hl ;*64
        add     hl,bc ;*80
        ld      c,a
	ld	b,+(DISPLAY / 256)
	add	hl,bc
	ret
       


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY
        ld      bc,(__console_w)
        ld      b,0
        add     hl,bc
	ld	de, DISPLAY
        ld      bc,(__console_w)
scroll1:
        push    bc
        ld      b,0
        ldir    
        pop     bc
        djnz    scroll1
	ex	de,hl
        ld      b,c         ; c = *__console_w
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
        ; Check for colour mdoe
	pop	bc
	pop	de
	ret
