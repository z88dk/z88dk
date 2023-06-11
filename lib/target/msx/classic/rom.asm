; startup == 3
; msx cartridge rom

; April 2014
; submitted by Timmy

; For cartridge I am not sure what facilities are available from the MSX
; system, if any.  So this CRT only provides the bare minimum.

;
;  Declarations
;


    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -0xfc4a
    INCLUDE "crt/classic/crt_rules.inc"

;
;  Main Code Entrance Point
;
IFNDEF CRT_ORG_CODE
    defc  CRT_ORG_CODE  = $4000
ENDIF
    org   CRT_ORG_CODE

; ROM header
    defm    "AB"
    defw    start
    defw    0		;CallSTMT handler
    defw    0		;Device handler
    defw    0		;basic
    defs    6

start:
    di
    INCLUDE "crt/classic/crt_init_sp.asm"
    ;; interrupts are enabled later some ROM routines disable them

; port fixing; required for ROMs
; port fixing = set the memory configuration, must be first!
    call    $0138       ;read primary slot #
    rrca                ;move it to bit 0,1 of [Acc]
    rrca
    and     $03
    ld      c,a
    ld      b,0
    ld      hl,$0FCC1   ;see if this slot is expanded or not
    add     hl,bc
    ld      c,a         ;save primary slot #
    ld      a,(hl)      ;get the slot is expanded or not
    and     $80
    or      c           ;set MSB if so
    ld      c,a         ;save it to [c]
    inc     hl          ;Point to SLTTBL entry
    inc     hl
    inc     hl
    inc     hl
    ld      a,(hl)      ;Get what  is  currently  output
                        ;to expansion   slot    register
    and     $0c
    or      c           ;Finaly form slot address
    ld      h,$80
    call    $0024       ;enable page 2
                        ;beware: this call returns with ints disabled!

    ;; reenable interrupts
    ei

    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main

; end program

cleanup:
endloop:
    di
    halt
    jr      endloop


l_dcal:	jp	(hl)		;Used for call by function pointer

    GLOBAL  banked_call

    ; Memory address for changing the mapping at $8000 and $a000
    ; If _A000 is 0 then we work with 16kb banks
    ; These values are by default the KONAMI mapper
IF DEFINED_MAPPER_ASCII16 = 1
    defc    MAPPER_ADDRESS_4000 = $6000
    defc    MAPPER_ADDRESS_6000 = $0000
    defc    MAPPER_ADDRESS_8000 = $7000
    defc    MAPPER_ADDRESS_A000 = $0000
ELIF DEFINED_MAPPER_ASCII8 = 1
    defc    MAPPER_ADDRESS_4000 = $6000
    defc    MAPPER_ADDRESS_6000 = $6800
    defc    MAPPER_ADDRESS_8000 = $7000
    defc    MAPPER_ADDRESS_A000 = $7800
ELIF DEFINED_MAPPER_KONAMI = 1
    ; Konami Mapper without SCC
    defc    MAPPER_ADDRESS_4000 = $0000
    defc    MAPPER_ADDRESS_6000 = $6000
    defc    MAPPER_ADDRESS_8000 = $8000
    defc    MAPPER_ADDRESS_A000 = $A000
ELSE
    defc    MAPPER_ADDRESS_4000 = $0000
    defc    MAPPER_ADDRESS_6000 = $0000
    defc    MAPPER_ADDRESS_8000 = $0000
    defc    MAPPER_ADDRESS_A000 = $0000
ENDIF

    ; Bias the Mapper detection heuristics to try to overcome any
    ; collisions in data.
IF MAPPER_ADDRESS_4000 != 0
    ld      (MAPPER_ADDRESS_4000),a
ENDIF
IF MAPPER_ADDRESS_6000 != 0
    ld      (MAPPER_ADDRESS_6000),a
ENDIF
IF MAPPER_ADDRESS_8000 != 0
    ld      (MAPPER_ADDRESS_8000),a
ENDIF
IF MAPPER_ADDRESS_A000 != 0
    ld      (MAPPER_ADDRESS_A000),a
ENDIF
IF MAPPER_ADDRESS_4000 != 0
    ld      (MAPPER_ADDRESS_4000),a
ENDIF
IF MAPPER_ADDRESS_6000 != 0
    ld      (MAPPER_ADDRESS_6000),a
ENDIF
IF MAPPER_ADDRESS_8000 != 0
    ld      (MAPPER_ADDRESS_8000),a
ENDIF
IF MAPPER_ADDRESS_A000 != 0
    ld      (MAPPER_ADDRESS_A000),a
ENDIF
IF MAPPER_ADDRESS_4000 != 0
    ld      (MAPPER_ADDRESS_4000),a
ENDIF
IF MAPPER_ADDRESS_6000 != 0
    ld      (MAPPER_ADDRESS_6000),a
ENDIF
IF MAPPER_ADDRESS_8000 != 0
    ld      (MAPPER_ADDRESS_8000),a
ENDIF
IF MAPPER_ADDRESS_A000 != 0
    ld      (MAPPER_ADDRESS_A000),a
ENDIF

IF MAPPER_ADDRESS_8000 != 0
banked_call:
    pop     hl              ; Get the return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    ld      a,(__current_bank)
    push    af              ; Push the current bank onto the stack
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
  IF MAPPER_ADDRESS_A000 != 0
    add     a               ; For 8kb pages we have to double - our
                            ; model is for 16kb pages
  ENDIF
    inc     hl
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
  IF MAPPER_ADDRESS_A000 != 0
    inc     a
    ld      (MAPPER_ADDRESS_A000),a
  ENDIF
    ld      l,e
    ld      h,d
    call	l_dcal		; jp(hl)
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
  IF MAPPER_ADDRESS_A000 != 0
    inc     a
    ld      (MAPPER_ADDRESS_A000),a
  ENDIF
    push    bc
    ret
ENDIF


IFNDEF CRT_ORG_BSS
    defc    CRT_ORG_BSS = $C000   ; Ram variables are kept in RAM in high memory
ENDIF
    defc    __crt_org_bss = CRT_ORG_BSS

    ; If we were given a model then use it
    IFDEF CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

    SECTION	data_driver

IF MAPPER_ADDRESS_8000 != 0
  IF MAPPER_ADDRESS_A000 == 0
__current_bank:	defb	1
  ELSE
__current_bank:	defb	2
  ENDIF
ENDIF

   SECTION bss_driver

mainsp: defw    0

tempstack:      defs    CLIB_BANKING_STACK_SIZE

    SECTION data_driver

tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE

IF MAPPER_ADDRESS_8000 != 0
    INCLUDE "target/msx/classic/megarom.asm"
ENDIF
