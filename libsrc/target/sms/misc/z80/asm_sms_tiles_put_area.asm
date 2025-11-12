; void sms_tiles_put_area(struct r_Rect8 *r, void *src)
;
; Copy tile contents stored in memory to a rectangular area in vram

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_tiles_put_area

EXTERN asm_sms_cxy2saddr, asm_sms_memcpy_mem_to_vram

asm_sms_tiles_put_area:

   ; enter : de = void *src
   ;         ix = struct r_Rect *r
   ;
   ; exit  : hl = void *src after last byte read from memory
   ;
   ; uses  : af, bc, de, hl

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_sms_cxy2saddr      ; hl = screen map address
   ex de,hl
   
   ; ix = rect *
   ; de = screen map address
   ; hl = void *src
   
   ld c,(ix+3)                 ; c = rect.height
   ld b,0
   
copy_loop:

   push bc
   push de
   
   ld c,(ix+1)
   sla c                       ; c = rect.width * 2
   
   call asm_sms_memcpy_mem_to_vram
   
   ; hl = next screen map address
   ; de = next void *src
   
   pop hl
   
   ld c,64
   add hl,bc
   
   ex de,hl
   
   pop bc
   
   dec c
   jr nz, copy_loop
   
   ret
