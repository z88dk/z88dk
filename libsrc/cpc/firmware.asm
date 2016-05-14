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
; $Id: firmware.asm,v 1.4 2016-05-14 01:02:02 aralbrec Exp $
;

        PUBLIC firmware
        EXTERN cpc_load_fw_exx_set, cpc_save_fw_exx_set
 
 firmware:
 
        exx
		
		pop     hl               ; hl = return address
		ld      c,(hl)
		inc     hl
		ld      b,(hl)
		inc     hl
		
		push    hl               ; save return address
		ld      hl,restore
		push    hl
		push    bc               ; save firmware address
		
		exx
		
		di
		call    cpc_load_fw_exx_set
		ei
		
		ret

restore:

        di
		call    cpc_save_fw_exx_set
		ei
		
		ret
