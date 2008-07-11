; $Id: bit_open.asm,v 1.1 2008-07-11 15:10:57 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
;-----
; Stefano Bodrato - digiboost fix for new SID, version 8580

        ld      e,7     ; voice address offset
        ld      bc,$d406
        ld      a,$ff
        out     (c),a   ; Set sustain to $F
        add     c,e     ; next voice
        out     (c),a
        add     c,e     ; next voice..
        out     (c),a
        
        ld      bc,$d404
        ld      a,$49   ; Set SID test bit
        out     (c),a
        add     c,e     ; next voice
        out     (c),a
        add     c,e     ; next voice..
        out     (c),a

;-----
        ret
