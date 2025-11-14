

    INCLUDE "classic/video/mc6847/mc6847.inc"


    SECTION code_driver
    
    PUBLIC  generic_console_gfx_xypos_MODE1
    PUBLIC  generic_console_gfx_xypos_MODE2

    EXTERN  __console_font_h

; Entry: b = row
;        c = column
; Exit: hl = screen address
generic_console_gfx_xypos_MODE2:
    sla     c      
generic_console_gfx_xypos_MODE1:   
    ld      a,(__console_font_h)
    cp      6
    jr      z,handle_6
IF MC6857_SUPPORT_8x4_FONT
    cp      4
    jr      z,handle_4
ENDIF
    ;; Just fall through to 8
handle_8:          
    GETSCREENADDRESS
    add     hl,bc
    ret

IF MC6857_SUPPORT_8x4_FONT
handle_4:
    ; We need to multiple the row by 128
    ld      h,b
    ld      l,0
    srl     h
    rr      l
    ld      b,0
    add     hl,bc
    GETSCREENADDRESS_bc
    add     hl,bc
    ret
ENDIF

handle_6:
    ; We need to multiple the row by 192
    ld      a,c         ;Keep the column safe
    ld      l,b
    ld      h,0
    add     hl,hl       ;*2
    add     hl,hl       ;*4
    add     hl,hl       ;*8
    add     hl,hl       ;*16
    add     hl,hl       ;*32
    ld      bc,hl
    add     hl,hl       ;*64
    add     hl,bc       ;*96
    add     hl,hl       ;*192
    GETSCREENADDRESS_bc
    ld      c,a
    add     hl,bc
    ret
    
