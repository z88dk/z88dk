
    MODULE  generic_console_ioctl
    PUBLIC  generic_console_ioctl

    SECTION code_clib
    INCLUDE "ioctl.def"

    EXTERN  generic_console_cls
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_cls
    EXTERN  __z88_open_map256
    EXTERN  __z88_open_map512
    EXTERN  __console_w
    EXTERN  CONSOLE_COLUMNS

    EXTERN  generic_console_caps
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAPS_MODE_TEXT


    defc    CAPS_MODE_TEXT=CAP_GENCON_INVERSE|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE
    defc    CAPS_MODE_GFX=CAP_GENCON_INVERSE|CAP_GENCON_CUSTOM_FONT|CAP_GENCON_UDGS|CAP_GENCON_BOLD|CAP_GENCON_UNDERLINE

    INCLUDE "stdio.def"

; a = ioctl
; de = arg
generic_console_ioctl:
    ex      de, hl
    ld      c, (hl)                     ;bc = where we point to
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_set_udg
    ld      (generic_console_font32), bc
success:
    and     a
    ret
check_set_udg:
    cp      IOCTL_GENCON_SET_UDGS
    jr      nz, check_mode
    ld      (generic_console_udg32), bc
    jr      success
check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, failure
    ld      a,c
    and     a
    jp      z,set_mode0
    cp      1
    jp      z,set_mode1
    cp      2
    jp      z,set_mode2
failure:
    scf
    ret

; Text mode, no map
set_mode0:
    ld      hl,full_window
    call_oz (gn_sop)
    ld      hl,reset_window
    call_oz (gn_sop)
    ld      a,CONSOLE_COLUMNS
    ld      (__console_w),a
    ld      a,CAPS_MODE_TEXT
    ld      (generic_console_caps),a
    and     a
    ret


; Text window + 256px map
set_mode1:

    ; TOOD: Open text window
    ld      hl,small_txt_window
    call_oz (gn_sop)
    ld      hl,reset_window
    call_oz (gn_sop)


    call    __z88_open_map256

    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    ld      b,51
    ld      c,CAPS_MODE_TEXT
    jr      z,set_params
    ld      b,32
    ld      c,CAPS_MODE_GFX
set_params:
    ld      a,c
    ld      (generic_console_caps),a
    ld      a,b
    ld      (__console_w),a
    call    generic_console_cls
    and     a
    ret

; 512px map, tiny text window
set_mode2:
    ld      hl,tiny_txt_window
    call_oz (gn_sop)
    ld      hl,reset_tiny_window
    call_oz (gn_sop)
    call    __z88_open_map512
    ld      b,64
    ld      c,CAPS_MODE_GFX
    jr      set_params



    SECTION rodata_clib

full_window:
    defb    1,'7','#','1',32,32,32+80,32+8,128,1,'2','C','1',0

small_txt_window:
    defb    1,'7','#','1',32,32,32+51,32+8,128,1,'2','C','1',0

tiny_txt_window:
    defb    1,'7','#','1',32,32,32+7,32+8,128,1,'2','C','1',0

reset_window:
    defb    1,'2','+','S',1,'2','+','C',0

; Disable the cursor
reset_tiny_window:
    defb    1,'2','+','S',1,'2','-','C',0