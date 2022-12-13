;
;	Startup for Nabu
;

	module	nabu_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

	defc	CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
	defc	CONSOLE_ROWS = 24
ENDIF


        defc    TAR__no_ansifont = 1
	defc	CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 3570000

        PUBLIC  PSG_AY_REG
        PUBLIC  PSG_AY_DATA
        defc    PSG_AY_REG = $40
        defc    PSG_AY_DATA = $41

        EXTERN    nmi_vectors
        EXTERN    asm_interrupt_handler
        EXTERN    __vdp_enable_status
        EXTERN    VDP_STATUS

        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
        defc    TAR__fputc_cons_generic = 0

	defc CRT_ORG_CODE = $140d

        INCLUDE "crt/classic/crt_rules.inc"

   	org CRT_ORG_CODE

	defb	0,0,0

start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
    IF DEFINED_USING_amalloc
        INCLUDE "crt/classic/crt_init_amalloc.asm"
    ENDIF

    ; TODO: Interrupt hooking

        call    _main
cleanup:
        push    hl
        call    crt0_exit

        pop     bc
__restore_sp_onexit:
        ld      sp,0
	ret

l_dcal:
        jp      (hl)

; VDP interrupt
IF 0
        EXTERN    __vdp_enable_status
        EXTERN    VDP_STATUS
interrupt:
        push    af
        push    hl
        ld      a,(__vdp_enable_status)
        rlca
        jr      c,no_vbl
        in      a,(VDP_STATUS)
no_vbl:
        ld      hl,nmi_vectors
        call    asm_interrupt_handler
        pop     hl
        pop     af
        retn
ENDIF


	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

