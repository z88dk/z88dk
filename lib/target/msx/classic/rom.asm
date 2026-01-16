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
    defc    TAR__crt_enable_eidi = $02 ; ei on entry
    defc    TAR__crt_on_exit = 0x10001  ;loop forever
    INCLUDE "crt/classic/crt_rules.inc"

;
;  Main Code Entrance Point
;
IFNDEF CRT_ORG_CODE
    defc  CRT_ORG_CODE  = $4000
ENDIF
    org   CRT_ORG_CODE

IF CRT_MSX_CUSTOM_HEADER
    INCLUDE "msx_rom_header.asm"
ELSE
; ROM header
    defm    "AB"
    defw    start
    defw    0		;CallSTMT handler
    defw    0		;Device handler
    defw    0		;basic
    defs    6
ENDIF 


start:
    di
    INCLUDE "crt/classic/crt_init_sp.inc"
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


    INCLUDE	"crt/classic/crt_init_atexit.inc"
    call    crt0_init

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    call    _main

; end program

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"


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

    ; Paging routines used by far memory
    PUBLIC  GET_P2
    PUBLIC  PUT_P2
    PUBLIC  __far_map_bank

; Used to page in memory for far pointers
;
; Entry: hl = physical address
;       ebc = logical address (i.e. __far)
;         d = virtual bank (which may be mapped to physical bank)
; Exit: debchl = preserved
;       
__far_map_bank:
    push    de
    push    hl
    ld      a,d
    inc     a           ;The first valid bank is 1
    call    PUT_P2
    pop     hl
    pop     de
    ret


GET_P2:
    ld      a,(__current_bank)
    ret

PUT_P2:
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
  IF MAPPER_ADDRESS_A000 != 0
    inc     a
    ld      (MAPPER_ADDRESS_A000),a
  ENDIF
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


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

    SECTION	data_driver

IF MAPPER_ADDRESS_8000 != 0
  IF MAPPER_ADDRESS_A000 == 0
__current_bank:	defb	1
  ELSE
__current_bank:	defb	2
  ENDIF

   SECTION bss_driver

mainsp: defw    0

tempstack:      defs    CLIB_BANKING_STACK_SIZE

    SECTION data_driver

tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE

    INCLUDE "target/msx/classic/megarom.asm"
ENDIF
