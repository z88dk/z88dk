;
; Print a character for the ZX/TS2068 screen
;

    MODULE  generic_console_printc
    
    SECTION code_driver
    PUBLIC  generic_console_printc
        
    EXTERN  __zx_console_attr
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  __zx_64col_font
    EXTERN  __console_w
    EXTERN  __zx_printc32
    EXTERN  __zx_printc64
    EXTERN  generic_console_flags
    EXTERN  __zx_screenmode
    EXTERN  __zx_mode0_console_w
    EXTERN  __zx_print_routine
    EXTERN  generic_console_zxn_tile_printc
    EXTERN  __sam_printc

IF FORsam
    EXTERN  SCREEN_BASE
ENDIF

; Entry:
;  a = charcter
; hl = expect_flags
handle_controls:
    ; Extra codes
    cp      18
    ld      d,1
    jr      z,start_code
    ld      d,2
    cp      19
    jr      z,start_code
    ld      d,16
    cp      1
    jr      z,start_code
    cp      2
    ret     nz
    ld      d,12
start_code:
    ld      a,(hl)
    or      d    
    ld      (hl),a
    ret

set_flash:
    res     0,(hl)
    ld      hl,__zx_console_attr
    res     7,(hl)
    rrca
    ret     nc
    set     7,(hl)
    ret

set_bright:
    res     1,(hl)
    ld      hl,__zx_console_attr
    res     6,(hl)
    rrca
    ret     nc
    set     6,(hl)
    ret

set_switch:
    res     4,(hl)
    ld      hl,__zx_printc32
    cp      64
    ld      de,$4020
    jr      nz,set_switch1
    ld      hl,__zx_printc64
    ld      de,$8040
set_switch1:
IF FORsam
    ; For SAM we only support 64column printing in mode0
    ld      a,(__zx_screenmode)
    and     a
    ret     nz
ENDIF
IF FORts2068|FORzxn
    ; In the Timex hires mode, we need to double the number of columns
    ld      a,(__zx_screenmode)
  IF FORzxn
    ; When in tilemap mode, we can't switch between 64/32
    bit     6,a
    ret     nz
  ENDIF
    cp      6
    ld      a,d
    jr      z,set_width
ENDIF
    ld      a,e
set_width:
    ld      (__zx_print_routine),hl
    ld      ( __console_w),a
IF FORts2068|FORzxn|FORsam
    ld      ( __zx_mode0_console_w),a
ENDIF
    ret

set_font_hi:
    res     2,(hl)
    ld      (__zx_32col_font+1),a
    ret
set_font_lo:
    res     3,(hl)
    ld      (__zx_32col_font),a
    ret


; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
    rr      e
    jr      c,skip_control_codes
    ld      hl,expect_flags
    bit     0,(hl)
    jr      nz,set_flash
    bit     1,(hl)
    jr      nz,set_bright
    bit     2,(hl)
    jr      nz,set_font_hi
    bit     3,(hl)
    jr      nz,set_font_lo
    bit     4,(hl)
    jr      nz,set_switch
    cp      32
    jp      c,handle_controls
skip_control_codes:
IF FORsam
    ld      a,(__zx_screenmode)
    and     a
    jp      nz,__sam_printc
ELIF FORzxn
    ld      a,(__zx_screenmode)
    bit     6,a
    jp      nz,generic_console_zxn_tile_printc
ENDIF
    ld      hl,(__zx_print_routine)
    jp      (hl)

    SECTION bss_driver

expect_flags:    defb    0        
            ; bit 0 - expect flash
            ; bit 1 - expect bright
            ; bit 2 - expect font low
            ; bit 3 - expect font high
            ; bit 4 - expect switch


    SECTION code_crt_init

    ; If we've forced 32 column mode at the crt0 level, then
    ; switch to it
    EXTERN  __CLIB_ZX_CONIO32
IF FORsam
    ld      hl,__zx_printc64
    ld      (__zx_print_routine),hl
    ld      a,64
    ld      (__zx_mode0_console_w),a
ELSE
    ld      a,__CLIB_ZX_CONIO32
    and     a
    ld      a,64
    ld      hl,__zx_printc64
    jr      z,no_set_32col
    ld      a,32
    ld      hl,__zx_printc32
no_set_32col:
    ld      (__zx_print_routine),hl
    ld      (__console_w),a
  IF FORts2068|FORzxn
    ld      (__zx_mode0_console_w),a
  ENDIF
ENDIF
