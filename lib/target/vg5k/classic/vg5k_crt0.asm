;       CRT0 for the VG5000
;
;       Joaopa Jun. 2014
;       Stefano Bodrato Lug. 2014
;
;       $Id: vg5k_crt0.asm $
;


    MODULE  vg5k_crt0



    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    EXTERN  _main           ;main() is always external to crt0 code

    PUBLIC  cleanup         ;jp'd to by exit()
    PUBLIC  l_dcal          ;jp(hl)

    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler


    IF      !DEFINED_CRT_ORG_CODE
        defc    CRT_ORG_CODE  = 18953
    ENDIF   

    IF !DEFINED_CLIB_VG5K_CHAR10
        defc    CLIB_VG5K_CHAR10 = 0
    ENDIF
    PUBLIC  CLIB_VG5K_CHAR10

    defc    CONSOLE_COLUMNS = 40
    defc    CONSOLE_ROWS = 25

    defc    TAR__fputc_cons_generic = 0
    defc	TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


IF __CLIB_FONT_HEIGHT > 10
    defw        ERROR_FONT_HEIGHT_IS_INCORRECT
ENDIF

IF !DEFINED_CRT_DISABLE_FIRMWARE_ISR
    defc CRT_DISABLE_FIRMWARE_ISR = 0
ENDIF

start:
    xor     a
    ld      (18434), a ;default character will be normal and black

    push    hl ; save HL
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    di
    ld      hl,$47D0  ;INTHK - Hook Code for Interrupt
    ld      (hl),$c3  ; JP nn
    inc     hl
    ld      de,int_patch
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ei

    call    _main
    ld      iy,$47FA

    di
    ld      a,$c9       ;ret
    ld      ($47D0),a
    ei

cleanup:
    call    crt0_exit

__restore_sp_onexit:
    ld      sp,0
    pop     hl
    ld      iy,$47FA
    ret


l_dcal:	jp	(hl)        ;Used for function pointer calls


int_patch:
    ld      (iy_val+2),iy	; Preserve IX
IF CRT_DISABLE_FIRMWARE_ISR = 0
    ld      iy,$47FA
    call    $3b
ENDIF
    ex      (sp),hl         ;Scratch return address from OS
    push    af
    ld      hl,im1_vectors
    call    asm_interrupt_handler
    pop     af
    pop     hl
iy_val:
    ld      iy,0
    ret


    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE	"crt/classic/crt_section.asm"

    SECTION	code_crt_init
    ld      hl,$4000
    ld      (base_graphics),hl

