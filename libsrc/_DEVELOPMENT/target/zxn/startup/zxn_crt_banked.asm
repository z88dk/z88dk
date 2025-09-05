   PUBLIC banked_call
	EXTERN l_jphl, __IO_NEXTREG_REG
   EXTERN CRT_BANKING_STACK_SIZE, CRT_BANKING_SEGMENT

   defc banking_mmu_low = 80 + CRT_BANKING_SEGMENT * 2
   defc banking_mmu_high = 81 + CRT_BANKING_SEGMENT * 2

   SECTION code_crt_init          

   ld a, banking_mmu_low      
   ld bc, __IO_NEXTREG_REG 
   out (c), a                 ; set next register
   inc b                      ; IO_NEXTREG_DATA
   in a, (c)                  ; read current memory bank
   ld (cur_bank), a           ; saves it in cur_bank


   SECTION code_crt_main	

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
   call set_mmu

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
   call set_mmu

   ei
   ret

set_mmu:
   nextreg banking_mmu_low, a
   inc a
   jr nz, set_mmu_no_rom
   dec a                       ; 0xff corresponds to ROM addresses. 
set_mmu_no_rom:
   nextreg banking_mmu_high, a
   ret


   SECTION data_crt

tempsp:     defw tempstack_end 
cur_bank:   defb 0


   SECTION bss_crt

mainsp:     defs 2
tempstack:  defs CRT_BANKING_STACK_SIZE
tempstack_end:

