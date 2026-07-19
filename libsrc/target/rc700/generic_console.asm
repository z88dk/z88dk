;
;

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_ioctl
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  generic_console_printc_incx
    EXTERN  __console_x
    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  RC700_DISPLAY
    EXTERN  CRT_FONT
    EXTERN  rc700_loadfont
    EXTERN  generic_console_font32
    EXTERN  generic_console_caps

    ;; Graphics are hung off the console, so export the required labels
    PUBLIC  __gfx_vram_page_in
    PUBLIC  ___gfx_vram_page_in
    PUBLIC  __gfx_vram_page_out
    PUBLIC  ___gfx_vram_page_out
    PUBLIC  cleargraphics
    PUBLIC  _cleargraphics
    


    INCLUDE "ioctl.def"

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS_MODE0=CAP_GENCON_INVERSE|CAP_GENCON_UNDERLINE
    defc    CLIB_GENCON_CAPS_MODE1=CAP_GENCON_CUSTOM_FONT

    defc    CLIB_GENCON_CAPS = CLIB_GENCON_CAPS_MODE0

    defc    GFXMODE = 132 ; GFXMODE toggle

generic_console_ioctl:
    ex      de, hl                      ;a = ioctl cmd, de = arg ptr -> hl = arg ptr
    ld      c, (hl)                     ;bc = *arg (low, high)
    inc     hl
    ld      b, (hl)
    cp      IOCTL_GENCON_SET_FONT32
    jr      nz, check_mode
    ld      hl, bc
setup_font:
    ld      de, generic_console_caps
    ld      a, h
    or      l
    ld      (rc700_mode), a
    and     a
    ld      a, CLIB_GENCON_CAPS_MODE0
    ld      (de), a
    ret     z 
    ld      a, CLIB_GENCON_CAPS_MODE1
    ld      (de), a
    ld      b, 32
    ld      c, 96
    call    rc700_loadfont
    ld      a, GFXMODE
    ld      (RC700_DISPLAY),a
    and     a
    ret

check_mode:
    cp      IOCTL_GENCON_SET_MODE
    jr      nz, check_cursor
set_mode:
    ld      a, c
    ld      (rc700_mode), a
    and     a
    ld      a, CLIB_GENCON_CAPS_MODE0
    jr      z, set_mode_val
    ld      a, CLIB_GENCON_CAPS_MODE1
set_mode_val:
    ld      (generic_console_caps),a
    call    setgfx
    and     a
    ret

; Hardware cursor control (Intel 8275 CRTC).
; The 8275 has no cursor-disable bit, so "hide" positions it off-screen
; (col=row=255), exactly as crt_init does at startup.  bc on entry to
; rc700_set_hw_cursor holds c=column(X), b=row(Y).
check_cursor:
    cp      IOCTL_GENCON_CURSOR_XY
    jr      z, cursor_xy
    cp      IOCTL_GENCON_CURSOR_ON
    jr      z, cursor_on
    cp      IOCTL_GENCON_CURSOR_OFF
    jr      nz, check_reset
cursor_off:
    ld      bc, $FFFF                   ;off-screen = hidden
    jr      rc700_set_hw_cursor
cursor_on:
    ld      bc, (__console_x)           ;c=col(x), b=row(y) of console
    jr      rc700_set_hw_cursor
cursor_xy:
    ;; bc already = *arg = (row<<8 | col): c=col, b=row
rc700_set_hw_cursor:
    ld      a, DSPLC_CURSOR             ;load-cursor-position command
    out     (DSPLC), a
    ld      a, c
    out     (DSPLD), a                  ;X = column
    ld      a, b
    out     (DSPLD), a                  ;Y = row
    and     a                           ;clear carry = success
    ret

    defc    DSPLC_CURSOR = $80          ; 8275 "load cursor position" command

