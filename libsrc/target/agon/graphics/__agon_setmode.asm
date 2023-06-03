
    SECTION code_clib

    PUBLIC  asm_agon_setmode
    EXTERN  __console_h
    EXTERN  __console_w

    EXTERN  __agon_gfxh
    EXTERN  __agon_gfxw
    EXTERN  __agon_putc

    INCLUDE "target/agon/def/mos_api.inc"

; Mode 0 = 1024x768 1bpp 128x96
; Mode 1 = 512x384  4bpp 64x48
; Mode 2 = 320x200  6bpp 40x25
; Mode 3 = 640x480  4bpp 80x60

asm_agon_setmode:
    ld      c,a
    ld      a,22
    call    __agon_putc
    ld      a,c
    call    __agon_putc

    ;Pause
    ld      bc,0
busy:
    push    ix
    pop     ix
    dec     bc
    ld      a,c
    or      b
    jr      nz,busy

get_params:
    ; Now query the parameters
    push    ix
query_again:
    MOSCALL(mos_sysvars)
    defb    $5b     ;LIL
    res     4,(ix+sysvar_vpd_pflags)
    ld      a,23
    call    __agon_putc
    xor     a
    call    __agon_putc
    ld      a,vdp_mode
    call    __agon_putc
ck:
    defb    $5b     ;LIL
   bit     4,(ix+sysvar_vpd_pflags)
   jr      z,ck

   ; This doesn't work on the emulator
    defb    $5b     ;LIL
    ld      a,(ix+sysvar_scrMode)
    cp      c
;    jr      nz,query_again

    defb    $5b     ;LIL
    ld      a,(ix+ sysvar_scrRows)
    ld      (__console_h),a
    defb    $5b     ;LIL
    ld      a,(ix+ sysvar_scrCols)
    ld      (__console_w),a
    defb    $5b, $dd, $27, sysvar_scrWidth      ;ld.lil hl,(ix+sysvar_scrWidth)
    ld      (__agon_gfxw),hl
    defb    $5b, $dd, $27, sysvar_scrHeight     ;ld.lil hl,(ix+sysvar_scrHeight)
    ld      (__agon_gfxh),hl 
    and     a
    pop     ix
    ret

    SECTION rodata_clib

initscr:
    defb    23, 0, $c0, 0       ;Unset logical coordinates
    defb    23, 1, 0            ;Hide cursor

    SECTION code_crt_init

    ld      hl,initscr
    ld      b,7
loop:
    ld      a,(hl)
    call    __agon_putc
    inc     hl
    djnz    loop
