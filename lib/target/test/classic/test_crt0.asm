;
;	Startup for test emulator
;
;	$Id: test_crt0.asm,v 1.12 2016-06-21 20:49:07 dom Exp $


    module  test_crt0

    INCLUDE "test_cmds.def"


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 65280
    defc    CRT_KEY_DEL = 127
    defc    __CPU_CLOCK = 4000000



IF !__CPU_RABBIT__ && !__CPU_GBZ80__
    IF CRT_ORG_CODE = 0x0000
        ; We want to intercept rst38 to our interrupt routine
        defc    TAR__crt_enable_rst = $0000
        EXTERN  asm_im1_handler
        defc    _z80_rst_38h = asm_im1_handler
    ENDIF
ENDIF


    INCLUDE "crt/classic/crt_rules.inc"



IF !DEFINED_CRT_ORG_CODE
    defc CRT_ORG_CODE = 0x0000
ENDIF

    org     CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000

    if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
    endif

    jp  program

    INCLUDE "crt/classic/crt_z80_rsts.asm"
ENDIF

program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
IF __CPU_GBZ80__
    ld      hl,sp+0
    ld      d,h
    ld      e,l
    ld      hl,exitsp
    ld      a,l
    ld      (hl+),a
    ld      a,h
    ld      (hl+),a
ELSE
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
ENDIF
IF !__CPU_R2KA__
    ei
ENDIF
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    ld      a,(argv_length)
    and     a
    jp      z,argv_done
    ld      c,a
    ld      b,0
    ld      hl,argv_start
    add     hl,bc	; now points to end of the command line
    INCLUDE "crt/classic/crt_command_line.asm"
    push    hl	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    push    hl
    call    crt0_exit
    pop     hl
    ld      a,CMD_EXIT	;exit
    ; Fall into SYSCALL

SYSCALL:
    ; a = command to execute
    defb    $ED, $FE	;trap
    ret

l_dcal:
    jp      (hl)            ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.asm" 
    INCLUDE	"crt/classic/crt_section.asm"

