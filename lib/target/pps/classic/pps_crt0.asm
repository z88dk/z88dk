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

    PUBLIC  __Exit         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

;--------
; Set an origin for the application (-zorg=) default to $8100
;--------

IF      !DEFINED_CRT_ORG_CODE
	defc    CRT_ORG_CODE  = $8100
ENDIF

; CRT_STACK is the SP value DSS loads before calling our entry point.
; The default stack at the top of WIN2 matches the standard $8100
; layout. Low-memory builds in WIN1 can override it to keep the stack
; in memory owned by the program.
IF      !DEFINED_CRT_STACK
	defc    CRT_STACK = $BFFF
ENDIF

    defc    CONSOLE_ROWS = 32
    defc    CONSOLE_COLUMNS = 80

    defc	TAR__no_ansifont = 1
    ; Use the DSS console by default. The generic console forces the
    ; Sprinter attribute byte while printing and scrolling, which
    ; changes the user's current console colours.
    defc	TAR__fputc_cons_generic = 0
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
    defw    start       ;Loading address
    defw    start       ;Starting address
    defw    CRT_STACK   ;Stack
    defs    490         ;Reserved space


start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"
    INCLUDE "crt/classic/crt_init_heap.inc"

    ld      (start_prefix),ix

    ; Snapshot the DSS PSP command tail before the z88dk argv parser
    ; writes NULs into the source buffer at every space.
    push    ix
    pop     hl                          ; HL = PSP pointer
    ld      a, (hl)                     ; length
    cp      127
    jr      c, dss_cmdline_len_ok
    ld      a, 127                      ; cap to buffer size - 1
dss_cmdline_len_ok:
    ld      de, dss_cmdline_buf
    ld      c, a
    ld      b, 0
    inc     hl                          ; first byte of command tail
    or      a
    jr      z, dss_cmdline_done
    ldir
dss_cmdline_done:
    xor     a
    ld      (de), a                     ; NUL-terminate

    ; DSS provides the command tail with a leading CP/M-style space.
    ; Strip it in place before crt_command_line.inc parses argv, or
    ; argc gets an extra empty argument before argv[1].
    push    ix
    pop     hl                          ; HL = PSP pointer
    ld      a, (hl)
    or      a
    jr      z, psp_strip_done
    ld      c, a                        ; C = length
    inc     hl                          ; first command byte
psp_strip_lead:
    ld      a, (hl)
    cp      ' '
    jr      nz, psp_strip_shift
    inc     hl
    dec     c
    jr      nz, psp_strip_lead
psp_strip_shift:
    push    ix
    pop     de                          ; DE = PSP pointer
    ld      a, c
    ld      (de), a
    or      a
    jr      z, psp_strip_term_only
    inc     de
    ld      b, 0
    ldir
    xor     a
    ld      (de), a
    jr      psp_strip_done
psp_strip_term_only:
    inc     de
    xor     a
    ld      (de), a
psp_strip_done:

; Leave the DSS console untouched by default. Programs that need a
; blank screen at startup can opt in with
; -pragma-define:CRT_CLEAR_SCREEN=1.
IF  DEFINED_CRT_CLEAR_SCREEN
    ld      de,0
    ld      hl,$2350
    ld      b,7
    ld      a,' '
    ld      c,$56		;CLEAR
    rst     $10
ENDIF
    INCLUDE "crt/classic/crt_init_eidi.inc"
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
    ld      (hl),' '
    add     hl,bc   ;now points to end of arguments

    INCLUDE	"crt/classic/crt_command_line.inc"
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
__Exit:
    push    hl      ;save return code
    call    crt0_exit
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0    ;Restore stack to entry value
    ld      bc,$41  ;exit with - error code
    rst     $10
    ret

l_dcal:
    jp	(hl)    ;Used for function pointer calls



    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

    SECTION  bss_crt

    PUBLIC  start_prefix
start_prefix:
    defw    0	; Entry handle from OS (DSS command tail pointer)

    PUBLIC  dss_cmdline_buf
dss_cmdline_buf:
    defs    128	; Raw DSS command tail snapshot, NUL-terminated.
