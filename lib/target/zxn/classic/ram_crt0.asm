
;
; The usual program (org 32768 or any other address above the ROM) is started from BASIC and returns to it.
;
; With CRT_ORG_CODE = 0 it is a program that has the whole of the memory map to itself, RAM mapped in over the ROM
; (its loader sees to that: the Next's MMU, NextReg $50 and up).  There is no BASIC to return to and no ROM system
; variables, so nothing is written to them (they would be the program's own code) and IY is left alone; the restart
; vectors and the interrupt at $0038 are the program's, as in the other crts that start at 0 (crt_z80_rsts.inc): each is
; a `ret` (the interrupt at $0038 `ei; reti`) unless the program asks for it with CRT_ENABLE_RST, a bit for each of the
; rsts in the order of their addresses ($02 rst 8, $04 rst $10, $08 rst $18, $10 rst $20, $20 rst $28, $40 rst $30,
; $80 rst $38 (the interrupt); rst 0 is the start), and then defines _z80_rst_08h ... _z80_rst_38h, which the vector jumps
; to.  When main returns the program loops with interrupts off, or does what CRT_ON_EXIT says.
;
    IF      !DEFINED_CRT_ORG_CODE
            defc  CRT_ORG_CODE  = 32768
    ENDIF
    defc __crt_org_code = CRT_ORG_CODE
    PUBLIC __crt_org_code

IF !DEFINED_CRT_MAX_HEAP_ADDRESS
    defc	CRT_MAX_HEAP_ADDRESS = 65535 - 169
ENDIF
        
    ; We use the generic driver by default
    defc    TAR__fputc_cons_generic = 1

    defc    TAR__register_sp = 65535
    defc    TAR__clib_exit_stack_size = 32
IF CRT_ORG_CODE = 0x0000
    defc    TAR__crt_on_exit = 0x10001      ; loop forever (nothing to return to)
ENDIF
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000
    jp      start
    INCLUDE "crt/classic/crt_z80_rsts.inc"
ENDIF

start:
        ; --- startup=[default] ---

IF CRT_ORG_CODE != 0x0000
    ld      iy,23610        ; restore the right iy value, 
                            ; fixing the self-relocating trick, if any
    ld      (__restore_sp_onexit+1),sp
ENDIF
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main           ; Call user program
__Exit:
IF CRT_ORG_CODE = 0x0000
    call    crt0_exit
    INCLUDE "crt/classic/crt_terminate.inc"
ELSE
    push    hl
    call    crt0_exit
    ld      hl,10072        ;Restore hl' to what basic wants
    exx
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
    ret
ENDIF



l_dcal: jp      (hl)            ;Used for function pointer calls

call_rom3:
    exx                      ; Use alternate registers
IF DEFINED_NEED_ZXMMC
    push    af
    xor     a                ; standard ROM
    out     ($7F),a          ; ZXMMC FASTPAGE
    pop     af
ENDIF
    ex      (sp),hl          ; get return address
    ld      c,(hl)
    inc     hl
    ld      b,(hl)           ; BC=BASIC address
    inc     hl
    ex      (sp),hl          ; restore return address
    push    bc
    exx                      ; Back to the regular set
    ret



; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

    INCLUDE	"crt/classic/crt_runtime_selection.inc"


    INCLUDE "target/zxn/classic/memory_map.asm"

IF CRT_ORG_CODE != 0x0000
    SECTION	code_crt_init
    ld      a,@111000       ; White PAPER, black INK
    ld      ($5c48),a       ; BORDCR
    ld      ($5c8d),a       ; ATTR_P
    ld      ($5c8f),a       ; ATTR_T
ENDIF



