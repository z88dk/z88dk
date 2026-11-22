SECTION nextos

PUBLIC __nextos_leave

EXTERN __nextos_register_sp

EXTERN __IO_NEXTREG_REG, __REG_MMU0
EXTERN __SYSVAR_BANKM, __SYSVAR_BANK678

; need to avoid using library functions to
; keep things contained in this section

__nextos_leave:

   ; restore user banking configuration see __nextos_enter
   ; CAN BE JUMPED TO
   
   ; uses : af', bc', de', hl'
   
   di
   
   exx
   ex af,af'

   ; restore user banking state
   ; (library: asm_zxn_write_sysvar_bank_state)
   
   ld hl,(__nextos_register_sp - 12)   ; l = BANKM, h = BANK678
   
   mmu2 10
   
   ld a,h
   ld (__SYSVAR_BANK678),a
   
   ld a,l
   ld (__SYSVAR_BANKM),a
   
   ; set user banking configuration
   
   ld bc,0x1ffd
   out (c),h
   
   ld b,0x7f
   out (c),l
   
   xor a
   
   ld b,0xdf
   out (c),a

   ; restore user mmu state
   ; (library: asm_zxn_write_mmu_state)
   
   ld hl,__nextos_register_sp - 10
   
   ld bc,__IO_NEXTREG_REG
   ld de,0x0800 + __REG_MMU0

mmu_loop:

   ld a,(hl)
   inc hl

   inc a
   jr nz, write
   
   ld a,e
   
   cp __REG_MMU2
   jr nc, skip
   
   xor a

write:

   dec a
   
   out (c),e
   inc b
   out (c),a
   dec b
   
skip:

   inc e

   dec d
   jr nz, mmu_loop

   ; restore user stack
   
   ld sp,(__nextos_register_sp - 2)
   
   ; restore user ei.di state
   
   pop af
   jr nc, di_state

ei_state:

   ei

di_state:

   ; return to caller
   
   ex af,af'
   exx
   
   ret
