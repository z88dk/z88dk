SECTION nextos

PUBLIC __nextos_enter

EXTERN __nextos_register_sp

EXTERN __IO_NEXTREG_REG, __REG_MMU0
EXTERN __SYSVAR_BANKM, __SYSVAR_BANK678

; need to avoid using library functions to
; keep things contained in this section

__nextos_enter:

   ; set up banking configuration for nextos
	; MUST BE CALLED
   ;
   ; exit : sp = moved to nextos stack
   ;
   ;                           <-- __nextos_register_sp
   ;        +----------+
   ;        | saved sp | -1
   ;        |          | -2
   ;        +----------+
   ;        |          | -3
   ;        | mmu state| -4
   ;        |          | ..
   ;        |          | -10
   ;        +----------+
   ;        |  bank678 | -11
   ;        |   bankm  | -12   <-- sp
   ;        +----------+
   ;
   ;        saved stack has ei.di state pushed on it
   ;
   ;        memory configuration changed to:
   ;
   ;          0-16k   ROM2
   ;        16k-24k   BANK 5
   ;        48k-64k   BANK 7
   ;
   ; uses : af', bc', de', hl'

   ; using program stack

   exx
   ex af,af'

   pop hl
   ld (__nextos_register_sp - 14),hl   ; save return address to nextos stack

   ; determine ei.di state
   ; (library: asm_z80_push_di)
   
   ld hl,0
   
   push hl
   pop hl
   
   scf
   
   ld a,i
   jp pe, continue
   
   dec sp
   dec sp
   pop hl
   
   ld a,h
   or l
   jr z, continue
   
   scf

continue:

   push af                             ; leave ei.di state on program stack

   ld (__nextos_register_sp - 2),sp    ; save program sp to nextos stack
   
   ; using nextos stack
   
   ld sp,__nextos_register_sp - 14
   
   push af                             ; save ei.di state
   
   di
   
   ; read mmu state
   ; (library: asm_zxn_read_mmu_state)
   
   ld hl,__nextos_register_sp - 10
   
   ld bc,__IO_NEXTREG_REG
   ld de,0x0800 + __REG_MMU0

mmu_loop:

   out (c),e
   inc b
   ini
   inc e
   
   dec d
   jr nz, mmu_loop
   
   ; bring page 10 into memory space

   mmu2 10

   ; read 128k banking state
   ; (library: asm_zxn_read_sysvar_bank_state)  
   
   ld hl,(__SYSVAR_BANKM)
   
   ld a,(__SYSVAR_BANK678)
   ld h,a
   
   ld (__nextos_register_sp - 12),hl   ; save bank state
   
   ; set nextos banking configuration
   
   ld a,l                      ; BANKM
   
   and 0x08                    ; keep screen bit
   or 0x07                     ; select bank 7
   
   ld bc,0x7ffd
   out (c),a                   ; port 0x7ffd
   
   ld b,0x1f
   
   ld a,0x40
   out (c),a                   ; port 0x1ffd
   
   ld b,0xdf
   
   xor a
   out (c),a                   ; port 0xdffd

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
