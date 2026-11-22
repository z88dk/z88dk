;
;	Sharp MZ-2500 specific routines
;
;	int mz2500_set_mode(uint8_t mode) __z88dk_fastcall;
;
;	Set the graphics mode and the view registers for the whole screen
;	(start address 0, no horizontal scroll).  Modes: $14 and $15 = 320x200,
;	16 colours (screen A over B / B over A), 40 bytes a line, 8000 bytes a
;	plane.  Both display the four planes of screen A only (mask $0F).
;	Returns 0, or 1 for a mode not supported yet ($17 640x200, $03 640x400
;	and $1D 320x200x256 are not tested).  Text is left alone.
;

    SECTION code_clib
    PUBLIC  mz2500_set_mode
    PUBLIC  _mz2500_set_mode

mz2500_set_mode:
_mz2500_set_mode:
    ld      a,l
    cp      $14
    jr      z,ok
    cp      $15
    jr      z,ok
    ld      hl,1
    ret
ok:
    ld      e,a
    ld      hl,cgtab
    ld      b,(cgtab_end-cgtab)/2
loop:
    ld      a,(hl)
    inc     hl
    out     ($bc),a
    ld      a,(hl)
    inc     hl
    out     ($bd),a
    djnz    loop
    ld      a,$0e
    out     ($bc),a
    ld      a,e
    out     ($bd),a
    ld      hl,0
    ret

cgtab:
    defb    $0f,$00             ; no horizontal scroll
    defb    $10,$00,$11,$00     ; start address 0
    defb    $12,$ff,$13,$7f     ; wrap address (never reached)
    defb    $14,$00,$15,$00
    defb    $16,200,$17,$00     ; first area is all 200 lines
    defb    $08,$00,$09,$00     ; view from line 0
    defb    $0a,200,$0b,$00     ; to line 200
    defb    $0c,$00,$0d,80      ; across the width
    defb    $18,$0f             ; show screen A's four planes only
cgtab_end:
