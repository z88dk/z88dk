
	MODULE	banked_call

	SECTION	code_driver
	PUBLIC	banked_call
        EXTERN  CLIB_BANKING_STACK_SIZE

        INCLUDE "target/gb/def/gb_globals.def"


        ;; Performs a long call.
        ;; Basically:
        ;;   call banked_call
        ;;   .dw low
        ;;   .dw bank
        ;;   remainder of the code
banked_call:
        pop     de              ; Get the return address
        ; Switch to the temporary stack
        ld      (mainsp),sp
        ld      hl,tempsp
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ld      sp,hl
        ld      a,(__current_bank)
        push    af              ; Push the current bank onto the stack
        ld      l,e
        ld      h,d
        ld      e,(hl)          ; Fetch the call address
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)          ; ...and page
        inc     hl 
        inc     hl              ; Yes this should be here
        push    hl              ; Push the real return address

        ; Switch back to the main stack from the temporary stack
        ld      (tempsp),sp
        ld      hl,mainsp
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ld      sp,hl
        

        ld      a,c
        ld      (__current_bank),a
        ld      (MBC1_ROM_PAGE),a      ; Perform the switch
	ld	l,e
	ld	h,d
	rst	$20

        push    hl 
        ld      (mainsp),sp
        ld      hl,tempsp
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ld      sp,hl
        pop     bc              ; Get the return address
        pop     af              ; Pop the old bank
        ld      (tempsp),sp

        ld      (MBC1_ROM_PAGE),a
        ld      (__current_bank),a

        ld      hl,mainsp
        ld      a,(hl+)
        ld      h,(hl)
        ld      l,a
        ld      sp,hl
        pop     hl
	push	bc
	ret


        SECTION code_crt_init
        pop     bc
        ld      hl,sp+0
        ex      de,hl
        ld      hl,tempsp
        ld      (hl),e
        inc     hl
        ld      (hl),d
        add     sp,-CLIB_BANKING_STACK_SIZE
        push    bc
         


	SECTION	bss_driver

__current_bank:	defw	0
tempsp:         defw    0
mainsp:         defw    0

