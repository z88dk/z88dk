;
; We keep a mirrored screen at 0x9000 - 80x24 (bottom line can't be used)
;
;
;

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_pointxy
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  __console_w
    EXTERN  __fp1100_attr
    EXTERN  __fp1100_lores_graphics
    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  conio_map_colour
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32

    defc    DISPLAY = 0x9000

    INCLUDE "target/fp1100/def/fp1100.def"
    INCLUDE "ioctl.def"

generic_console_set_attribute:
    ld      a,(__inverse)
    ld      b,a
    xor     a
    bit     7,(hl)
    jr      z,inverse_off
    inc     a
inverse_off:
    cp      b
    ret     z		;No change to inverse
    ld      (__inverse),a
    ld      a,(__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    ld      (__fp1100_attr),a
    jr      set_colour

generic_console_set_ink:
    call    conio_map_colour
    and     7
    ld      b,a
    ld      a,(__fp1100_attr)
    and     @01110000
    or      b
    ld      (__fp1100_attr),a
set_colour:
	ld      bc,(__fp1100_attr)
	ld      a,SUB_COLOUR
	call    TRNC3
	ret

generic_console_set_paper:
    call    conio_map_colour
    rlca
    rlca
    rlca
    rlca
    and     @01110000
    ld      b,a
    ld      a,(__fp1100_attr)
    and     @00000111
    or      b
    ld      (__fp1100_attr),a
    jr      set_colour

generic_console_cls:
    ld      a,SUB_CLS
    call    TRNC1
    ld      hl,DISPLAY
    ld      de,DISPLAY + 1
    ld      bc, 80 * 25 - 1
    ld      (hl),0
    ldir
    ret

generic_console_scrollup:
    push    de
    push    bc
    ld      a,SUB_SCROLLUP
    call    TRNC1
    ld      hl, DISPLAY + 80
    ld      de, DISPLAY
    ld      bc, 80 * 23
    ldir
    ex      de,hl
    ld      b,80
generic_console_scrollup_3:
    ld      (hl),32
    inc     hl
    djnz    generic_console_scrollup_3
    pop     bc
    pop     de
    ret

print_common:

    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    push    bc
    call    generic_console_xypos
    ld      (hl),a
    pop     bc
    push    af
    ld      (__lastxy),bc
    ld      a,SUB_SETXY
    call    TRNC3
    pop     af
    ld      e,a
    ld      hl,(__fp1100_lores_graphics)
    jr      print_custom_char


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    push    bc
    call    generic_console_xypos
    ld      (hl),a
    pop     bc
    push    af
    ld      hl,__lastxy
    ld      a,(hl)
    inc     a
    cp      c
    jr      nz,set_position
    inc     hl
    ld      a,(hl)
    cp      b
    jr      z,skip_position
set_position:
    ld      (__lastxy),bc
    ld      a,SUB_SETXY
    call    TRNC3
skip_position:
    pop     af
    ld      e,a
    cp      128
    jr      nc,check_udg
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l	
    jr      z,print_char
    dec     h
print_custom_char:
    ex      de,hl
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,de
    ld      de,charbuf
    push    de
    ; The display is mirrored
    ld      b,8
mirror:
    ld      a,(hl)
    ld      c,a
    rlca
    rlca
    xor     c
    and     0xaa
    xor     c
    ld      c,a
    rlca
    rlca
    rlca
    rrc     c
    xor     c
    and     0x66
    xor     c
    ld      (de),a
    inc     de
    inc     hl
    djnz    mirror
    pop     hl		;charbuf
    call    DEFCHR
    ret
check_udg:
    ld      hl,(generic_console_udg32)
    ld      a,h
    or      l
    jr      z,print_char
    res     7,e
    jr      print_custom_char
print_char:
    ld      b,e
    ld      a,SUB_PRINTCHAR
    call    TRNC2
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
generic_console_vpeek:
    call    generic_console_xypos
    ld      a,(hl)
    and     a
    ret

generic_console_xypos:
    ld      hl, DISPLAY - 80
    ld      de,80
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret


	SECTION		bss_clib
__lastxy:	defw	-1
__inverse:	defb	0
charbuf:	defs	8
