

    MODULE  generic_console

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  generic_console_printc32
    EXTERN  generic_console_printc64

IF FORhectorhr
    defc    generic_console_printc = generic_console_printc32
ELSE
    defc    generic_console_printc = generic_console_printc64
ENDIF

    EXTERN  generic_console_flags
    EXTERN  conio_map_colour

    EXTERN  __MODE1_attr


    INCLUDE "target/hector/def/hector1.def"


generic_console_set_ink:
    call    conio_map_colour
    and     3
    ld      (__MODE1_attr), a
generic_console_set_attribute:
    ret

generic_console_set_paper:
    call    conio_map_colour
    and     3
    ld      (__MODE1_attr+1), a
    ret



generic_console_cls:
    ld      hl,HEC_SCREEN
    ld      de,HEC_SCREEN+1
    ld      bc,+(HEC_STRIDE * HEC_MAXY) - 1
    ld      (hl),0
    ldir
    ret




IF 0
; 5e8, convert colour to byte
conv_to_byte:
    and       $03                           ;[05e8] e6 03
    push      bc                            ;[05ea] c5
    ld        c,a                           ;[05eb] 4f
    add       a                             ;[05ec] 87
    add       a                             ;[05ed] 87
    add       c                             ;[05ee] 81
    add       a                             ;[05ef] 87
    add       a                             ;[05f0] 87
    add       c                             ;[05f1] 81
    add       a                             ;[05f2] 87
    add       a                             ;[05f3] 87
    add       c                             ;[05f4] 81
    pop       bc                            ;[05f5] c1
    ret
ENDIF

    SECTION code_crt_init

    ; Set the palette to black, blue, red, white
    EXTERN  __hector_reg_0x1000
    EXTERN  __hector_reg_0x1800
    
    ld      a,@00001000         ;p2 = red, p0 = black
    ld      (0x1000),a
    ld      (__hector_reg_0x1000),a
    ld      a,@00111100         ;p3 = white, p1 = blue
    ld      (0x1800),a
    ld      (__hector_reg_0x1800),a

