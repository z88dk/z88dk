;       Casio PV-2000 CRT0
;


    MODULE  pv2000_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ; main() is always external to crt0 code

    PUBLIC  __Exit         ; jp'd to by exit()
    PUBLIC  l_dcal          ; jp(hl)


    PUBLIC  msxbios

    EXTERN  vdp_set_mode

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
    defc    TAR__crt_enable_eidi = $02
    defc    __CPU_CLOCK = 3579000 

IFNDEF CLIB_DEFAULT_SCREEN_MODE
    defc    CLIB_DEFAULT_SCREEN_MODE = 2
ENDIF

    PUBLIC  __IO_SN76489_PORT
    defc    __IO_SN76489_PORT = $40

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
    ld      (__restore_sp_onexit+1),sp   ; Save entry stack

    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"


    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main   ; Call user program
__Exit:
    push    hl      ; return code
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"
    pop     hl      ; return code (still not sure it is teh right one !)
    INCLUDE "crt/classic/crt_exit_eidi.inc"
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


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    
    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    defc    __crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE "crt/classic/crt_section.inc"

