;
; Amstrad CPC Specific libraries
;
; Stefano Bodrato - May 2008
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Firmware interposer
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Used internally only
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: firmware.asm,v 1.1 2008-05-09 10:38:33 stefano Exp $
;

        XLIB firmware
        XREF firmware_bc
        
.firmware
        exx                      ; Use alternate registers
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc               ; firmware location to jump to first
        ld      bc,(firmware_bc)
        exx                      ; Back to the regular set
        ret                      ; And call the firmware routine
