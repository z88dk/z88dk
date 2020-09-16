MODULE banked_call

SECTION code_driver
PUBLIC banked_call
EXTERN l_jphl

EXTERN CLIB_BANKING_STACK_SIZE

INCLUDE "target/zx/def/sysvar.def"

banked_call:
    di
    pop     hl     ;Return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    ld      a,(SV_BANKM)
    push    af
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
    inc     hl	
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      bc,32765
    or      16
    ld      (SV_BANKM),a
    out     (c),a
    ei
    ld      l,e
    ld      h,d
    call    l_jphl
    di
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    push    bc
    ld      bc,32765
    ld      (SV_BANKM),a
    out     (c),a
    ei
    ret


        SECTION code_crt_init

    pop     de
    ld      (tempsp),sp
    ld      hl,-CLIB_BANKING_STACK_SIZE
    add     hl,sp
    ld      sp,hl 
    push    de

	SECTION bss_driver

mainsp:	defw	0
tempsp:	defw	0
