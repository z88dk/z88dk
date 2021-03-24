; Scroll Spectrum/TS2068 up
;
; Relies on ROM routines to perform the scroll
;
; Toggle on __zx_screenmode to determine whether to scroll
; the second display
;

    MODULE  __zx_scrollup

    SECTION code_driver
    PUBLIC  __zx_scrollup
    EXTERN  call_rom3
    EXTERN  __zx_screenmode

    EXTERN  __zx_console_attr
    EXTERN  zx_rowtab

    EXTERN  generic_console_zxn_tile_scrollup

IF FORsam
    defc    NOROMCALLS = 1
    EXTERN  SCREEN_BASE
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
ENDIF

        
__zx_scrollup:
IF FORzxn
    ld      a,(__zx_screenmode)
    bit     6,a
    jp      nz,generic_console_zxn_tile_scrollup
ENDIF
    push    de
    push    bc
        
IF NOROMCALLS
    ; TODO: Do this better without the big table
    ; Code to be used when the original ROM is missing or not available
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    push    ix
    ld      ix,zx_rowtab
    ld      a,8
.outer_loop
    push    af
    push    ix
    ld      a,23
.inner_loop
    ex      af,af
    ld      l,(ix+16)
IF FORsam
    ld      a,(ix+17)
    sub     64 -(SCREEN_BASE / 256) 
    ld      h,a
ELSE
    ld      h,(ix+17)
ENDIF
    ld      e,(ix+0)
IF FORsam
    ld      a,(ix+1)
    sub     64 -(SCREEN_BASE / 256)
    ld      d,a
ELSE
    ld      d,(ix+1)
ENDIF
    ld      bc,32
    ldir
    ld      bc,16
    add     ix,bc
    ex      af,af
    dec     a
    jr      nz,inner_loop
    pop     ix
    pop     af
    inc     ix
    inc     ix
    dec     a
    jr      nz,outer_loop
; clear
    ld      ix,zx_rowtab + (192 - 8) * 2
    ld      a,8
.clear_loop
    ex      af,af
    ld      e,(ix+0)
IF FORsam
    ld      a,(ix+1)
    sub    64 -(SCREEN_BASE / 256) 
    ld      d,a
ELSE
    ld      d,(ix+1)
ENDIF
    ld      h,d
    ld      l,e
    ld      (hl),0
    inc     de
    ld      bc,31
    ldir

    inc     ix
    inc     ix
    ex      af,af
    dec     a
    jr      nz,clear_loop

IF FORsam
    ld      hl,SCREEN_BASE + 6144 + 32
    ld      de,SCREEN_BASE + 6144
ELSE
    ld      hl,22528 + 32
    ld      de,22528
ENDIF
    ld      bc,768-32
    ldir
    ex      de,hl
    ld      d,h
    ld      e,l
    inc     de
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ld      bc,31
    ldir
        
    pop     ix
IF FORsam
    call    __sam_graphics_pageout
ENDIF
    pop     bc
    pop     de
    ret
ELSE
  IF FORts2068 | FORzxn
    ld      a,(__zx_screenmode)
    cp      6    ;Hires
    jr      z,hrgscroll
    cp      2    ;High colour
    jr      z,hrgscroll
    cp      1    ;Screen 1
    jr      z,hrgscroll
  ENDIF
    ld      a,($dff)
    cp      $17
    jr      nz,ts2068_rom
        
    call    call_rom3
    defw    3582    ;scrollup
        
    pop    bc
    pop    de
    ret
        
.ts2068_rom
    call    call_rom3
    defw    $939    ; TS2068 scrollup
    pop    bc
    pop    de
    ret
ENDIF

        

IF FORts2068 | FORzxn
.hrgscroll
    push    ix
    ld      ix,zx_rowtab
    ld      a,8
.outer_loophr
    push    af
    push    ix
    ld      a,(__zx_screenmode)
    ld      b,23
.inner_loophr
    push    bc
    ld      e,(ix+16)
    ld      d,(ix+17)
    ex      de,hl
    ld      e,(ix+0)
    ld      d,(ix+1)
    cp      1
    jr      z,just_screen_1
    push    de
    push    hl
    ld      bc,32
    ldir
    pop     hl
    pop     de
just_screen_1:
    set     5,d
    set     5,h
    ld      bc,32
    ldir
    ld      bc,16
    add     ix,bc
    pop     bc
    djnz    inner_loophr

    pop     ix
    pop     af
    inc     ix
    inc     ix
    dec     a
    jr      nz,outer_loophr
; clear
    ld      ix,zx_rowtab + (192 - 8) * 2
    ld      a,(__zx_screenmode)
    ld      b,8
.clear_loophr
    push    bc
    push    ix
    ld      e,(ix+0)
    ld      d,(ix+1)
    ld      h,d
    ld      l,e
    inc     de
    push    de
    push    hl
    cp      1
    jr      z,clear_screen1_only
    ld      (hl),0
    ld      bc,31
    ldir
; second display
clear_screen1_only:
    pop    hl
    pop    de
    set     5,d
    set     5,h
    cp      4
    ex      af,af
    ld      a,(__zx_console_attr)
    ld      c,a
    ex      af,af
    jr      z,clear_hires2
    ld      c,0
clear_hires2:
    ld      (hl),c
    ld      bc,31
    ldir
    pop     ix
    inc     ix
    inc     ix
    pop     bc
    djnz    clear_loophr
    pop     ix
    pop     bc
    pop     de
    ret
ENDIF
