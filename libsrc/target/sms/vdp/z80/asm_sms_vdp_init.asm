; void sms_vdp_init(void *vdp_register_array)
; from SMSlib

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_vdp_init

asm_sms_vdp_init:

   ; initialize VDP registers R0-R10
   ;
   ; INTERRUPTS ARE NOT AFFECTED HERE BECAUSE THIS IS CALLED FROM CRTs
   ; INTERRUPTS SHOULD BE DISABLED WHILE THIS RUNS
   ;
   ; enter : hl = void *vdp_register_array
	;
	; uses  : af, b, hl
	
	ld b,11
	
loop:

   ld a,(hl)
	inc hl
	
	out (__IO_VDP_COMMAND),a
	
	ld a,11+0x80
	sub b
	
	out (__IO_VDP_COMMAND),a
	
	djnz loop
	ret
