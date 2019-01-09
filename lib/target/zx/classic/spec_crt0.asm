;       Options:
;          startup=1  --> RAM mode
;          startup=2  --> ROM mode (position code at location 0 and provide minimal interrupt services)
;
;          CRT_ORG_CODE = start address
;	   CRT_ORG_BSS = address for bss variables
;          CRT_MODEL   = 0 (RAM), 1 = (ROM, code copied), 2 = (ROM, code compressed)
;
;       djm 18/5/99
;
;       $Id: spec_crt0.asm,v 1.53 2016-07-16 07:06:27 dom Exp $
;


        MODULE  zx82_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)

        PUBLIC    call_rom3       ; Interposer
       
        PUBLIC    _FRAMES
        defc      _FRAMES = 23672 ; Timer

	PUBLIC	  __SYSVAR_BORDCR
	defc	  __SYSVAR_BORDCR = 23624


        IF DEFINED_ZXVGS
            IF !DEFINED_CRT_ORG_CODE
                DEFC    CRT_ORG_CODE = $5CCB     ; repleaces BASIC program
		defc	DEFINED_CRT_ORG_CODE = 1
            ENDIF

	    defc TAR__register_sp = 0xff57	; below UDG, keep eye when using banks
        ENDIF

        
        IF      !DEFINED_CRT_ORG_CODE
            IF (startup=2)                 ; ROM ?
                defc    CRT_ORG_CODE  = 0
		defc	TAR__register_sp = 32767	
            ELSE
                defc    CRT_ORG_CODE  = 32768
            ENDIF
        ENDIF

	; We default to the 64 column terminal driver
        defc    CONSOLE_COLUMNS = 64
        defc    CONSOLE_ROWS = 24

	; We use the generic driver by default
        defc    TAR__fputc_cons_generic = 1

	defc	DEF__register_sp = -1
        defc    TAR__clib_exit_stack_size = 32
	defc	CRT_KEY_DEL = 12
	defc __CPU_CLOCK = 3500000
	INCLUDE	"crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE


start:

        ; --- startup=2 ---> build a ROM

IF (startup=2)

        di          ; put hardware in a stable state
        ld      a,$3F
        ld      i,a
        jr      init            ; go over rst 8, bypass shadow ROM

        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif

        ; --- rst 8 ---
        ld      hl,($5c5d)      ; It was the address reached by CH-ADD.
        nop                     ; one byte still, to jump over the
                                ; Opus Discovery and similar shadowing traps
        ; --- nothing more ?

init:

		INCLUDE	"crt/classic/crt_init_sp.asm"
		
        ld      a,@111000       ; White PAPER, black INK
        call    zx_internal_cls
        ld      (hl),0
        ld      bc,42239
        ldir

		INCLUDE	"crt/classic/crt_init_atexit.asm"
		call	crt0_init_bss

		im      1
        ei
ELSE

        ; --- startup=[default] ---

        ld      iy,23610        ; restore the right iy value, 
                                ; fixing the self-relocating trick, if any
  IF !DEFINED_ZXVGS
        ld      (start1+1),sp   ; Save entry stack
  ENDIF
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp
; Optional definition for auto MALLOC init; it takes
; all the space between the end of the program and UDG
IF DEFINED_USING_amalloc
	defc	CRT_MAX_HEAP_ADDRESS = 65535 - 169
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

  IF DEFINED_ZXVGS
;setting variables needed for proper keyboard reading
        LD      (IY+1),$CD      ; FLAGS #5C3B
        LD      (IY+48),1       ; FLAGS2 #5C6A
        EI                      ; ZXVGS starts with disabled interrupts
  ENDIF
;        ld      a,2             ; open the upper display (uneeded?)
;        call    5633

ENDIF


IF DEFINED_NEEDresidos
        call    residos_detect
        jp      c,cleanup_exit
ENDIF
        call    _main           ; Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
IF CRT_ENABLE_STDIO = 1
        EXTERN     closeall
        call    closeall
ENDIF


IF (startup=2)      ; ROM ?

cleanup_exit:
        rst     0

        defs    56-cleanup_exit-1

if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif

; ######## IM 1 MODE INTERRUPT ENTRY ########

      INCLUDE "target/zx/classic/spec_crt0_rom_isr.asm"

; ########  END OF ROM INTERRUPT HANDLER ######## 

PUBLIC zx_internal_cls
zx_internal_cls:
        ld      hl,$4000        ; cls
        ld      d,h
        ld      e,l
        inc     de
        ld      (hl),0
        ld      bc,$1800
        ldir
        ld      (hl),a
        ld      bc,768
        ldir
        rrca
        rrca
        rrca
        out     (254),a
        ret


ELSE
  IF DEFINED_ZXVGS
        POP     BC              ;let's say exit code goes to BC
        RST     8
        DEFB    $FD             ;Program finished
  ELSE
cleanup_exit:
        ld      hl,10072        ;Restore hl' to what basic wants
        exx
        pop     bc
start1: ld      sp,0            ;Restore stack to entry value
        ret
  ENDIF
ENDIF



l_dcal: jp      (hl)            ;Used for function pointer calls

; Runtime selection

