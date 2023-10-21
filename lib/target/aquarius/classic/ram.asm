;       CRT0 for the Mattel Aquarius
;
;       Stefano Bodrato Dec. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: aquarius_crt0.asm $
;

IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = 14768
ENDIF


    ; Page video into 0xc000 -> 0xffff
    defc    CLIB_VIDEO_PAGE_PORT = PORT_BANK3

    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp	;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

IF startup = 3
    call    loadbanks
ENDIF

    call    _main   ;Call user program
cleanup:
    call    crt0_exit


__restore_sp_onexit:
    ld  sp,0        ;Restore stack to entry value
    ret

IF startup = 3

    ; We bank into segment3

    PUBLIC  banked_call
banked_call:
    pop     hl              ; Get the return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    in      a,(PORT_BANK3)
    push    af              ; Push the current bank onto the stack
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
    add     34
    inc     hl
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      (tempsp),sp
    ld      sp,(mainsp)
    out     (PORT_BANK3),a
    ld      l,e
    ld      h,d
    call	l_dcal		; jp(hl)
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    out     (PORT_BANK3),a
    push    bc
    ret

    EXTERN  __esp_send_cmd
    EXTERN  __esp_send_byte
    EXTERN  __esp_send_bytes
    EXTERN  __esp_read_byte
    EXTERN  asm_strlen
    
; Load banks 34 -> 63 (we call them 1 ->29 )
loadbanks:
    ; Save current binding
    in      a,(PORT_BANK3)
    push    af
    ld      a,1
loadloop:
    push    af
    add     34              ;We use banks 1 - 29 for compatibility with other targets
    out     (PORT_BANK3),a
    sub     34
    call    setext
    ld      a,ESPCMD_OPEN
    call    __esp_send_cmd
    xor     a                   ;O_RDONLY
    call    __esp_send_byte
    ld      hl,_basename
    push    hl
    call    asm_strlen
    ld      bc,hl
    inc     bc
    pop     hl
    call    __esp_send_bytes
    call    __esp_read_byte     ;Read fd
    bit     7,a
    jr      nz,next
    ld      b,a                 ;Keep fd safe
    ld      a,ESPCMD_READ
    call    __esp_send_cmd
    ; Send fd
    ld      a,b
    call    __esp_send_byte
    ; Now send length (16384)
    xor     a
    call    __esp_send_byte
    ld      a,64
    call    __esp_send_byte
    ; Read result
    call    __esp_read_byte
    and     a
    jr      nz,next
    ; Read offered length
    call    __esp_read_byte
    ld      c,a
    call    __esp_read_byte
    ld      b,a
    ; And read into our bank
    ld      hl,$C000
loop:
    ld      a,b
    or      c
    jr      z,next
    call    __esp_read_byte
    ld      (hl),a
    inc     hl
    dec     bc
    jr      loop
next:
    pop     af
    inc     a
    cp      29
    jr      nz,loadloop
    ; Close all files
    ld      a,ESPCMD_CLOSEALL
    call    __esp_send_cmd
    call    __esp_read_byte     ;Read the response
    pop     af
    out     (PORT_BANK3),a
    ret

setext:
    ld      hl,__basename_ext
    ld      b,a
    rra
    rra
    rra
    rra
    call    conv
    ld      a,b
conv:
    and     15
    add     $90
    daa
    adc     $40
    daa
    ld      (hl),a
    inc     hl
    ret


; Use #pragma string basename [basename] to set the name of the file
_basename:
    DEFINE NEED_basename
    INCLUDE "zcc_opt.def"
    UNDEFINE NEED_basename
    defb    '.'
__basename_ext:
    defm    "00"
    defb    0

mainsp:     defw    0
tempstack:  defs    CLIB_BANKING_STACK_SIZE
tempsp:     defw    tempstack + CLIB_BANKING_STACK_SIZE


ENDIF
