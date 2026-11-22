;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int psg_init();
;
;	Set up the PSG - most of the existing interfaces are supported
;
;
;	$Id: psg_init.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

    SECTION code_clib
    PUBLIC  psg_init
    PUBLIC  _psg_init
    EXTERN  zx_soundchip
    EXTERN  asm_set_psg


psg_init:
_psg_init:

    call    zx_soundchip
    ld      a, l
    cp      3                ; TS2068 or TC2068 ?
    jr      nz,no_ts2068     ; no
    ld      hl,$fff5
    ld      bc,$fff6
    jr      altmode          ; we have an internal AY in a TS2068
no_ts2068:

    and     a                ; Fuller if nothing detected, set MSB to zero to tell we also poke around
    ld      hl, $003f        ; select + read  (zero in MSB)
    ld      bc, $005f        ; write  (foo MSB)
    jr      z, altmode

    dec     a
    jr      z, zx128mode
    ld      hl, $ffff        ; select register, read is on ($BF)
    ld      bc, $ffdf        ; write  (foo MSB in addresses)
    jr      altmode          ; we're in Microdigital mode or external Timex AY


zx128mode:
    ld      hl, $fffd        ; select + read
    ld      bc, $bffd        ; write

altmode:
    ld      (__psg_select_and_read_port), hl
    ld      (__psg_write_port), bc

do_init:
    ld      e, @01010101
    xor     a                           ; R0: Channel A frequency low bits
    call    outpsg

    ld      e, a

    ld      d, 12
psg_iniloop:
    inc     a                           ; R1-13: set all to 0 but 7 and 11
    cp      7
    jr      z, skip
	;cp 11
	;jr z,skip
    call    outpsg
skip:
    dec     d
    jr      nz, psg_iniloop

    ld      e, @11111000                ; R7: Channel setting.  Enable sound channels ABC and input on ports A and B
    ld      a, 7
    call    outpsg

    ld      e, @00001011                ; R11: Envelope
    ld      a, 11

outpsg:
    ld      l, a
	jp asm_set_psg


    SECTION bss_clib
    PUBLIC  __psg_select_and_read_port
    PUBLIC  __psg_write_port

__psg_select_and_read_port:
    defw    0
__psg_write_port:
    defw    0
