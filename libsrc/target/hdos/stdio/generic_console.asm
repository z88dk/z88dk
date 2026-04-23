;
; Generic console that maps into "VT52" terminal codes
; HDOS version (the Heath/Zenith H19 was a VT52 superset)
;
; We maintain a "back screen" so that vpeek will work
; 


    MODULE      generic_console_h19
    SECTION     code_clib

    PUBLIC      generic_console_cls
    PUBLIC      generic_console_vpeek
    PUBLIC      generic_console_scrollup
    PUBLIC      generic_console_printc
    PUBLIC      generic_console_ioctl
    PUBLIC      generic_console_set_ink
    PUBLIC      generic_console_set_paper
    PUBLIC      generic_console_set_attribute
    PUBLIC      generic_console_plotc
    PUBLIC      h19_backbuffer

    EXTERN      CONSOLE_COLUMNS
    EXTERN      CONSOLE_ROWS

    EXTERN      hdos_default

    INCLUDE     "target/hdos/def/hdos.def"
    INCLUDE     "ioctl.def"

    PUBLIC      CLIB_GENCON_CAPS
    defc        CLIB_GENCON_CAPS = 0

generic_console_ioctl:
    scf
generic_console_set_attribute:
    ret

generic_console_set_ink:
    ret

generic_console_set_paper:
    ret

generic_console_cls:

    LD   A, I_CONWI     ; "Console Width" attribute index
    LD   B, 255         ; No WIDTH constraints = 255
    LD   C, 0xFF        ; mask
    RST  38h
    DEFB CONSL

    LD   A, I_CONTY     ; No character translation to terminal
    LD   B, 0
    LD   C, 0xFF        ; mask
    RST  38h
    DEFB CONSL

    ld  hl,h19_backbuffer
    ld  de,h19_backbuffer+1
    ld  bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS) - 1
    ld  (hl),0
    ldir

    ld  a,27        ;clear screen/home cursor
    rst    38h
    defb   SCOUT
    ld  a,'E'
    rst    38h
    defb   SCOUT

; TODO: hiding the cursor messes up the "output buffer"
;       i.e. the missing printed characters are displayed in the following output

;   ; CHARACTER MODE
;   LD    A, I_CSLMD
;   LD    B, CSL_CHR
;   LD    C, CSL_CHR
;   RST  38h
;   DEFB CONSL
;
;   ld  a,27        ;hide cursor
;   rst    38h
;   defb   SCOUT
;   ld  a,'x'
;   rst    38h
;   defb   SCOUT
;   ld  a,'5'
;   rst    38h
;   defb   SCOUT

    ret

generic_console_scrollup:
    push    de
    push    bc
    ld  hl,h19_backbuffer + CONSOLE_COLUMNS
    ld  de,h19_backbuffer
    ld  bc,+((CONSOLE_ROWS-1) * CONSOLE_COLUMNS)
    ldir
    ex  de,hl
    ld  b,CONSOLE_COLUMNS
cls_1:
    ld  (hl),32
    inc hl
    djnz    cls_1
    ;ld a,10
    ;rst    38h
    ;defb   SCOUT
    ;ld a,13
    ;rst    38h
    ;defb   SCOUT

    
    ld a,27
    rst 38h
    defb SCOUT
    ld a,'D'
    rst 38h
    defb SCOUT

    pop bc
    pop hl
    ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    push    af
    push    bc
    call    xypos
    ld      (hl),a
;
;   ; cursor home
    ld      a, 27
    rst    38h
    defb   SCOUT
    ld      a, 'H'
    rst    38h
    defb   SCOUT

;    pop    bc
;    push   bc
;
;    xor a
;    or b
;    jr z,row0
;yloop:
;    xor a
;    rst    38h
;    defb   SCOUT
;    push   bc
;    ld     a, 27
;    rst    38h
;    defb   SCOUT
;    ld      a, 'B'
;    rst    38h
;    defb   SCOUT
;    pop    bc
;    dec b
;    jr nz,yloop
;
;row0:
;
;    pop    bc
;    xor a
;    or c
;    jr z,column0
;xloop:
;    xor a
;    rst    38h
;    defb   SCOUT
;    push   bc
;    ld     a, 27
;    rst    38h
;    defb   SCOUT
;    ld      a, 'C'
;    rst    38h
;    defb   SCOUT
;    pop    bc
;    dec c
;    jr nz,xloop
;
;column0:


   ; cursor pos
    ld     a, 27
    rst    38h
    defb   SCOUT
    ld      a, 'Y'
    rst    38h
    defb   SCOUT

    pop    bc
    push   bc
    ld     a,32
    add    b
    rst    38h
    defb   SCOUT

    pop    bc
    ld     a,32
    add    c
    rst    38h
    defb   SCOUT

    ; send actual character
    pop     af
    rst    38h
    defb   SCOUT
    ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld  a,(hl)
    and a
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    call    xypos
    ld      (hl), d
    ret

xypos:
    ld      hl,h19_backbuffer - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret



    SECTION data_clib

xy_sequence:
    defb    27
    defb    'Y'
    defb    0
xy_sequence_bottom:
    defb    0
;prchar_char:
    defb    255



    SECTION bss_clib

h19_backbuffer:    
    defs    80 * 25


