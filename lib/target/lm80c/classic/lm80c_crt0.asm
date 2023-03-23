;
;	Startup for LM80-C
;

    module  lm80c_crt0 


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

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 24
ENDIF


    defc    TAR__no_ansifont = 1
    defc    CRT_KEY_DEL = 12
    defc    __CPU_CLOCK = 3500000

    PUBLIC  PSG_AY_REG
    PUBLIC  PSG_AY_DATA
    defc    PSG_AY_REG = @01000000
    defc    PSG_AY_DATA = @01000001

    EXTERN  nmi_vectors
    EXTERN  asm_interrupt_handler
    EXTERN  __vdp_enable_status
    EXTERN  VDP_STATUS

    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -1
    defc    TAR__fputc_cons_generic = 0

    INCLUDE "target/lm80c/def/lm80c.def"

    defc    CRT_ORG_CODE = BASTXT

    INCLUDE "crt/classic/crt_rules.inc"

   	org     CRT_ORG_CODE


    defc SYS_ADDRESS = CRT_ORG_CODE+16

    defc SYS_DIGIT1 = ((SYS_ADDRESS & 0xF000) / 256 / 16)
    defc SYS_DIGIT2 = ((SYS_ADDRESS & 0x0F00) / 256     )
    defc SYS_DIGIT3 = ((SYS_ADDRESS & 0x00F0) / 16      )
    defc SYS_DIGIT4 = ((SYS_ADDRESS & 0x000F)           )

    defc SYS_HEXDIGIT1 = ((SYS_DIGIT1+48)*(SYS_DIGIT1 <= 9)) + ((SYS_DIGIT1+65-10)*(SYS_DIGIT1 > 9))
    defc SYS_HEXDIGIT2 = ((SYS_DIGIT2+48)*(SYS_DIGIT2 <= 9)) + ((SYS_DIGIT2+65-10)*(SYS_DIGIT2 > 9))
    defc SYS_HEXDIGIT3 = ((SYS_DIGIT3+48)*(SYS_DIGIT3 <= 9)) + ((SYS_DIGIT3+65-10)*(SYS_DIGIT3 > 9))
    defc SYS_HEXDIGIT4 = ((SYS_DIGIT4+48)*(SYS_DIGIT4 <= 9)) + ((SYS_DIGIT4+65-10)*(SYS_DIGIT4 > 9))

        ; BASIC header for the LM80-C
        ; 2020 SYS&H8253:END

basicstart:   
    defw (SYS_ADDRESS-2)          ; pointer to next basic line in memory
    defw FWN                      ; line number (as reference, Firmware number is used)
    defb TOKENSYS                 ; SYS token code
    defb 0x26, 0x48               ; "&H"
    defb SYS_HEXDIGIT1            ; "8"
    defb SYS_HEXDIGIT2            ; "2"
    defb SYS_HEXDIGIT3            ; "5"
    defb SYS_HEXDIGIT4            ; "3"
    defb 0x3a                     ; ":"
    defb 0x80                     ; END token code
    defb 0x00                     ; end of BASIC line
    defw 0x0000                   ; NULL basic line number (resides at SYS_ADDRESS-2)


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


	; Setup NMI if required
	; Apparently the NMI is buggy, a 0.01second tick is available
	; via CTC3IV at 0x81ca which we could hook instead
;	ld	hl,interrupt
;	ld	(NMIUSR+1),hl
;	ld	a,195	;JP
;	ld	(NMIUSR),a


    call    _main
cleanup:
    push    hl
    call    crt0_exit

	; We should probably disable VDP interrupts before doing this
;	ld	hl,$45ED	;retn
;	ld	(NMIUSR),hl

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

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms9918/mode_disable.asm"

    INCLUDE	"crt/classic/crt_section.asm"

