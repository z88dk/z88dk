;
;       TRS 80  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: trs80_crt0.asm $
;

;
; 	There are a couple of #pragma commands which affect this file:
;
;	#pragma output doscmd    - TRSDOS mode console output
;


    MODULE  trs80_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    PUBLIC  EG2000_ENABLED
    PUBLIC  CLIB_KEYBOARD_ADDRESS

IF      !DEFINED_CRT_ORG_CODE
    IF (startup=2)
        defc	EG2000_ENABLED = 1
        defc    CRT_ORG_CODE  = $57E4
        defc	CLIB_KEYBOARD_ADDRESS = $f800
    ELSE
        defc	EG2000_ENABLED = 0
        defc    CRT_ORG_CODE  = $5200
        defc	CLIB_KEYBOARD_ADDRESS = $3800
    ENDIF
ENDIF

IF (startup=2)
    defc    CONSOLE_ROWS = 24
    defc    CONSOLE_COLUMNS = 40
    defc	__CPU_CLOCK = 2216750
ELSE
    defc    CONSOLE_ROWS = 16
    defc    CONSOLE_COLUMNS = 64
    defc	__CPU_CLOCK = 1774000
ENDIF


    defc    TAR__fputc_cons_generic = 1
    defc	TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 32
    IF !DEFINED_CRT_COMMANDLINE_REDIRECTION
        define  DEFINED_CRT_COMMANDLINE_REDIRECTION
        defc    CRT_COMMANDLINE_REDIRECTION = 0
    ENDIF
    INCLUDE	"crt/classic/crt_rules.inc"

    INCLUDE	"target/trs80/def/maths_mbf.def"

    org     CRT_ORG_CODE

start:
    ld      (cmdline+1),hl
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and himem
; on TRS-80 the stack is defined elsewhere
IF DEFINED_USING_amalloc
    ld      a,($54)					; Get byte from ROM
    dec     a						; Determine if Mod 1 or 3
    ld      hl,($4411)				; himem ptr on Model III
    jr      nz,set_max_heap_addr	; Go if Model III
    ld      hl,($4049)				; himem ptr on Model I

set_max_heap_addr:
    push    hl
    ld      hl,_heap
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     bc
    xor     a
    ld      (hl),a
    dec     hl
    ld      (hl),a
    pop     hl	; sp
    sbc     hl,bc	; hl = total free memory

    push    bc ; main address for malloc area
    push    hl	; area size
    EXTERN sbrk_callee
    call    sbrk_callee
ENDIF


    ; Push pointers to argv[n] onto the stack now
    ; We must start from the end 
cmdline:
    ld      hl,0	; SMC - command line back again
    ld      bc,0
    ld      a,(hl)
    cp      13
    jr      nz,nocr
    xor     a
    ld      (hl),a
    jp      argv_done
nocr:
    dec     hl
find_end:
    inc     hl
    inc     c
    ld      a,(hl)
    cp      13
    jr      nz,find_end
    xor     a
    ld      (hl),a
    dec     hl
    INCLUDE	"crt/classic/crt_command_line.asm"

    push	hl	;argv for "main"
    push	bc	;argc

IF CRT_ENABLE_STDIO = 1
 IF DEFINED_doscmd
  IF CRT_COMMANDLINE_REDIRECTION = 1
    ; if (fchkstd(stdout) == 1) freopen("*do","w",stdout);
    EXTERN  fchkstd
    ld      hl,__sgoioblk+10		; file struct for stdout
    push    hl
    call    fchkstd
    pop     de
    ld      a,l
    dec     a
    jr      nz,crt_no_reopen
   ENDIF
    EXTERN freopen
    ld      hl,crt_do_fname
    push    hl					; file name ptr
    ld      de,redir_fopen_flag
    push    de
    ld      de,__sgoioblk+10		; file struct for stdout
    push    de
    call    freopen
    pop     de

    ; Simplidied redirection of STDERR.
    ; If STDOUT was already redirected, the eventual STDERR output
    ; will be on top of the screen rather than gracefully appended at the console output.
    ld      de,__sgoioblk+20		; file struct for stderr
    push    de
    call    freopen
    pop     de
    pop     de
    pop     de
crt_no_reopen:
  ENDIF
ENDIF

    call    _main           ;Call user program
    pop     bc	;kill argv
    pop     bc	;kill argc
cleanup:
    call    crt0_exit
cleanup_exit:
__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
    ret

l_dcal:
    jp      (hl)            ;Used for function pointer calls


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE	"crt/classic/crt_section.asm"



    SECTION code_crt_init
IF (startup=2)
    call	$1c9		;CLS
    ld	hl,$4400   ; Address of the TEXT map for COLOUR GENIE
ELSE
    ld	hl,$3c00   ; Address of the TEXT (Semi-Graphics) map for TRS-80
ENDIF
    ld	(base_graphics),hl



    SECTION  rodata_clib
IF CRT_ENABLE_STDIO = 1
IF DEFINED_doscmd
crt_do_fname:		defb	'*','D','O',0
IF DEFINED_noredir
redir_fopen_flag:		defb	'w',0
ENDIF
ENDIF
ENDIF

