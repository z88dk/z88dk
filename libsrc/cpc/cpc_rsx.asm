;
;       Amstrad CPC library
;       Call a RSX/Bar command
;
;       int cpc_rsx(char *cmd, ...)
;
;       It accepts the command name (it will be adapted "on the fly"),
;       and a list of pointers to variables.
;
;       $Id: cpc_rsx.asm,v 1.5 2017-01-02 19:59:39 aralbrec Exp $
;

        SECTION   code_clib
        PUBLIC    cpc_rsx
        PUBLIC    _cpc_rsx

        INCLUDE "cpcfirm.def"              



.cpc_rsx
._cpc_rsx
        ;call    firmware
        ;defw    kl_rom_walk
	push	ix		;save callers

        ld      ix,4
        add     ix,sp
        push    ix
        dec     a
        push    af              ; number of parameters
        
        add     a
        ld      e,a
        ld      d,0
        add     ix,de
        
        ld      l,(ix+0)
        ld      h,(ix+1)        ; cmd
        ld      de,cmd_buff
        push    de              ; cmd_buff

.loop   ld      a,(hl)
        cp      'a'
        jr      c,nolowr
        cp      'z'+1
        jr      nc,nolowr
        and     $df             ; to upper
.nolowr ld      (de),a
        inc     hl
        inc     de
        or      a
        jr      nz,loop

        dec     de
        dec     de
        ld      a,(de)
        or      $80             ; string termination
        ld      (de),a
        
        pop     hl              ; cmd_buff
        call    firmware
        defw    kl_find_command
        jr      nc,notfound

        ld      (rsx_command),hl     ; store address of function
        ld      a,c
        ld      (rsx_command+2),a    ; store "rom select" of function

        pop     af              ; number of parameters
        pop     ix              ; parameter address list

        rst     $18             ; KL FAR CALL
        defw    rsx_command
        ld	hl,0
        jr	c,rsx_ok
        bit	6,a
        jr	nz,harderr
        and	$1f		; mask out the "error already reported" bit
.harderr
        ld	l,a
.rsx_ok
	pop	ix		;restore caller
        ret




.notfound
        pop     bc              ; params stuff..
        pop     bc              ; ..balance stack
        ld      hl,-1           ; Error: command not found
	pop	ix		;restore caller
        ret

	SECTION	bss_clib
.rsx_command
        defw 0
        defb 0
.cmd_buff  defs 12      ; max command name lenght
