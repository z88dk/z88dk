
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
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


start:
        ; --- startup=[default] ---

    ld      iy,23610        ; restore the right iy value, 
                            ; fixing the self-relocating trick, if any
    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main           ; Call user program
__Exit:
    push    hl
    call    crt0_exit
    ld      hl,10072        ;Restore hl' to what basic wants
    exx
    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0            ;Restore stack to entry value
    ret



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

    INCLUDE "target/zxn/classic/memory_map.asm"

    SECTION	code_crt_init
    ld      a,@111000       ; White PAPER, black INK
    ld      ($5c48),a       ; BORDCR
    ld      ($5c8d),a       ; ATTR_P
    ld      ($5c8f),a       ; ATTR_T



