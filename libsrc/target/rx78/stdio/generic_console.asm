;
; Display has 2 screens - VRAM planes 0,1,2 and 3,4,5 
;
; Screen 0 takes palette 0-7, screen 1 palette 8-15
;
; If both screens are not set, then background colour palette[16] is taken
;
; We'll use through z88dk. screen 0 for ink, screen 1 for paper
;
;

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    PUBLIC  generic_console_xypos_graphics

    EXTERN  generic_console_flags
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  conio_map_colour

    EXTERN  __rx78_ink
    EXTERN  __rx78_paper

    EXTERN  CRT_FONT
    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    defc    DISPLAY = 0xEEC0


generic_console_set_ink:
    call    conio_map_colour
    and     7
    ld       (__rx78_ink),a
    ret

    
generic_console_set_paper:
    call    conio_map_colour
    rlca
    rlca
    rlca
    and     @00111000
    ld      (__rx78_paper),a
    ret

generic_console_set_attribute:
    ret

generic_console_cls:
    ld      a,@00111111
    out     ($f2),a
    ld      a,1    ;We'll just read from plane 0
    out     ($f1),a
    ld      hl, DISPLAY
    ld      de, DISPLAY+1
    ld      bc, +(CONSOLE_ROWS * CONSOLE_COLUMNS * 8) -1
    ld      (hl),0
    ldir
    ; TODO: Set default background
    ret



; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
    call    generic_console_xypos_graphics
    ex      de,hl    ;de = destination
    ld      bc,(generic_console_font32)
    ld      l,a
    ld      h,0
    bit     7,l
    jr      z,not_udg
    res     7,l
    ld      bc,(generic_console_udg32)
    inc     b
not_udg:
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    dec     h    ;-32 characters
    ex      de,hl    ;hl = screen, de = font
    exx
    ld      bc,(__rx78_ink)
    ld      a,c
    cpl
    and     @00000111
    ld      b,a    ;Reset ink
    ld      de,(__rx78_paper)
    ld      a,e
    cpl
    and     @00111000
    ld      d,a
    exx
    ld      a,(generic_console_flags)
    rlca
    sbc     a
    ld      c,a    ;c = 0/c = 255 = inverse
    ld      a,8
loop:    
    push    af
    push    bc    ;save inverse flag
    ld      a,(generic_console_flags)
    bit     4,a
    ld      a,(de)
    jr      z,not_bold
    ld      b,a
    rrca
    or      b
not_bold:
    xor    c
    ld    c,a    ;c = byte to print
    ld    a,d
    cp    $20    ;If font < 8192, then it's in ROM and mirrored
    ld    a,c
    jr    c,rom_font
    ; Mirror for RAM fonts
    rlca
    rlca
    xor    c
    and    0xaa
    xor    c
    ld    c,a
    rlca
    rlca
    rlca
    rrc    c
    xor    c
    and    0x66
    xor    c
rom_font:
    exx        ;Switch to planes
    ex    af,af    ;Save byte for a bit
    ld    a,c    ;ink set
    out    ($f2),a
    ex    af,af    ;Back to byte
    exx        ;Mem pointers
    ld    (hl),a
    ex    af,af    ;Save byte
    exx        ;Planes
    ld    a,b    ;Unset pages
    out    ($f2),a
    exx        ;Mem pointers
    ld    (hl),0

    ; Now we need to consider paper side
    ex    af,af
    cpl        ;We need the inverse
    exx        ;Planes
    ex    af,af
    ld    a,e
    out    ($f2),a
    ex    af,af    ;Byte
    exx        ;Mem
    ld    (hl),a
    exx        ;Planes
    ld    a,d    ;Unset
    out    ($f2),a
    exx        ;Mem
    ld    (hl),0
    

    ld    bc,24
    add    hl,bc
    inc    de
    pop    bc
    pop    af
    dec    a
    jr    nz,loop
    ret


; Calculate the address for the graphics mode
generic_console_xypos_graphics:
    ld    hl, DISPLAY - 192
    ld    de, 192
    inc    b
generic_console_xypos_graphics_1:
    add    hl,de
    djnz    generic_console_xypos_graphics_1
    add    hl,bc
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld    b,6
    ld    c,@00000001
scroll_loop:
    push    bc
    ld    a,c
    out    ($f2),a    ;Page to write
    ld    a,7
    sub    b
    out    ($f1),a    ;Page to read
    ld    hl, DISPLAY + 24 * 8
    ld    de, DISPLAY
    ld    bc, 24 * 22 * 8
    ldir
    ex    de,hl
    ld    b, 24 * 8
scroll_loop_2:
    ld    (hl),0
    inc    hl
    djnz    scroll_loop_2
    pop    bc
    sla    c
    djnz    scroll_loop
    pop    bc
    pop    de
    ret



