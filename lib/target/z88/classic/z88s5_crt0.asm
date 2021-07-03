;
;       Startup stub for z88 OZ5 shell
;

        PUBLIC    cleanup               ;jp'd to by exit()
        PUBLIC    l_dcal                ;jp(hl)


        PUBLIC    processcmd    ;Processing <> commands




        INCLUDE	"stdio.def"
        INCLUDE "error.def"

        INCLUDE	"elf.def"

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
        defc	CRT_KEY_DEL = 127
        defc    EXEC_ORG = $2000
        PUBLIC ELFHDR_START
	EXTERN	__BSS_END_tail
        INCLUDE "crt/classic/crt_rules.inc"


        org	EXEC_ORG - EH_SIZEOF - PHT_SIZEOF


.ELFHDR_START
        defm    $7F, "ELF"
        defb    ELFCLASS32                      ; 32-bit objects        e_ident[EI_CLASS]
        defb    ELFDATA2LSB                     ; little endian         e_ident[EI_DATA]
        defb    EV_CURRENT                      ; always                e_ident[EI_VERSION]
        defb    ELFOSABI_OZ                     ; OZ                    e_ident[EI_OSABI]
        defb    ELFABIVERSION                   ; unspecified
        defs    7 

        defw    ET_EXEC                         ; elf type
        defw    EM_Z80                          ; machine architecture
        defq    EV_CURRENT                      ; always CURRENT
        defq    EXEC_ORG                        ; entry address
        defq    PHT_START - ELFHDR_START        ; program header offset
        defq    0                               ; section header offset
        defq    0                               ; processor specific flags
        defw    EH_SIZEOF                       ; elf header size in bytes (52)
        defw    PHT_SIZEOF                      ; program header entry size (32)
        defw    1                               ; number of program header entries
        defw    SHT_SIZEOF                      ; section header entry size (40)
        defw    0                               ; number of section header entries
        defw    0                               ; section name string index

;   PHT
.PHT_START
        defq    PT_LOAD                         ; type
        defq    EXEC_ORG - ELFHDR_START        ; p_offset
        defq    EXEC_ORG                        ; virtual address
        defq    0                               ; physical address
        defq     __BSS_END_tail - EXEC_ORG     ; file size
        defq     __BSS_END_tail - EXEC_ORG     ; memory size requested
        defq    PF_X | PF_R                     ; executable
        defq    $10000                          ; 64k bank alignement




;-----------
; Code starts executing from here
;
; Arguments are passed on the stack:
;       [6,7]   argv[1] pointer to the argument
;       [4,5]   argv[0] the program name
;       [2,3]   argc (16bit int)
; SP -> [0,1]   RETurn to ELF loader (and caller)
;-----------
start:
    ld      ix,4
    add     ix,sp
    ld      (start1+1),sp	;Save starting stack
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp	

    IF DEFINED_USING_amalloc
        INCLUDE "crt/classic/crt_init_amalloc.asm"
    ENDIF

    call    doerrhan    ;Initialise a laughable error handler
    push    ix
    ld      l,(ix-2)
    ld      h,(ix-1)
    push    hl

    call    _main       ;Run the program
    pop     bc          ; kill argv
    pop     bc          ; kill argc
	
cleanup:			;Jump back here from exit() if needed
    call    crt0_exit

    call    resterrhan	;Restore the original error handler

start1:	
    ld      sp,0        ;Restore stack to entry value
    ret

;-----------
; Install the error handler
;-----------
doerrhan:
    xor     a
    ld      (exitcount),a
    ld      b,0
    ld      hl,errhand
    call_oz(os_erh)
    ld      (l_erraddr),hl
    ld      (l_errlevel),a
    ret

;-----------
; Restore BASICs error handler
;-----------
resterrhan:
    ld      hl,(l_erraddr)
    ld      a,(l_errlevel)
    ld      b,0
    call_oz(os_erh)
processcmd:			;processcmd is called after os_tin
    ld      hl,0
    ret


;-----------
; The error handler
;-----------
errhand:
    ret     z   		;Fatal error
    cp      RC_Esc
    jr     z,errescpressed
    ld      hl,(l_erraddr)	;Pass everything to BASIC's handler
    scf
l_dcal:
    jp	(hl)		;Used for function pointer calls also

errescpressed:
    call_oz(Os_Esc)		;Acknowledge escape pressed
    jr      cleanup		;Exit the program



;----------
; The system() function for the shell 
;----------
	PUBLIC	_system
_system:
    pop     de		; DE=return address
    pop     bc		; BC=command address
    push    bc
    push    de
    ;GN_Elf
    ret


    INCLUDE "crt/classic/crt_runtime_selection.asm"


    INCLUDE "crt/classic/crt_section.asm"

    SECTION bss_crt
l_erraddr:       defw    0       ;Not sure if these are used...
l_errlevel:      defb    0
