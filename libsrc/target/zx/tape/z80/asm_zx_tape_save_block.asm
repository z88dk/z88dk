; unsigned char zx_tape_save_block(void *src, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_tape_save_block

EXTERN _GLOBAL_ZX_PORT_FE
EXTERN asm_cpu_push_di, asm_cpu_pop_ei
EXTERN error_znc, error_mc

asm_zx_tape_save_block:

   ; enter : ix = source address
   ;         de = block length
   ;          a = 0 (header block), 0xff (data block)
   ;
   ; exit  : success
   ;
   ;            hl = 0, carry reset
   ;
   ;         failure
   ;
   ;            hl = -1, carry set0
   ;
   ; uses  : af, bc, de, hl, ix, af'

   ld l,a
   call asm_cpu_push_di
   ld a,l

   ld hl,exit
   push hl
   
   jp 0x04c6                   ; rom save routine, trapped by divmmc

exit:

   ex af,af'                   ; carry flag set on success
   
   ld a,(_GLOBAL_ZX_PORT_FE)
   and $f7                     ; bit 3 must be zero for final transition on tape
   ld (_GLOBAL_ZX_PORT_FE),a
   
   out ($fe),a                 ; restore border colour
   
   call asm_cpu_pop_ei
   
   ex af,af'
   
   jp c, error_znc
   jp error_mc
