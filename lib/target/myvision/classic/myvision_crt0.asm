;
;	Startup for Nichibutsu My Vision
;
;	2k of memory 

    module  myvision_crt0 



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)
    PUBLIC	msxbios
    EXTERN	msx_set_mode
    EXTERN  asm_im1_handler
    EXTERN  nmi_vectors
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler
    EXTERN  __vdp_enable_status
    EXTERN  VDP_STATUS

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF

    defc    CRT_ORG_BSS = 0xa000
    defc    CRT_ORG_CODE = 0x0000

    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = 0xa800
    defc	CRT_KEY_DEL = 127
    defc	__CPU_CLOCK = 3579545

    ; VDP signals delivered to im1
    defc TAR__crt_enable_rst = $8080
    defc _z80_rst_38h = tms9918_interrupt

    ; No NMI on this machine


    INCLUDE "crt/classic/crt_rules.inc"

    org	  CRT_ORG_CODE

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif

    jp      start

    INCLUDE	"crt/classic/crt_z80_rsts.asm"

    INCLUDE "crt/classic/tms9918/interrupt.asm"
    ei
    reti

int_VBL:
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     hl
    pop     af
    ei
    reti

start:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
    ld      hl,2
    call    msx_set_mode
    im      1
 
    ; Configure the AY to enable reading the keys
    ld      a,$07
    out     ($00),a
    in      a,($02)
    set     7,a
    res     6,a
    out     ($01),a

    ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    call    _main
cleanup:
    rst     0       ;Restart when main finishes


; Safe BIOS call
msxbios:
    push    ix
    ret


l_dcal: 
    jp      (hl)            ;Used for function pointer calls

    INCLUDE "crt/classic/crt_runtime_selection.asm" 

    defc	__crt_org_bss = CRT_ORG_BSS
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE	"crt/classic/crt_section.asm"

