	SECTION code_driver

    	PUBLIC banked_call
	EXTERN l_jphl, __clib_banking_mmu_low, __clib_banking_mmu_high

	defc CLIB_BANKING_STACK_SIZE = 100

banked_call:
    di
    pop hl
    ld (mainsp), sp             ; Save the current stack pointer
    ld sp, (tempsp)             ; Set the stack poin`ter to the temporary stack

    ld a, (cur_bank)            ; Get the current bank
    push af                     ; Save the current bank in the stack

    ld e, (hl)                  ; Fetch the call address in de
    inc hl
    ld d, (hl)
    inc hl                      
    ld a, (hl)                  ; ...and target page
    inc hl
    inc hl                      ; Yes this should be here
    push hl                     ; Push the real return address

    ld (tempsp), sp             ; Saves the temporal call stack 
    ld sp, (mainsp)             ; and restores the regular stack

    ; Sets MMU (as per defined) the new pages (A and A+1)
    ld (cur_bank), a
    nextreg __clib_banking_mmu_low, a
    inc a
    nextreg __clib_banking_mmu_high, a

    ei
    
    ex de, hl                  ; Puts the call address in hl
    call l_jphl                ; Calls the banked function    

    di
    ld (mainsp), sp             ; Sets the temporal stack pointer
    ld sp, (tempsp)

    pop bc                      ; Get the return address
    pop af                      ; Pop the old page

    ld (tempsp), sp       ; Restores the default stack pointer
    ld sp, (mainsp)

    push bc                     ; Push the return address

    ; Restores MMU pages
    ld (cur_bank), a
    nextreg __clib_banking_mmu_low, a
    inc a
    nextreg __clib_banking_mmu_high, a

    ei
    ret


    SECTION data_driver

tempsp:     defw tempstack_end 
cur_bank:   defb 0

    SECTION bss_driver
mainsp:     defs 2
tempstack:  defs CLIB_BANKING_STACK_SIZE
tempstack_end:
