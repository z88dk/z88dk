;       Casio PV-2000 CRT0
;


    MODULE  pv2000_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ; main() is always external to crt0 code

    PUBLIC  cleanup         ; jp'd to by exit()
    PUBLIC  l_dcal          ; jp(hl)


    PUBLIC  msxbios

    EXTERN  msx_set_mode

    EXTERN  nmi_vectors
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler
    EXTERN  asm_im1_handler
    EXTERN  __vdp_enable_status
    EXTERN  VDP_STATUS
    EXTERN  __tms9918_status_register


    defc    CRT_ORG_CODE = 0xc000
    defc    CRT_ORG_BSS = 0x7565
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF
    defc    CONSOLE_COLUMNS = 32

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0x7fff
    defc    __CPU_CLOCK = 3579000 
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    jp      start

start:
    di
    ; Hook the interrupt
    ld      a,0xc3
    ld      ($7498),a	;jp
    ld      hl,nmi_handler
    ld      ($7499),hl
    ld      a,0xc3
    ld      ($749b),a	;jp
    ld      hl,mask_int
    ld      ($749c),hl

    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"

    ld      (__restore_sp_onexit+1),sp   ; Save entry stack
    call    crt0_init_bss
    ld      (exitsp),sp
    ld      hl,2
    call    msx_set_mode
    ei


    IF DEFINED_USING_amalloc
        INCLUDE "crt/classic/crt_init_amalloc.asm"
    ENDIF


    call    _main   ; Call user program
cleanup:
    push    hl      ; return code
    call    crt0_exit



cleanup_exit:

    pop     hl      ; return code (still not sure it is teh right one !)

__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    ret


l_dcal: 
    jp      (hl)            ;Used for function pointer calls

mask_int:
    ex      (sp),hl		;Discard return address
    push    af
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     af
    pop     hl	
    ei
    reti


; On the PV-2000, the NMI receives the VDP interrupt
nmi_handler:
    push    af
    push    hl
    ld      a,(__vdp_enable_status)
    rlca
    jr      c,skip_vbl
    ; Polling the VDP from the NMI causes graphical glitches
    ld      a,(-VDP_STATUS)	;VDP status register
    ld      (__tms9918_status_register),a
skip_vbl:
    ld      hl,nmi_vectors
    call    asm_interrupt_handler
not_VBL:
    pop     hl
    pop     af
    retn

; ---------------
; MSX specific stuff
; ---------------


; Safe BIOS call
msxbios:
    push    ix
    ret


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.asm"

