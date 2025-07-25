;   Graphics library for the Amstrad NC
;   Stefano - 2017

    SECTION code_clib
    PUBLIC  w_pixeladdress

    EXTERN  NC_VRAM

    INCLUDE "graphics/grafix.inc"
;
;       $Id: w_pixladdr.asm $
;
; ******************************************************************
; Get absolute  pixel address in map of virtual (x,y) coordinate.
; in: (x,y) coordinate of pixel (hl,de)
;
; out: de       = address of pixel byte
;          a    = bit number of byte where pixel is to be placed
;         fz    = 1 if bit number is 0 of pixel position
;
; registers changed     after return:
;  ......../ixiy same
;  afbcdehl/.... different

w_pixeladdress:

    ld      b, h
    ld      c, l

    ld      l, e                        ;hl = y
    ld      h, d

    add     hl, hl                      ;hl = y * 64
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl

    ld      e, c                        ;de = x
    ld      d, b

    srl     d                           ;de = x / 8
    rr      e
    srl     d
    rr      e
    srl     d
    rr      e

    add     hl, de                      ;hl = (y * 64) + (x / 8)
    ld      de, NC_VRAM
    add     hl, de

    ld      a, c                        ;a = x low byte
    and     07h                         ;a = x mod 8

    ld      d, h
    ld      e, l

    xor     7

    ret
