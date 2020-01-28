; $Id: bit_open_di.asm $
;
; Sound support on the PC-G800 family with speaker mod
;
; void bit_open();
;
; Stefano Bodrato - 2019
;

    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN     __snd_tick
    EXTERN     __bit_irqstatus

    INCLUDE  "games/games.inc"
    
.bit_open_di
._bit_open_di
        
        ld a,i		; get the current status of the irq line
        di
        push af
        
        ex (sp),hl
        ld (__bit_irqstatus),hl
        pop hl
        
          xor	a
          ld   (__snd_tick),a

        ret

