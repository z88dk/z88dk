;
;	Fast background restore
;
;	PCW version
;	Stefano, 2021
;
;	$Id: w_bkrestore.asm $
;

  IF    !__CPU_INTEL__
    SECTION smc_clib

    EXTERN  w_pixeladdress
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out


    PUBLIC  bkrestore
    PUBLIC  _bkrestore
    PUBLIC  bkrestore_fastcall
    PUBLIC  _bkrestore_fastcall

bkrestore:
_bkrestore:
    pop     de
    pop     hl
    push    hl
    push    de

bkrestore_fastcall:
_bkrestore_fastcall:


    push    ix
; __FASTCALL__ : sprite ptr in HL

    push    hl
    pop     ix

    ld      l, (ix+2)                   ; x
    ld      h, (ix+3)
    ld      e, (ix+4)                   ; y
	;ld	d,(ix+5)
    ld      d, 0

    ld      (x_coord+1), hl
    ld      c, e

    push    hl

    call    __gfx_vram_page_in
    call    w_pixeladdress
    call    __gfx_vram_page_out

    pop     hl                          ;x0

    ld      a, (ix+0)
    ld      b, (ix+1)

    dec     a
    srl     a
    srl     a
    srl     a
    inc     a
    inc     a                           ; INT ((Xsize-1)/8+2)
    ld      (rbytes+1), a

bkrestores:
    push    bc

rbytes:
    ld      b, 0
rloop:
    ld      a, (ix+6)
    ex      af, af
    call    __gfx_vram_page_in
    ex      af, af
    ld      (de), a
    call    __gfx_vram_page_out

	;inc	de
    ld      d, 0
    ld      e, 8
    add     hl, de
    ld      e, c
    push    hl
    call    __gfx_vram_page_in
    call    w_pixeladdress
    call    __gfx_vram_page_out
    pop     hl

    inc     ix
    djnz    rloop

    ld      d, 0
    ld      e, c
    inc     e                           ; y
x_coord:
    ld      hl, 0
    push    hl
    call    __gfx_vram_page_in
    call    w_pixeladdress
    call    __gfx_vram_page_out
    pop     hl

    pop     bc
    inc     c                           ; y

    djnz    bkrestores
    pop     ix
    ret
  ENDIF
