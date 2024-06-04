
; $Id: w_putsprite.asm $

    SECTION smc_clib

    PUBLIC  putsprite
    PUBLIC  _putsprite

    EXTERN  __zx_screenmode
    EXTERN  __generic_putsprite

    EXTERN  w_pixeladdress
    EXTERN  asm_zx_saddrpdown
    EXTERN  __zx_console_attr

IF    FORts2068|FORzxn
    EXTERN  hl_inc_x_MODE6
    EXTERN  __gfx_fatpix
ENDIF

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


putsprite:
_putsprite:

    ld      a, (__zx_screenmode)
    and     7
    jr      z,fast_putsprite
IF    FORts2068|FORzxn
    cp      6
    jr      z,fast_putsprite
ENDIF

    jp      __generic_putsprite



fast_putsprite:

    push    ix

    ld      hl, 4
    add     hl, sp
    ld      e, (hl)
    inc     hl
    ld      d, (hl)                     ; sprite address
    push    de
    pop     ix

    inc     hl
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      c, (hl)
    inc     hl
    ld      b, (hl)                     ; x and y __gfx_coords

    inc     hl
    ld      a, (hl)                     ; and/or/xor mode
    ld      (ortype+1), a               ; Self modifying code
    ld      (ortype2+1), a              ; Self modifying code

    inc     hl
    ld      a, (hl)
    ld      (ortype), a                 ; Self modifying code
    ld      (ortype2), a                ; Self modifying code

  IF    NEED_swapgfxbk=1
    call    swapgfxbk
  ENDIF
      ; @@@@@@@@@@@@
    ld      h, b
    ld      l, c

;; IF    FORts2068|FORzxn
;;     ld      a, (__gfx_fatpix)
;;     and     a
;;     jr      z, not_fatpix
;; 	
;;     ; TODO: fatpix mode scaling (SMC ?)
;; 
;; not_fatpix:
;; ENDIF

    call    w_pixeladdress
	ld      (_saddr+1), de
	ld      (_saddr1+1), de
      ; @@@@@@@@@@@@
    ld      hl, offsets_table
    ld      c, a
    ld      b, 0
    add     hl, bc
    ld      a, (hl)
    ld      (wsmc1+1), a
    ld      (wsmc2+1), a
    ld      (_smc1+1), a

    ld      h, d
    ld      l, e                        ; display location from pixeladdress

    ld      a, (ix+0)
    cp      9
    jp      nc, putspritew

    ld      d, a
    ld      b, (ix+1)
_oloop:
    push    bc                          ;Save # of rows
    ld      b, d                        ;Load width
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
_smc1:
    ld      a, 1                        ;Load pixel mask
_iloop:
    sla     c                           ;Test leftmost pixel
    jp      nc, _noplot                 ;See if a plot is needed
    ld      e, a
ortype:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
_noplot:
    rrca

    jr      nc, _notedge                ;Test if edge of byte reached

       ;@@@@@@@@@@
       ;Go to next byte
       ;@@@@@@@@@@
IF    FORts2068|FORzxn
    ex      af,af
    ld      a, (__zx_screenmode)
    and     a
    jr      z,_mode0
    call    hl_inc_x_MODE6
    ex      af,af
    jr      _notedge
_mode0:
    ex      af,af
ENDIF
    inc     hl
       ;@@@@@@@@@@

_notedge:
    djnz    _iloop

    push    de
       ;@@@@@@@@@@
       ;Go to next line
       ;@@@@@@@@@@
_saddr:
	ld      hl, 0
    call    asm_zx_saddrpdown
    ld      (_saddr+1), hl
       ;@@@@@@@@@@
    pop     de
    pop     bc                          ;Restore data
    djnz    _oloop

  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

putspritew:
    ld      d, a
    ld      b, (ix+1)
woloop:
    push    bc                          ;Save # of rows
    ld      b, d                        ;Load width
    ld      c, (ix+2)                   ;Load one line of image
    inc     ix
wsmc1:
    ld      a, 1                        ;Load pixel mask
wiloop:
    sla     c                           ;Test leftmost pixel
    jp      nc, wnoplot                 ;See if a plot is needed
    ld      e, a
ortype2:
    nop                                 ; changed into nop / cpl
    nop                                 ; changed into and/or/xor (hl)
    ld      (hl), a
    ld      a, e
wnoplot:
    rrca
    jr      nc, wnotedge                ;Test if edge of byte reached

       ;@@@@@@@@@@
       ;Go to next byte
       ;@@@@@@@@@@
IF    FORts2068|FORzxn
    ex      af,af
    ld      a, (__zx_screenmode)
    and     a
    jr      z,_wmode0
    call    hl_inc_x_MODE6
    ex      af,af
    jr      wnotedge
_wmode0:
    ex      af,af
ENDIF
    inc     hl
       ;@@@@@@@@@@

wnotedge:
wsmc2:
    cp      1
    jp      z, wover_1

    djnz    wiloop

nextline:

    push    de
       ;@@@@@@@@@@
       ;Go to next line
       ;@@@@@@@@@@
_saddr1:
	ld      hl, 0
    call    asm_zx_saddrpdown
    ld      (_saddr1+1), hl
       ;@@@@@@@@@@
    pop     de

    pop     bc                          ;Restore data
    djnz    woloop
  IF    NEED_swapgfxbk
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

wover_1:
    ld      c, (ix+2)
    inc     ix
    djnz    wiloop
    dec     ix

    jr      nextline


    SECTION rodata_clib
offsets_table:
    defb    1, 2, 4, 8, 16, 32, 64, 128

