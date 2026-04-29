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
    PUBLIC      h19_xypos

    EXTERN      CONSOLE_COLUMNS
    EXTERN      CONSOLE_ROWS

    EXTERN      hdos_default

    INCLUDE     "target/hdos/def/hdos.def"
    INCLUDE     "ioctl.def"

    PUBLIC      CLIB_GENCON_CAPS
    defc        CLIB_GENCON_CAPS = CAP_GENCON_INVERSE

generic_console_set_attribute:
        ; Set text attribute (underline, inverse)
    rra
    ld      a,'q'
    jr      nc, noinv
    dec     a
noinv:
    push    af
    ld      a,27
    rst     38h
    defb    SCOUT
    pop     af
    rst     38h
    defb    SCOUT

generic_console_ioctl:
    scf
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

    ld  a,27        ; clear screen/home cursor
    rst    38h
    defb   SCOUT
    ld  a,'E'
    rst    38h
    defb   SCOUT

    ld    a,CONSOLE_ROWS
    cp    25
    jr    nz,no_25
    ld  a,27        ; 25 rows mode
    rst    38h
    defb   SCOUT
    ld  a,'x'
    rst    38h
    defb   SCOUT
    ld  a,1
    rst    38h
    defb   SCOUT
no_25:

    ld  a,27        ;hide cursor
    rst    38h
    defb   SCOUT
    ld  a,'x'
    rst    38h
    defb   SCOUT
    ld  a,5
    rst    38h
    defb   SCOUT

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
    
;    ld  a,27        ; reset 25 rows mode
;    rst    38h
;    defb   SCOUT
;    ld  a,'y'
;    rst    38h
;    defb   SCOUT
;    ld  a,1
;    rst    38h
;    defb   SCOUT

;  ; cursor pos
   ld     a, 27
   rst    38h
   defb   SCOUT
   ld      a, 'Y'
   rst    38h
   defb   SCOUT
   ld     a, 32+23
   rst    38h
   defb   SCOUT
   ld     a, 32
   rst    38h
   defb   SCOUT

    ld a,10
    rst    38h
    defb   SCOUT

    ;ld a,13
    ;rst    38h
    ;defb   SCOUT

    ld    a,CONSOLE_ROWS
    cp    25
    jr    nz,no_forcecopy


    ld    hl,h19_backbuffer+80*23
    ld    b,80
;   ld    c,0
bottom_loop:
    push  hl
    push  bc

    ld    a,(hl)
    cp     128
    jr     c,skip_graphics
    push   af
    ld      a, 27                       ; ESC
    rst     38h
    defb    SCOUT
    ld      a, 'F'                      ; "enter graphics mode"
    rst     38h
    defb    SCOUT
    pop   af
    sub     34                          ; remap to graphics symbols. 128 -> 94, and so on
skip_graphics:

    rst   38h
    defb  SCOUT

    push   af
    ld      a, 27                       ; ESC
    rst     38h
    defb    SCOUT
    ld      a, 'G'                      ; "enter graphics mode"
    rst     38h
    defb    SCOUT
    pop   af

    pop   bc
    pop   hl
    inc   hl
;   inc   c
    djnz  bottom_loop

;  Wipe 25th row
   ld     a, 27
   rst    38h
   defb   SCOUT
   ld      a, 'Y'
   rst    38h
   defb   SCOUT
   ld     a, 32+24
   rst    38h
   defb   SCOUT
   ld     a, 32+0
   rst    38h
   defb   SCOUT

    ld    b,80
bottom_blank:
    push  hl
    ld      a, ' '
    rst    38h
    defb   SCOUT
    pop   hl
    djnz  bottom_blank
    

   

;    ld  a,27        ; 25 rows mode
;    rst    38h
;    defb   SCOUT
;    ld  a,'x'
;    rst    38h
;    defb   SCOUT
;    ld  a,1
;    rst    38h
;    defb   SCOUT

no_forcecopy:

    ;ld a,27
    ;rst 38h
    ;defb SCOUT
    ;ld a,'D'
    ;rst 38h
    ;defb SCOUT

    pop   bc
    pop   hl
    ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:

    push    af
    push    bc
    call    h19_xypos
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
    pop    af
    cp     128
    jr     nc,graphics
    rst    38h
    defb   SCOUT
    ret

graphics:
    push   af
    ld      a, 27                       ; ESC
    rst     38h
    defb    SCOUT
    ld      a, 'F'                      ; "enter graphics mode"
    rst     38h
    defb    SCOUT

    pop     af
    sub     34                          ; remap to graphics symbols. 128 -> 94, and so on
    rst     38h
    defb    SCOUT
    

    ld      a, 27                       ; ESC
    rst     38h
    defb    SCOUT
    ld      a, 'G'                      ; "exit graphics mode"
    rst     38h
    defb    SCOUT
    ret
    

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    h19_xypos
    ld  a,(hl)
    and a
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    call    h19_xypos
    ld      (hl), d
    ret

h19_xypos:
    ld      hl,h19_backbuffer - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret


    SECTION bss_clib

h19_backbuffer:    
    defs    80 * 25


