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
; $Id: firmware.asm,v 1.7 2016-06-19 21:13:26 dom Exp $
;

        SECTION   code_clib
        PUBLIC firmware
        EXTERN cpc_enable_fw_exx_set, cpc_enable_process_exx_set
 
 firmware:
 
        di
		
		call cpc_enable_fw_exx_set
 
        exx
		
		pop     hl               ; hl = return address
		ld      e,(hl)
		inc     hl
		ld      d,(hl)
		inc     hl
		
		push    hl               ; save return address
		ld      hl,restore
		push    hl
		push    de               ; save firmware address
		
		exx
		
		ei
		ret

restore:

        di
		
		call    cpc_enable_process_exx_set
		
		ei
		ret
