;
;       Amstrad CPC library
;       Boot CP/M via AMSDOS command
;
;       void go_cpm()
;
;       $Id: go_cpm.asm,v 1.4 2016-06-19 21:13:26 dom Exp $
;

        SECTION   code_clib
        PUBLIC	go_cpm
        PUBLIC	_go_cpm

        INCLUDE "cpcfirm.def"              

.go_cpm
._go_cpm

; |CPM (no parameters)

ld hl,cmd_cpm
call firmware
defw kl_find_command
ret nc

ld (cpm_command),hl     ; store address of function
ld a,c
ld (cpm_command+2),a    ; store "rom select" of function

xor a                   ; no parameters

;rst 3                   ;; KL FAR CALL
rst  $18
defw cpm_command
ret



.cmd_cpm
defb 'C', 'P', 'M'+$80

	SECTION	bss_clib
.cpm_command
defw 0
defb 0
