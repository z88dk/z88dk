;
; Amstrad CPC Specific libraries
;
; Stefano Bodrato - May 2008
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; This function is linked only in the CP/M extension version
; it calls the ROM functions as the base cpc firmware interposer
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; Used internally only
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: cpmfirmware.asm,v 1.4 2016-06-10 21:12:36 dom Exp $
;

        SECTION   code_clib
        PUBLIC firmware



.firmware
        jp      fwjp_setup       ; <- Self modifying code


; This part is run only one time, to setup the above entry

.fwjp_setup
        ld hl,$be9b             ;; Set up Enter_firmware
        ld (firmware+1),hl      ;; for CP/M 2.1 - 2.2
        
        ld c,$0c                ;; BDOS function get CP/M version
        call 5
        ld a,l                  ;; CP/M Version
        cp $31                  ;; C/PM + (C/PM 3.1)?
        jr nz,cpmtst2
        
        ld hl,($0001)
        ld de,$0057
        add hl,de
        ld (firmware+1),hl
.cpmtst2
        jr      firmware

