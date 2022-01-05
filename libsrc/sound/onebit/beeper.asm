; $Id: beeper.asm,v 1.6 2016-04-23 21:06:31 dom Exp $
;
; Generic 1 bit sound functions
;

    SECTION    code_clib
    PUBLIC     beeper
    PUBLIC     _beeper
    INCLUDE  "games/games.inc"

IF __CPU_GBZ80__ || __CPU_INTEL__
beeper:
_beeper:
    ret
ELSE
    ;EXTERN      bit_open_di
    ;EXTERN      bit_close_ei	
    EXTERN      __snd_tick

;
; Ported by Dominic Morris
; Adapted by Stefano Bodrato
;
; Entry as for Spectrum beeper routine!!
; 
; Direct transfer, of code..no point commenting really
;


.beeper
._beeper
    push	ix
IF SOUND_ONEBIT_port >= 256
    exx
    ld   bc,SOUND_ONEBIT_port
    exx
ENDIF
    ld   a,l
    srl  l
    srl  l
    cpl
    and  3
    ld   c,a
    ld   b,0
    ld   ix,beixp3
    add  ix,bc
    ;call bit_open_di
    ld	a,(__snd_tick)

.beixp3
    nop
    nop
    nop
    inc  b
    inc  c
.behllp   dec  c
    jr   nz,behllp
    ld   c,$3F
    dec  b
    jp   nz,behllp
    xor  SOUND_ONEBIT_mask

    ONEBITOUT


    ld   b,h
    ld   c,a
    bit  SOUND_ONEBIT_bit,a            ;if o/p go again!
    jr   nz,be_again
    ld   a,d
    or   e
    jr   z,be_end
    ld   a,c
    ld   c,l
    dec  de
    jp   (ix)
.be_again
    ld   c,l
    inc  c
    jp   (ix)
.be_end
    pop	ix
    ;call   bit_close_ei
    ret

ENDIF
