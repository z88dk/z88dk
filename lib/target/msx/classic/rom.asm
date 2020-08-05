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

	defm	"AB"
	defw	start
	defw	0		;CallSTMT handler
	defw	0		;Device handler
	defw	0		;basic
	defs	6

start:
	di
	INCLUDE	"crt/classic/crt_init_sp.asm"
	ei

; port fixing; required for ROMs
; port fixing = set the memory configuration, must be first!

	in a,($A8)
	and a, $CF
	ld d,a
	in a,($A8)
	and a, $0C
	add a,a
	add a,a
	or d
	out ($A8),a

	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss

       IF DEFINED_USING_amalloc
                INCLUDE "crt/classic/crt_init_amalloc.asm"
        ENDIF

	call _main

; end program

cleanup:
endloop:
	di
	halt
	jr endloop


l_dcal:	jp	(hl)		;Used for call by function pointer

	GLOBAL	banked_call

	; Memory address for changing the mapping at $8000 and $a000
	; If _A000 is 0 then we work with 16kb banks
	; These values are by default the KONAMI mapper
IF DEFINED_MAPPER_ASCII16 = 1
	defc	MAPPER_ADDRESS_8000 = $7000
	defc	MAPPER_ADDRESS_A000 = $0000
ELIF DEFINED_MAPPER_ASCII8 = 1
	defc	MAPPER_ADDRESS_8000 = $7000
	defc	MAPPER_ADDRESS_A000 = $7800
ELSE
	; Konami Mapper without SCC
	defc	MAPPER_ADDRESS_8000 = $8000
	defc	MAPPER_ADDRESS_A000 = $A000
ENDIF

banked_call:
        pop     hl              ; Get the return address
        ld      a,(__current_bank)
        push    af              ; Push the current bank onto the stack
        ld      e,(hl)          ; Fetch the call address
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      a,(hl)          ; ...and page
IF MAPPER_ADDRESS_A000 != 0
	add	a		; For 8kb pages we have to double - our
				; model is for 16kb pages
ENDIF
	inc	hl
        inc     hl              ; Yes this should be here
        push    hl              ; Push the real return address
        ld      (__current_bank),a
	ld	(MAPPER_ADDRESS_8000),a
IF MAPPER_ADDRESS_A000 != 0
	inc	a
	ld	(MAPPER_ADDRESS_A000),a
ENDIF
        ld      hl,banked_ret  ; Push the fake return address
        push    hl
        ld      l,e
        ld      h,d
        jp      (hl)

banked_ret:
        pop     bc              ; Get the return address
        pop     af              ; Pop the old bank
        ld      (__current_bank),a
	ld	(MAPPER_ADDRESS_8000),a
IF MAPPER_ADDRESS_A000 != 0
	inc	a
	ld	(MAPPER_ADDRESS_A000),a
ENDIF
        push    bc
        ret


IFNDEF CRT_ORG_BSS
	defc CRT_ORG_BSS = $C000   ; Ram variables are kept in RAM in high memory
ENDIF
	defc	__crt_org_bss = CRT_ORG_BSS

        ; If we were given a model then use it
        IFDEF CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

	SECTION	data_driver

