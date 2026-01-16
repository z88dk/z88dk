

    SECTION code_clib
    PUBLIC  generic_console_xypos_hector1

    EXTERN  __console_font_h

    INCLUDE "target/hector/def/hector1.def"


generic_console_xypos_hector1:
    ld      a,(__console_font_h)
    cp      6
    jr      z,handle_6_row
    ; 64 column font
    ; This is 8 rows
    ld      hl, HEC_SCREEN
    add     hl, bc                      ;hl = screen
    ret

handle_6_row:
    ; We need to multiple the row by 192
    ; Multiple row by 6
    ld      a,b
    add     a       ;*2
    add     b       ;*3
    add     a       ;*6

    ; Now we need to multiple by 32
    ld      l,a
    ld      h,0
    add     hl,hl       ;*2
    add     hl,hl       ;*4
    add     hl,hl       ;*8
    add     hl,hl       ;*16
    add     hl,hl       ;*32
    ld      b, +(HEC_SCREEN / 256)
    add     hl,bc
    ret