IF NEED_fzxterminal
        PUBLIC          fputc_cons
        PUBLIC          _fputc_cons
	PUBLIC		_fgets_cons_erase_character
	PUBLIC		fgets_cons_erase_character
        EXTERN          fputc_cons_fzx
        EXTERN          fgets_cons_erase_character_fzx
        defc DEFINED_fputc_cons = 1
        defc fputc_cons = fputc_cons_fzx
        defc _fputc_cons = fputc_cons_fzx
        defc fgets_cons_erase_character = fgets_cons_erase_character_fzx
        defc _fgets_cons_erase_character = fgets_cons_erase_character_fzx
ENDIF

	INCLUDE	"crt/classic/crt_runtime_selection.asm"

;---------------------------------------------
; Some +3 stuff - this needs to be below 49152
;---------------------------------------------
IF DEFINED_NEEDresidos
        INCLUDE "arch/zx/def/idedos.def"

        defc    ERR_NR=$5c3a            ; BASIC system variables
        defc    ERR_SP=$5c3d

	
        PUBLIC    dodos
	EXTERN	dodos_residos
	defc	dodos = dodos_residos

; Detect an installed version of ResiDOS.
;
; This should be done before you attempt to call any other ResiDOS/+3DOS/IDEDOS
; routines, and ensures that the Spectrum is running with ResiDOS installed.
; Since +3DOS and IDEDOS are present only from v1.40, this version must
; be checked for before making any further calls.
;
; If you need to use calls that were only provided from a certain version of
; ResiDOS, you can check that here as well.
;
; The ResiDOS version call is made with a special hook-code after a RST 8,
; which will cause an error on Speccies without ResiDOS v1.20+ installed,
; or error 0 (OK) if ResiDOS v1.20+ is present. Therefore, we need
; to trap any errors here.
residos_detect:
        ld      hl,(ERR_SP)
        push    hl                      ; save the existing ERR_SP
        ld      hl,detect_error
        push    hl                      ; stack error-handler return address
        ld      hl,0
        add     hl,sp
        ld      (ERR_SP),hl             ; set the error-handler SP
        rst     RST_HOOK                ; invoke the version info hook code
        defb    HOOK_VERSION
        pop     hl                      ; ResiDOS doesn't return, so if we get
        jr      noresidos               ; here, some other hardware is present
detect_error:
        pop     hl
        ld      (ERR_SP),hl             ; restore the old ERR_SP
        ld      a,(ERR_NR)
        inc     a                       ; is the error code now "OK"?
        jr      nz,noresidos            ; if not, ResiDOS was not detected
        ex      de,hl                   ; get HL=ResiDOS version
        push    hl                      ; save the version
        ld      de,$0140                ; DE=minimum version to run with
        and     a
        sbc     hl,de
        pop     bc                      ; restore the version to BC
       ret     nc                      ; and return with it if at least v1.40
noresidos:
        ld      bc,0                    ; no ResiDOS
        ld      a,$ff
        ld      (ERR_NR),a              ; clear error
        ret


ENDIF



; Call a routine in the spectrum ROM
; The routine to call is stored in the two bytes following
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
        


IF (startup=2) 			;ROM

	IF !DEFINED_CRT_ORG_BSS
	    defc CRT_ORG_BSS = 24576
	    defc DEFINED_CRT_ORG_BSS = 1
	ENDIF

        ; If we were given a model then use it
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
ENDIF

; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
	defc	__crt_org_bss = CRT_ORG_BSS
ENDIF

	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	code_crt_init
        ld      a,@111000       ; White PAPER, black INK
        ld      ($5c48),a       ; BORDCR
        ld      ($5c8d),a       ; ATTR_P
        ld      ($5c8f),a       ; ATTR_T

	SECTION bss_crt
IF startup=2
	PUBLIC  romsvc
romsvc:         defs    10  ; Pointer to the end of the sysdefvars
                            ; used by the ROM version of some library
ENDIF


	SECTION rodata_clib
; Default block size for "gendos.lib"
; every single block (up to 36) is written in a separate file
; the bigger RND_BLOCKSIZE, bigger can be the output file size
; but this comes at cost of the malloc'd space for the internal buffer
; Current block size is kept in a control block (just a structure saved
; in a separate file, so changing this value
; at runtime before creating a file is perfectly legal.
_RND_BLOCKSIZE: defw    1000


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Define Memory Banks
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ORG_BANK_0
      defc CRT_ORG_BANK_0 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_1
      defc CRT_ORG_BANK_1 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_2
      defc CRT_ORG_BANK_2 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_3
      defc CRT_ORG_BANK_3 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_4
      defc CRT_ORG_BANK_4 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_5
      defc CRT_ORG_BANK_5 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_6
      defc CRT_ORG_BANK_6 = 0xc000
   ENDIF

   IFNDEF CRT_ORG_BANK_7
      defc CRT_ORG_BANK_7 = 0xc000
   ENDIF


   SECTION BANK_0
   org CRT_ORG_BANK_0

   SECTION BANK_1
   org CRT_ORG_BANK_1

   SECTION BANK_2
   org CRT_ORG_BANK_2

   SECTION BANK_3
   org CRT_ORG_BANK_3

   SECTION BANK_4
   org CRT_ORG_BANK_4

   SECTION BANK_5
   org CRT_ORG_BANK_5

   SECTION BANK_6
   org CRT_ORG_BANK_6

   SECTION BANK_7
   org CRT_ORG_BANK_7
