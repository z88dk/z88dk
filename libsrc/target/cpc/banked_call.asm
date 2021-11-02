MODULE banked_call

SECTION code_driver
PUBLIC banked_call
EXTERN l_jphl

EXTERN CLIB_BANKING_STACK_SIZE


banked_call:
    di
    pop     hl     ;Return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    ld      a,(cpc_memory_register)
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
    ld      (cpc_memory_register),a
    ld      c,a
    ld      b,$7f
    out     (c),c
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
    ld      b,$7f
    ld      (cpc_memory_register),a
    ld      c,a
    out     (c),c
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
	SECTION data_driver
cpc_memory_register:	defb	$c0
