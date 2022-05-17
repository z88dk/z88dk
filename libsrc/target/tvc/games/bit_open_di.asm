;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;   based on the work of Stefano Bodrato, games/bit_open_di.asm
;
;	Opens 1 bit (enable/disable - digital) sound channel for sound.h and disables interrupts
;

    SECTION     code_clib
    PUBLIC      bit_open_di
    PUBLIC      _bit_open_di
    EXTERN		bit_open
    EXTERN      __snd_tick
    EXTERN      __bit_irqstatus

    INCLUDE     "games/games.inc"
    
.bit_open_di
._bit_open_di
    ld      a,i     ; IFF1 value is copied into the parity (P/V) flag
    di 
    push    af
    ex      (sp), hl
    ld      (__bit_irqstatus),hl
    pop     hl
    jp      bit_open