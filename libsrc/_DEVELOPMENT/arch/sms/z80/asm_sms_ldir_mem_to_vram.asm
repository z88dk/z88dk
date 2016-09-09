; ========================================================================
; 
; void *sms_ldir_mem_to_vram(void *dst, void *src, unsigned int n)
;
; ldir from memory to vram; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_ldir_mem_to_vram
PUBLIC asm_sms_ldir_mem_to_vram_continue

EXTERN asm_sms_set_vram_write_de

asm_sms_ldir_mem_to_vram:

   ; memcpy from memory to vram
   ;
   ; enter : hl = void *src in memory
   ;         de = void *dst in vram
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *src, &byte after last read
   ;         de = void *dst, &byte after last written
   ;
   ; uses  : af, bc, de, hl

   call asm_sms_set_vram_write_de
   
   ex de,hl
   add hl,bc
   ex de,hl

asm_sms_ldir_mem_to_vram_continue:

   ; hl = void *src in memory
   ; bc = unsigned int n > 0
   ; VRAM has dst address set

   ld a,b
   inc a
   ld b,c
   
   inc b
   djnz no_adjust
   dec a
   
no_adjust:
   
   ld c,$be
   
loop:

   outi
   
   inc b
   djnz loop
   
   dec a
   jp nz, loop

   ret
 