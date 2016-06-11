; CALLER linkage for function pointers

SECTION code_clib
PUBLIC ba_AddMem
PUBLIC _ba_AddMem
EXTERN BAAddMem

.ba_AddMem
._ba_AddMem

   ld hl,8
   add hl,sp
   ld c,(hl)
   dec hl
   dec hl
   ld b,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   jp BAAddMem
