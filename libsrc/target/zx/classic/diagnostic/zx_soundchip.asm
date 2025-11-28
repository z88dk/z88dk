;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_soundchip();
;
;	The result is:
;	- 2 (true) if the AY chip has a "brazilian" configuration
;	- 1 (true) if a standard AY sound chip is present
;	- 0 (false) otherwise
;
;   The type 2 includes TK90X/TK95, and Brazilian "Timex AY" interfaces
;  
;
;	$Id: zx_soundchip.asm $
;

    SECTION code_clib
    PUBLIC  zx_soundchip
    PUBLIC  _zx_soundchip

zx_soundchip:
_zx_soundchip:

    ; Look for microdigital I/O mapping
    ld      hl, 2
    ld      bc, $00ff
    ld      a, 11                       ; envelope register
    out     (c), a

    ld      c, $bf
    in      a, (c)
    ld      e, a

    xor     170
    ld      c, $df
    out     (c), a

    ld      d, a
    ld      c, $bf
    in      a, (c)
    cp      d

    ld      c, $df
    ld      a, e
    out     (c), a                      ; restore original value
    ret     z


    ; Look for classic I/O mapping
    ld      l, 0
    ld      bc, $fffd
    ld      a, 11                       ; envelope register
    out     (c), a

    in      a, (c)
    ld      e, a

    xor     170
    ld      b, $bf
    out     (c), a
    ld      b, $ff
    ld      d, a
    in      a, (c)
    cp      d

    ld      b, $bf
    ld      a, e
    out     (c), a                      ; restore original value
	ret     nz

    inc     hl
    ret
