;; fob_blob will point at an address after the end of the program

SECTION MAIN_END

PUBLIC _fob_blob

_fob_blob:


;; place this code in divmmc memory

SECTION code_dot

PUBLIC _memory_page_in_mmu6
PUBLIC _memory_page_in_mmu7

PUBLIC _memory_restore_mmu6
PUBLIC _memory_restore_mmu7

PUBLIC _memory_page_in_dir
PUBLIC _memory_restore_dir

EXTERN __z_page_table
EXTERN __z_extra_table

_memory_page_in_mmu6:

   ; enter :  l = logical page number
   ; uses  : af, de, hl

   ld h,0
   ld de,__z_extra_table
   
   add hl,de
   
   ld a,(hl)
   mmu6 a
   
   ret

_memory_page_in_mmu7:

   ; enter :  l = logical page number
   ; uses  : af, de, hl

   ld h,0
   ld de,__z_extra_table
   
   add hl,de
   
   ld a,(hl)
   mmu7 a
   
   ret

_memory_restore_mmu6:

   ; uses : a
   
   ld a,(__z_page_table + 0)
   mmu6 a
   
   ret

_memory_restore_mmu7:

   ; uses : a
   
   ld a,(__z_page_table + 1)
   mmu7 a
   
   ret

_memory_page_in_dir:

   ; enter :  l = logical page number
   ; uses  : af, de, hl
   
   ld h,0
   ld de,__z_extra_table
   
   add hl,de

   ld a,(hl)
   mmu6 a
   
   inc hl
   
   ld a,(hl)
   mmu7 a
   
   ret

_memory_restore_dir:

   ; uses : a
   
   call _memory_restore_mmu6
   jp _memory_restore_mmu7
