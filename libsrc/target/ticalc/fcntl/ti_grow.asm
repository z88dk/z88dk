; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Ask if HL bytes fit. Carry set when there is not enough free RAM.
; EnoughMem is called before any address is used. CreateAppVar and
; InsertMem do not return when they run out of memory.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_grow
    PUBLIC  ti_shrink
    PUBLIC  ti_create

; HL = bytes that InsertMem will add. Carry set when free RAM is short.
; EnoughMem can delete temporary variables and move every later address,
; so the caller finds the variable again before it uses an address.
ti_grow:
    ld      a, h
    or      l
    ret     z
    TICALL  _EnoughMem
    ret

; HL = bytes to delete, DE = address. A zero length does nothing.
ti_shrink:
    ld      a, h
    or      l
    ret     z
    ex      de, hl
    TICALL  DeleteMem
    or      a
    ret

; OP1 = AppVar name. Creates an empty AppVar.
; HL = symbol entry, DE = size word, A = AppVarObj, B = 0.
; Carry set when there is not enough free RAM.
;
; CreateAppVar takes the payload length. DataSize then counts the size
; word as well, so a payload of zero occupies two bytes and the word is
; zero. Clearing a larger word would leave allocated bytes behind it.
ti_create:
    ld      hl, 64
    TICALL  _EnoughMem
    ret     c
    ld      hl, 0
    TICALL  _CreateAppVar
    xor     a
    ld      (de), a
    inc     de
    ld      (de), a
    dec     de
    ld      a, AppVarObj
    ld      b, 0
    or      a
    ret

ENDIF
