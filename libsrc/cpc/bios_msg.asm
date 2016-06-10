;
;       Amstrad CPC library
;       Show/hide error messages
;
;       void bios_msg(int status)
;
;       $Id: bios_msg.asm,v 1.4 2016-06-10 21:12:36 dom Exp $
;

	SECTION	  code_clib
        PUBLIC    bios_msg
        PUBLIC    _bios_msg

        INCLUDE "cpcfirm.def"              


.bios_msg
._bios_msg

        push    hl
        ld      hl,cmd_biosmsg
        call    firmware
        defw    kl_find_command
        pop     de
        ret     nc

        ld      (biosmsg_command),hl   ; store address of function
        ld	a,c
        ld      (biosmsg_command+2),a  ; store "rom select" of function

        ld      a,e         ; 0=enable, $FF=disable

        rst  $18            ; KL FAR CALL
        defw biosmsg_command
        ret


.biosmsg_command
        defw 0
        defb 0


.cmd_biosmsg
        defb '1'+$80
