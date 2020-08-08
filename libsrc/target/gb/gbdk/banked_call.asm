
	MODULE	banked_call

	SECTION	code_driver
	PUBLIC	banked_call


        INCLUDE "target/gb/def/gb_globals.def"


        ;; Performs a long call.
        ;; Basically:
        ;;   call banked_call
        ;;   .dw low
        ;;   .dw bank
        ;;   remainder of the code
        ;; Total m-cycles:
        ;;      3+4+4 + 2+2+2+2+2+2 + 4+4+ 3+4+1+1+1
        ;;      = 41 for the call
        ;;      3+3+4+4+1
        ;;      = 15 for the ret
banked_call:
        pop     hl              ; Get the return address
        ld      a,(__current_bank)
        push    af              ; Push the current bank onto the stack
        ld      e,(hl)          ; Fetch the call address
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      a,(hl+)         ; ...and page
        inc     hl              ; Yes this should be here
        push    hl              ; Push the real return address
        ld      (__current_bank),a
        ld      (MBC1_ROM_PAGE),a      ; Perform the switch
	ld	l,e
	ld	h,d
	rst	$20
        pop     bc              ; Get the return address
        pop     af              ; Pop the old bank
        ld      (MBC1_ROM_PAGE),a
        ld      (__current_bank),a
	push	bc
	ret


	SECTION	bss_driver

__current_bank:	defw	0
