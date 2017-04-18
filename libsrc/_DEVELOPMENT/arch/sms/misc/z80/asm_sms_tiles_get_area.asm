; void sms_tiles_get_area(struct r_Rect8 *r, void *dst)
;
; Copy tile contents of a rectangular area in vram to memory

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_tiles_get_area

EXTERN asm_sms_cxy2saddr, asm_sms_memcpy_vram_to_mem

asm_sms_tiles_get_area:

   ; enter : de = void *dst
   ;         ix = struct r_Rect *r
   ;
   ; exit  : de = void *dst after last byte written to memory
   ;
   ; uses  : af, bc, de, hl
   
   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_sms_cxy2saddr      ; hl = screen map address
   
   ; ix = rect *
   ; hl = screen map address
   ; de = void *dst
   
   ld c,(ix+3)                 ; c = rect.height
   ld b,0
   
copy_loop:

   push bc
   push hl
   
   ld c,(ix+1)
   sla c                       ; c = rect.width * 2
   
   call asm_sms_memcpy_vram_to_mem
   
   pop hl
   
   ld c,64
   add hl,bc
   
   pop bc
   
   dec c
   jr nz, copy_loop
   
   ret
