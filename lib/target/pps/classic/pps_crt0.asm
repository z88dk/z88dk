;       Kludgey startup for Peters Plus Sprinter
;
;       djm 18/5/99
;
;       $Id: pps_crt0.asm $
;



    MODULE  pps_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

;--------
; Set an origin for the application (-zorg=) default to $8100
;--------

IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $8100
ENDIF

    defc    CONSOLE_ROWS = 32
    defc    CONSOLE_COLUMNS = 80

    defc	TAR__no_ansifont = 1
    defc	TAR__fputc_cons_generic = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc	__CPU_CLOCK = 6000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE - 512

    defw    $5845   ;EXE signature
    defb    $45     ;Reserved (EXE type)
    defb    $00     ;Version of EXE file
    defq    512     ;Offset to code
    defw    0       ;Primary loader size or 0 (no primary loader)
    defq    0       ;Reserved
    defw    0       ;Reserved
    defw    start   ;Loading address
    defw    start   ;Starting address
    defw    $bfff   ;Stack
    defs    490     ;Reserved space


start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ld      (start_prefix),ix

    ld      de,0
    ld      hl,$2350
    ld      b,7
    ld      a,' '
    ld      c,$56		;CLEAR
    rst     $10
; Work out argc/argv - same as the CPM version 
IF CRT_ENABLE_COMMANDLINE = 1
    ld      hl,0    ; NULL pointer at the end
    push    hl
    ld      b,0     ;arguments
    ld      hl,(start_prefix)
    ld      a,(hl)  ;length of arguments
    and     a
    jp      z,argv_done
    ld      c,a
    add     hl,bc   ;now points to end of arguments

    INCLUDE	"crt/classic/crt_command_line.asm"
    push    hl	;argv
    push    bc	;argc
ELSE
    ld      hl,0
    push    hl  ;argv
    push    hl  ;argc
ENDIF
    call    _main   ;Call user code
    pop     bc      ;kill argv
    pop     bc      ;kill argc
cleanup:
    push    hl      ;save return code
    call    crt0_exit
    pop     bc
__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    ld      bc,$41  ;exit with - error code
    rst     $10
    ret

l_dcal:
    jp	(hl)    ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    SECTION  bss_crt

start_prefix:
    defw    0	; Entry handle from OS



