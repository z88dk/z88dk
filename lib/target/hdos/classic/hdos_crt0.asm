;
;       Startup for HDOS
;
;       Stefano Bodrato - 2026
;
;
;       $Id: hdos_crt0.asm $
;
;


    MODULE  hdos_crt0

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"



    ;EXTERN hdos_platform_init

    EXTERN    _main     ;main() is always external to crt0

    PUBLIC    __Exit        ;jumped to by exit()
    PUBLIC    l_dcal        ;jp(hl)

    defc    TAR__clib_exit_stack_size = 32

    defc    TAR__register_sp = $447F
    defc    __CPU_CLOCK = 2000000

    IF !DEFINED_CRT_ORG_CODE
        defc    CRT_ORG_CODE  = $4480
        defc    DEFINED_CRT_ORG_CODE = 1
    ENDIF

    IF !DEFINED_CLIB_OPEN_MAX
        defc    DEFINED_CLIB_OPEN_MAX = 1
        defc    CLIB_OPEN_MAX = 3
    ENDIF

    ; Default to some "sensible" values
    IF !DEFINED_CONSOLE_ROWS
        defc    CONSOLE_ROWS = 24
    ENDIF
    IF !DEFINED_CONSOLE_COLUMNS
        defc    CONSOLE_COLUMNS = 80
    ENDIF

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE


;----------------------
; Execution starts here
;----------------------
start:

    ld      hl,0
    add     hl,sp
    push hl
    ld      (__restore_sp_onexit+1),hl  ;Save entry stack

    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init   
    INCLUDE "crt/classic/crt_init_atexit.inc"
    ;call    hdos_platform_init ;Any platform specific init


    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ; Initialization of console under HDOS
SCALL macro call            ; SYSCALL macro
    rst     $38
    db      call
    endm
CONSL  equ  6               ; CONSL system call
EXIT   equ  0               ; EXIT system call
CSLMD  equ  0               ; Index for console mode
CSLECH equ  %10000000       ; Bit for suppress echo
CSLCHR equ  %00000001       ; Bit for update in character mode

    pop hl

IF CRT_ENABLE_COMMANDLINE = 1

IF startup=3
; Handle command line arguments under HDOS.
; Command line argument string starts at (SP) (with a space), ends at
; $227F (terminated with a null). If no command line options passed,
; (SP) = $2280.
; Example: "foo 1 22 33"
; SP -> $2276
; $2276 $2277 $2278 $2279 $227A $227B $227C $227D $227E' $227F
;  ' '   '1'   ' '   '2'   '2'   ' '   '3'   '3'   '3'    $00

EOS equ     $227e

    ;ld      hl,sp       ; Check for case of no options, i.e. SP = $2280
    ld      a,$80
    cp      l
    jr      nz,args     ; Branch if arguments
    ld      a,$22
    cp      h
    jr      nz,args

    ; Handle case of no arguments
    ld      hl,argv0    ; name of program (null)
    push    hl
    ld      hl,0
    add     hl,sp   ; address of argv
    ld      bc,1        ; argc is 1
    jp      pshargs

argv0:
    defb    0

args:
    ld      hl,EOS   ; Address of end of arguments
    sbc     hl,sp    ; Subtract SP to calculate length
    ld      c,l      ; Put length in C
    ld      b,0      ; Put zero in B
    ld      hl,EOS   ; Put end address back in HL

    ; Command line parsing code below wants (HL) = end of arguments,
    ; (C) = length of arguments, (B) = 0.
    ; Returns with (HL) = argv and (BC) = argc.

    INCLUDE "crt/classic/crt_command_line.inc"
pshargs:
    push    hl  ; argv
    push    bc  ; argc

ELSE

    ld      a,CSLMD         ; Index
    ld      b,CSLCHR ; Suppress echo and update in character mode
    ld      c,CSLCHR ; Mask
    SCALL   CONSL           ; Initialize HDOS console

       extern  hdos_default
   
       ld      a,'A'
       rst     38h
       defb    2  ; SCOUT
       ld      a,'R'
       rst     38h
       defb    2  ; SCOUT
       ld      a,'G'
       rst     38h
       defb    2  ; SCOUT
       ld      a,'>'
       rst     38h
       defb    2  ; SCOUT
   
       ld      hl,command_line
       ld      bc,0
   
   get_cmdline:
       push    hl
       push    bc
       rst     38h
       defb    1  ; SCIN
       pop     bc
       pop     hl
       jr      c,get_cmdline
       cp      10
       jr      z,cmdline_rdy
       cp      13
       jr      z,cmdline_rdy
   
      cp      8 ; delete
      jr      nz,nobs
      push    hl
      push    bc
      ld      a,' '
      rst     38h
      defb    2  ; SCOUT
      ld      a,8
      rst     38h
      defb    2  ; SCOUT
      pop     bc
      pop     hl
      xor     a
      ld      (hl),a
      dec     hl
      dec     bc
      jr      get_cmdline
   nobs:
   
       ld      (hl),a
       inc     hl
       inc     bc
       jr      get_cmdline
   cmdline_rdy:
   
       ;ld      a,(hl)
       ;ld      b,0
       ;ld      b,h
       ;and     a
       ;jp      z,argv_done
       ;inc   hl
       ;ld      c,a
       ;add     hl,bc   ;now points to the end of the command line
       ;inc     hl
       ;ld      (hl),0
       ;dec     hl
       ;dec     c
       INCLUDE    "crt/classic/crt_command_line.inc"
       push    hl ;argv
       push    bc ;argc
ENDIF
ELSE   ; (CRT_ENABLE_COMMANDLINE != 1)
    ld      hl,0
    push    hl  ;argv
    push    hl  ;argc
ENDIF

    ld      a,CSLMD         ; Index
    ld      b,CSLECH|CSLCHR ; Suppress echo and update in character mode
    ld      c,CSLECH|CSLCHR ; Mask
    SCALL   CONSL           ; Initialize HDOS console

    call    _main       ;Call user code
    pop     bc  ;kill argv
    pop     bc  ;kill argc

__Exit:
    ; TODO: Save exit value / deal with error conditions
    push    hl      ;Save return value
    call    crt0_exit
    pop     hl
    INCLUDE "crt/classic/crt_exit_eidi.inc"

PUBLIC __restore_sp_onexit
__restore_sp_onexit:
    ld      sp,0    ; Pick up entry sp
    xor     a       ; Exit gracefullly (set to 1 to abort)
    RST     $38
    defb    0       ; Exit User Program

l_dcal: jp  (hl)        ;Used for call by function ptr



    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"
    INCLUDE "crt/classic/crt_hdos_fcntl.inc"


; This trailing part is copied
; from CP/M, possibly useless on HDOS

;  IF WANT_DEVICE_STDPUN
;      EXTERN _stdpun_device
;      setup_static_fp(__stdpun,_stdpun_device)
;  ENDIF
;  IF WANT_DEVICE_STDRDR
;      EXTERN _stdrdr_device
;      setup_static_fp(__stdrdr,_stdrdr_device)
;  ENDIF
;  IF WANT_DEVICE_STDLST
;      EXTERN _stdlst_device
;      setup_static_fp(__stdlst,_stdlst_device)
;  ENDIF



IF CRT_ENABLE_COMMANDLINE = 1

command_line:
    defs 150
        
ENDIF

    SECTION code_crt_init
    ;????
    ;ld      (defltdsk),a

    SECTION code_crt_exit
    ;ld      a,(defltdsk)        ;Restore default disc
    ;????