; Full 8275 CRTC reset: reprogram all screen-composition parameters.
; arg -> unsigned char par[4].  The reset command blanks the display, so we
; re-issue the mandatory re-enable tail (load cursor at current console pos,
; preset counters, start display) exactly as the RC700 firmware does.
; On entry the dispatch pre-read par[0],par[1] into c,b and advanced hl once,
; so hl points at par[1]; dec it back to par[0].
check_reset:
    cp      IOCTL_GENCON_CRT_RESET
    jr      nz, ioctl_failure
crt_reset:
    dec     hl                          ;hl -> par[0]
    xor     a
    out     (DSPLC), a                  ;8275 Reset command (0x00)
    ld      b, 4
crt_reset_param:
    ld      a, (hl)
    out     (DSPLD), a                  ;write par[0..3]
    inc     hl
    djnz    crt_reset_param
    ld      a, DSPLC_CURSOR             ;load cursor position (0x80)
    out     (DSPLC), a
    ld      bc, (__console_x)           ;c=col(x), b=row(y)
    ld      a, c
    out     (DSPLD), a
    ld      a, b
    out     (DSPLD), a
    ld      a, $E0                      ;preset counters
    out     (DSPLC), a
    ld      a, $23                      ;start display: burst=8, space=0
    out     (DSPLC), a
    and     a                           ;clear carry = success
    ret
    
ioctl_failure: 
    scf
generic_console_set_ink:
generic_console_set_paper:
    ret

; Map between gencon attributes and RC700 attributes
generic_console_set_attribute:
    ld      d,(hl)
    ld      a, 128
    bit     7, d
    jr      z, not_inverse
    or      0x10
not_inverse:
    bit     3, d
    jr      z, not_underline
    or      0x20
not_underline:
    bit     4, d
    jr      z, not_bold
    or      0x01
not_bold:
    bit     2, d
    jr      z, not_blink
    or      0x02
not_blink:
    ld      d,a
    ld      a, (rc700_mode)
    and     a
    jr      z, not_semigraphic
    set     2, d
not_semigraphic:
    ld      a, d
    ld      bc, (__console_x)
    push    bc
    call    xypos
    ld      (hl), a
    pop     bc
    jp      generic_console_printc_incx



cleargraphics:
_cleargraphics:
    ;; Swithch to what we term "mode 1"
    ld      a,1
    call    set_mode
    ;; Fall through into cls

generic_console_cls:
    ld      hl, RC700_DISPLAY
    ld      de, RC700_DISPLAY+1
    ld      bc, +(CONSOLE_COLUMNS*CONSOLE_ROWS)-1
    ld      (hl), 32
    ldir
    jp      setgfx

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
    push    af
    call    xypos
    pop     af
    ld      (hl), a
    jp      setgfx


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
    call    xypos
    ld      a, (hl)
    and     a
    ret


xypos:
    ld      hl, RC700_DISPLAY
xypos_doit:
    ld      de, CONSOLE_COLUMNS
    and     a
    sbc     hl, de
    inc     b
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl, bc                      ;hl now points to address in display
    ret


generic_console_scrollup:
    push    de
    push    bc
    ld      hl, RC700_DISPLAY+CONSOLE_COLUMNS
    ld      de, RC700_DISPLAY
    ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-1))
    ld      bc, +((CONSOLE_COLUMNS)*(CONSOLE_ROWS-2))
scrollup_doit:
    ldir
    ex      de, hl
    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    call    setgfx
    pop     bc
    pop     de
    ret

setgfx:
    ld      a, (rc700_mode)
    and     a
    ret     z
__gfx_vram_page_out:
___gfx_vram_page_out:
    ld      a,GFXMODE
    ld      (RC700_DISPLAY),a
__gfx_vram_page_in:
___gfx_vram_page_in:
    ret

    SECTION bss_clib

rc700_mode: 
    defb    0

    
    SECTION code_crt_init

    defc    DSPLC=$01                   ; RC700_DISPLAY CONTROL
    defc    DSPLD=$00                   ; RC700_DISPLAY DATA

; Disable the cursor (push off screen)
    ld      a, $80
    out     (DSPLC), a
    ld      a, 255
    out     (DSPLD), a                  ;X
    out     (DSPLD), a                  ;Y

    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    call    nz,setup_font