IF MAPPER_ADDRESS_A000 == 0
__current_bank:	defb	1
ELSE
__current_bank:	defb	2
ENDIF

   IFNDEF CRT_ORG_BANK_01
      defc CRT_ORG_BANK_01 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_02
      defc CRT_ORG_BANK_02 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_03
      defc CRT_ORG_BANK_03 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_04
      defc CRT_ORG_BANK_04 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_05
      defc CRT_ORG_BANK_05 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_06
      defc CRT_ORG_BANK_06 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_07
      defc CRT_ORG_BANK_07 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_08
      defc CRT_ORG_BANK_08 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_09
      defc CRT_ORG_BANK_09 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0A
      defc CRT_ORG_BANK_0A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0B
      defc CRT_ORG_BANK_0B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0C
      defc CRT_ORG_BANK_0C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0D
      defc CRT_ORG_BANK_0D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0E
      defc CRT_ORG_BANK_0E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0F
      defc CRT_ORG_BANK_0F = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_10
      defc CRT_ORG_BANK_10 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_11
      defc CRT_ORG_BANK_11 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_12
      defc CRT_ORG_BANK_12 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_13
      defc CRT_ORG_BANK_13 = 0x8000
   ENDIF
   IFNDEF CRT_ORG_BANK_14
      defc CRT_ORG_BANK_14 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_15
      defc CRT_ORG_BANK_15 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_16
      defc CRT_ORG_BANK_16 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_17
      defc CRT_ORG_BANK_17 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_18
      defc CRT_ORG_BANK_18 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_19
      defc CRT_ORG_BANK_19 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1A
      defc CRT_ORG_BANK_1A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1B
      defc CRT_ORG_BANK_1B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1C
      defc CRT_ORG_BANK_1C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1D
      defc CRT_ORG_BANK_1D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1E
      defc CRT_ORG_BANK_1E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1F
      defc CRT_ORG_BANK_1F = 0x8000
   ENDIF

   SECTION BANK_01
   org 0x010000 + CRT_ORG_BANK_01
   SECTION CODE_1
   SECTION RODATA_1

   SECTION BANK_02
   org 0x020000 + CRT_ORG_BANK_02
   SECTION CODE_2
   SECTION RODATA_2

   SECTION BANK_03
   org 0x030000 + CRT_ORG_BANK_03
   SECTION CODE_3
   SECTION RODATA_3

   SECTION BANK_04
   org 0x040000 + CRT_ORG_BANK_04
   SECTION CODE_4
   SECTION RODATA_4

   SECTION BANK_05
   org 0x050000 + CRT_ORG_BANK_05
   SECTION CODE_5
   SECTION RODATA_5

   SECTION BANK_06
   org 0x060000 + CRT_ORG_BANK_06
   SECTION CODE_6
   SECTION RODATA_6

   SECTION BANK_07
   org 0x070000 + CRT_ORG_BANK_07
   SECTION CODE_7
   SECTION RODATA_7

   SECTION BANK_08
   org 0x080000 + CRT_ORG_BANK_08
   SECTION CODE_8
   SECTION RODATA_8

   SECTION BANK_09
   org 0x090000 + CRT_ORG_BANK_09
   SECTION CODE_9
   SECTION RODATA_9

   SECTION BANK_0A
   org 0x0a0000 + CRT_ORG_BANK_0A
   SECTION CODE_10
   SECTION RODATA_10

   SECTION BANK_0B
   org 0x0b0000 + CRT_ORG_BANK_0B
   SECTION CODE_11
   SECTION RODATA_11

   SECTION BANK_0C
   org 0x0c0000 + CRT_ORG_BANK_0C
   SECTION CODE_12
   SECTION RODATA_12

   SECTION BANK_0D
   org 0x0d0000 + CRT_ORG_BANK_0D
   SECTION CODE_13
   SECTION RODATA_13

   SECTION BANK_0E
   org 0x0e0000 + CRT_ORG_BANK_0E
   SECTION CODE_14
   SECTION RODATA_14

   SECTION BANK_0F
   org 0x0f0000 + CRT_ORG_BANK_0F
   SECTION CODE_15
   SECTION RODATA_15

   SECTION BANK_10
   org 0x100000 + CRT_ORG_BANK_10
   SECTION CODE_16
   SECTION RODATA_16

   SECTION BANK_11
   org 0x110000 + CRT_ORG_BANK_11
   SECTION CODE_17
   SECTION RODATA_17

   SECTION BANK_12
   org 0x120000 + CRT_ORG_BANK_12
   SECTION CODE_18
   SECTION RODATA_18

   SECTION BANK_13
   org 0x130000 + CRT_ORG_BANK_13
   SECTION CODE_19
   SECTION RODATA_19

   SECTION BANK_14
   org 0x140000 + CRT_ORG_BANK_14
   SECTION CODE_20
   SECTION RODATA_20

   SECTION BANK_15
   org 0x150000 + CRT_ORG_BANK_15
   SECTION CODE_21
   SECTION RODATA_21

   SECTION BANK_16
   org 0x160000 + CRT_ORG_BANK_16
   SECTION CODE_22
   SECTION RODATA_22

   SECTION BANK_17
   org 0x170000 + CRT_ORG_BANK_17
   SECTION CODE_23
   SECTION RODATA_23

   SECTION BANK_18
   org 0x180000 + CRT_ORG_BANK_18
   SECTION CODE_24
   SECTION RODATA_24

   SECTION BANK_19
   org 0x190000 + CRT_ORG_BANK_19
   SECTION CODE_25
   SECTION RODATA_25

   SECTION BANK_1A
   org 0x1a0000 + CRT_ORG_BANK_1A
   SECTION CODE_26
   SECTION RODATA_26

   SECTION BANK_1B
   org 0x1b0000 + CRT_ORG_BANK_1B
   SECTION CODE_27
   SECTION RODATA_27

   SECTION BANK_1C
   org 0x1c0000 + CRT_ORG_BANK_1C
   SECTION CODE_28
   SECTION RODATA_28

   SECTION BANK_1D
   org 0x1d0000 + CRT_ORG_BANK_1D
   SECTION CODE_29
   SECTION RODATA_29

   SECTION BANK_1E
   org 0x1e0000 + CRT_ORG_BANK_1E
   SECTION CODE_30
   SECTION RODATA_30

   SECTION BANK_1F
   org 0x1f0000 + CRT_ORG_BANK_1F
   SECTION CODE_31
   SECTION RODATA_31
