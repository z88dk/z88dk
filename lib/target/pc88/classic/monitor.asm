;       NEC PC-8801 stub for monitor mode
;
;       Stefano Bodrato - 2018

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE  = $8A00
    ENDIF

    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 20
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = 0xc000
    INCLUDE "crt/classic/crt_rules.inc"

    org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
    ld      a,$FF				; back to main ROM
    out     ($71),a				; bank switching

    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss

    ld      (exitsp),sp	

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

;	ld	a,(defltdsk)
;	ld	($EC85),a
;** If NOT IDOS mode, just get rid of BASIC screen behaviour **
    call    $4021	; Hide function key strings
    call    _main

cleanup:
    call    crt0_exit

__restore_sp_onexit:
    ld      sp,0

    ld      a,$FF		; restore Main ROM
    out     ($71),a
    ret

l_dcal:
    jp      (hl)

; ROM interposer. This could be, sooner or later, moved to a convenient position in RAM
; (e.g.  just before $C000) to be able to bounce between different RAM/ROM pages
pc88bios:
    push    af
    ld      a,$FF		; MAIN ROM
    out     ($71),a
    pop     af
    jp      (ix)


    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"
