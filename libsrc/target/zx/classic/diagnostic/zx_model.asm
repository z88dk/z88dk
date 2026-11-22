;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/09/2006
;
;	int zx_model();
;
;	The result is:
;	- 0 unknown
;	- 1 if the spectrum is a 48K
;	- 2 if we have a Spectrum 128K or +2
;	- 3 if it is a Spectrum +2A or Pentagon
;	- 4 if it is a Spectrum +3
;	- 5 if it is a Spectrum +2A or +3 fixed for games
;	- 6 TS2068
;	- 7 Scorpion
;	- 8 Profi
;
;	$Id: zx_model.asm $
;

    SECTION code_clib
    PUBLIC  zx_model
    PUBLIC  _zx_model

zx_model:
_zx_model:

check_profi:
    ld      hl, $80
    ld      de, $1000
    ld      bc, $dffd
    out     (c), d                      ; check for port #DFFD bit 4 (on Profi RAM gets paged over the ROM)
    nop

    LD      A, (HL)                     ; read byte
    INC     (HL)                        ; change it
    CP      (HL)                        ; compare with the read
    LD      (HL), A                     ; restore byte
    OUT     (C), E                      ; restore ROM
    JR      Z, no_profi
    ld      hl, 8
    ret

no_profi:
    ld      hl, 0
    ld      a, (8)
    cp      $C3
    jr      z, have_scorpion

    ld      a, (75)
    cp      191
    jr      z, classiclike
    cp      110
    jr      z, newmodels
    cp      225
    ld      l, 6                        ; TS2068
    ret     z
    ld      l, 0
    ret

classiclike:
    ld      l, 1
    ret

newmodels:

    ld      de, 16384
loop0:
    in      a, (255)
    cp      127
    ld      l, 5
    ret     z
    ld      l, 2
    ret     c
    dec     de
    ld      a, d
    or      e
    jr      nz, loop0


    ld      de, 16384
loop:
    ld      bc, $2ffd
    in      a, (c)
    cp      56                          ; If you find ULA related data, then you have a Scorpion like clone
have_scorpion:
    ld      l, 7                        ; sadly you'll never fall here !
    ret     z
    and     a
    ld      l, 2
    ret     z
    cp      128
    ld      l, 4
    ret     z
    cp      255
    jr      nz, plus3                   ; ..or should it be unknown ?
endloop:
    dec     de
    ld      a, d
    or      e
    jr      nz, loop

    in      a, (c)
    cp      255
    ld      l, 3
    ret     z
plus3:
    ld      l, 4
    ret

