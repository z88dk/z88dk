        


    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE = $100   ; MSXDOS
    ENDIF

    ; For MSXDOS 1 limit the number of open files to 3 to reduce memory usage
    ; This can be overridden with -pragma-define:CLIB_OPEN_MAX=NN where NN
    ; is your chosen number
    IF CLIB_MSXDOS = 1
        IF !DEFINED_CLIB_OPEN_MAX
            defc    DEFINED_CLIB_OPEN_MAX = 1
            defc    CLIB_OPEN_MAX = 3
        ENDIF
    ENDIF

    IF !DEFINED_MSXDOS
        defc MSXDOS = 5
    ENDIF

    IF !DEFINED_CRT_DISABLELOADER
        defc CRT_DISABLELOADER = 1
    ENDIF
    PUBLIC MSXDOS
    
    INCLUDE "crt/classic/crt_rules.inc"


    org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, it survived up to here !
	defb	$b4,$09		;DOS protection... MOV AH,9 (Err msg for MS-DOS)
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for MSXDOS."
	defb	13,10,'$'

begin:
ENDIF

    ld      (__restore_sp_onexit+1),sp
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

  IF CRT_DISABLELOADER != 1
    call    loadbanks
    jp      c,cleanup
  ENDIF

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ;ld      a,($F306)
    ;ld      (defltdsk),a

IF CRT_ENABLE_COMMANDLINE = 1
    ld      hl,$80
    ld      a,(hl)
    ld      b,0
    and     a
    jp      z,argv_done
    ld      c,a
    inc     hl
    add     hl,bc   ;now points to the end of the command line
    INCLUDE	"crt/classic/crt_command_line.asm"
    push    hl	;argv
    push    bc	;argc
ELSE
    ld      hl,0
    push    hl  ;argv
    push    hl  ;argc
ENDIF
    call    _main		;Call user code
    pop     bc	;kill argv
    pop     bc	;kill argc

cleanup:
    call    crt0_exit
__restore_sp_onexit:
    ld      sp,0
    jp      0

l_dcal:
    jp      (hl)


IF CRT_DISABLELOADER != 1

  PUBLIC banked_call
banked_call:
    pop     hl              ; Get the return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    call    GET_P2
    push    af              ; Push the current bank onto the stack
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
    inc     hl
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      hl,bank_mappings ; Mapping 0-255 to actual segment ids
    add     l
    ld      l,a
    ld      a,0
    adc     h
    ld      h,a
    ld      a,(hl)          ;Get the real bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    call    PUT_P2
    ld      l,e
    ld      h,d
    call    l_dcal          ; jp(hl)
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    call    PUT_P2
    push    bc
    ret


hexit:
    ld      c,a
    rrca
    rrca
    rrca
    rrca
    call    dohex
    ld      a,c
dohex:
    and     15
    ld      b,'0'
    cp      10
    jr      c,not_alpha
    ld      b,'A' - 10
not_alpha:
    add     b
    ld      (hl),a
    inc     hl
    ret

print_message_pop:
    pop     af
print_message:
    ld      c,9
    call    5
    scf
    ret

msg_bankstart:
    defm    "Starting to load banks\r\n$"

msg_noextbios:
    defm    "Cannot detect extended BIOS\r\n$"

msg_nomapper:
    defm    "Cannot locate mapper\r\n$"

msg_cantallocate:
    defm    "Cannot allocate segment\r\n$"

msg_loading:
    defm    "Loading....$"

msg_lf:
    defm    "\r\n$"

loadbanks:
    ld      de,msg_bankstart
    call    print_message
    ; Setup mapper, extract info etc
    ld      a,($FB20)   ;HOKVLD
    rrca
    ld      de,msg_noextbios
    jp      nc,print_message
    xor     a
    ld      de,$0401
    call    $FFCA   ;EXTBIO
    xor     a
    ld      de,$0402
    call    $FFCA   ;EXTBIO
    and     a
    ld      de,msg_nomapper
    jp      z,print_message
    ld      de,dos2_jump
    ld      bc,dos2_end - dos2_jump
    ldir

    ld      hl,__crt_loader_filename
find_ext:
    ld      a,(hl)
    cp      '.'
    inc     hl
    jr      nz,find_ext
    ld      (extension),hl

    ld      a,0     ;Bank number to start loading from
load_loop:
    push    af      ;Bank number
    ld      hl,(extension)
    call    hexit
    inc     hl
    ld      (hl),'$'
    ld      de,__crt_loader_filename
    ld      a,1             ;READ only
    ld      c,$43           ;OPEN
    call    5
    and     a
    jp      nz,next_file
    push    bc              ;b=fd
    ; Allocate a bank
    ld      b,0             ;Primary mapper
    ld      a,0             ;Allocate user segment
    call    ALL_SEG
    pop     bc
    ld      de,msg_cantallocate
    jp      c,print_message_pop
    ld      c,a             ;Save allocated segment
    pop     af
    push    af
    ld      e,a
    ld      hl,bank_mappings
    ld      d,0
    add     hl,de
    ld      (hl),c         ;Save mapping
    ld      a,c
    call    PUT_P2
    push    bc
    ld      de,msg_loading
    call    print_message
    ld      de,__crt_loader_filename
    call    print_message
    ld      de,msg_lf
    call    print_message
    pop     bc
    ; b = file handler
    ld      de,32768       ;Just read a banks worth, don't care how much really
    ld      hl,16384
    ld      c,$48          ;Read
    push    bc
    call    5
    pop     bc
close_file:
    ld      c,$45           ;Close
    call    5
next_file:
    pop     af
    inc     a
    jr      nz,load_loop
    and     a
    ret


; Populated by appmake
    PUBLIC  __crt_loader_filename
extension:
    defw    0
__crt_loader_filename:
    defm    "BANK.00"
    defs    12


bank_mappings:
    defs        256	    ;This is far too many

; Jump table (copied from on high)
dos2_jump:
ALL_SEG:    defs    3   ;Allocate a 16k segment.
FRE_SEG:    defs    3   ;Free a 16k segment.
RD_SEG:     defs    3   ;Read byte from address A:HL to A
WR_SEG:     defs    3   ;Write byte from E to address A:HL.
CAL_SEG:    defs    3   ;Inter-segment call.  Address in IYh:IX
CALLS:      defs    3   ;Inter-segment call.  Address in line after the call instruction.
PUT_PH:     defs    3   ;Put segment into page (HL).
GET_PH:     defs    3   ;Get current segment for page (HL)
PUT_P0:     defs    3   ;Put segment into page 0.
GET_P0:     defs    3   ;Get current segment for page 0.
PUT_P1:	    defs    3   ;Put segment into page 1.
GET_P1:     defs    3   ;Get current segment for page 1.
PUT_P2:     defs    3   ;Put segment into page 2.
GET_P2:     defs    3   ;Get current segment for page 2.
PUT_P3:     defs    3   ;Not supported since page-3 must never be changed.  Acts like a "NOP" if called.
GET_P3:     defs    3   ;Get current segment for page 3.
dos2_end:

mainsp: defw    0

tempstack:      defs    CLIB_BANKING_STACK_SIZE

tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE

ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"
IF CLIB_MSXDOS = 1
    INCLUDE "crt/classic/crt_cpm_fcntl.asm"
ENDIF

    SECTION bss_crt

    PUBLIC  brksave
brksave:    defb    1

IF CRT_DISABLELOADER != 1
    ; Include a lot of banks (org to 0x8000)
    INCLUDE "target/msx/classic/megarom.asm"
ENDIF

