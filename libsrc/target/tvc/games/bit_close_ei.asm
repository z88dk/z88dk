;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;   based on the work of Stefano Bodrato, games/bit_close_ei.asm
;
;	Closes 1 bit (enable/disable - digital) sound channel for sound.h and 
;   enables interrupts - if they were enabled
;

    SECTION     code_clib
    PUBLIC      bit_close_ei
    PUBLIC      _bit_close_ei
    EXTERN      __snd_tick
    EXTERN      __bit_irqstatus
    INCLUDE     "games/games.inc"

.bit_close_ei
._bit_close_ei
    push    hl
    ld      hl,(__bit_irqstatus)
    ex      (sp),hl
    pop     af
    ret     po      ; parity flag 
    ei
    ret
