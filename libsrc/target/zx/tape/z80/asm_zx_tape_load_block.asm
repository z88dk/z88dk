; unsigned char zx_tape_load_block(void *dst, unsigned int len, unsigned char type)
; unsigned char zx_tape_verify_block(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_tape_load_block
PUBLIC asm_zx_tape_verify_block

EXTERN _GLOBAL_ZX_PORT_FE
EXTERN asm_cpu_push_di, asm_cpu_pop_ei
EXTERN error_znc, error_mc

asm_zx_tape_verify_block:

   or a
   jr asm_zx_tape_load_block_rejoin

asm_zx_tape_load_block:

   ; enter : ix = destination address
   ;         de = block length
   ;          a = 0 (header block), 0xff (data block)
   ;
   ; exit  : success
   ;
   ;            hl = 0, carry reset
   ;
   ;         failure
   ;
   ;            hl = -1, carry set
   ;
   ; uses  : af, bc, de, hl, ix, af'
   
   scf

asm_zx_tape_load_block_rejoin:

   inc d                       ; set nz flag
   ex af,af'
   dec d
   
   call asm_cpu_push_di        ; push ei/di state, di
   
   ld a,$0f
   out ($fe),a                 ; make border white
   
   ld hl,exit
   push hl
   
   jp 0x0562                   ; rom tape load, trapped by divmmc

exit:

   ex af,af'                   ; carry flag set on success
   
   ld a,(_GLOBAL_ZX_PORT_FE)
   out ($fe),a                 ; restore border colour
   
   call asm_cpu_pop_ei         ; ei, ret

   ex af,af'
   
   jp c, error_znc
   jp error_mc
