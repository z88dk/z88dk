; $Id: bit_open.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
;-----
; Stefano Bodrato - digiboost fix for new SID, version 8580

        ld      e,7     ; voice address offset
        ld      bc,$d406
        ld      a,$ff
        out     (c),a   ; Set sustain to $F
        ; add     c,e     ; next voice
	ld	c,$06 + 7 ; next voice
        out     (c),a
        ; add     c,e     ; next voice
	ld	c,$06 + 7 
        out     (c),a
        
        ld      bc,$d404
        ld      a,$49   ; Set SID test bit
        out     (c),a
        ;add     c,e     ; next voice
	ld	c,$04 + 7
        out     (c),a
        ;add     c,e     ; next voice
	ld	c,$04 + 7
        out     (c),a

;-----
        ret
