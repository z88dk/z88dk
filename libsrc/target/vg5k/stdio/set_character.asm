

    MODULE	set_character
    SECTION	code_clib

    PUBLIC  set_character
    EXTERN  __CLIB_FONT_HEIGHT


; Redefine a VG5k character using an 8 high font
;
; Entry: hl = 8 bytes to define
;         c = character to redefine
set_character:
    ex      de,hl
    ld      hl,-10
    add     hl,sp	
    ld      sp,hl
    push    hl
    call    fill
    ld      b,__CLIB_FONT_HEIGHT
loop:
    ld      a,(de)
    ld      (hl),a
    inc     de
    inc     hl
    djnz    loop
    call    fill
    pop     hl
    call    define_character
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    ret

; Fill the top/bottom of a character square
; Inserts (10 - font height) / 2 rows at the current position
; Enter: hl = line
fill:
    ld      a,10
    sub     __CLIB_FONT_HEIGHT
    srl     a
fill_loop:
    and     a
    ret     z
    ld      (hl),0
    inc     hl
    dec     a
    jr      fill_loop

; Set a 10 line character
define_character:
    push    iy
    ld      iy,0x47fa
    ld      a,c
    call    $001b
    pop     iy
    ret
