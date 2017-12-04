__allocate_pages_begin:

;; PHASE __SYSVAR_TSTACK - (__allocate_pages_end - __allocate_pages_begin) + 1
;;
;; PHASE does not allow forward labels so this phase statement is illegal see issue #541
;; Instead we rely on relocatable code here and compute the destination address

defc abs_allocate_len    = __allocate_pages_end - __allocate_pages_begin
defc abs_allocate_pages  = __SYSVAR_TSTACK - abs_allocate_len + 1
defc abs_allocated_pages = allocated_pages - allocate_pages + abs_allocate_pages

allocate_pages:

   ; hl = mangled 1ffd/7ffd restore state
   ;  b = num pages needed
   
   push hl
   
   call __SYSVAR_SWAP          ; bank in NextOS
   di

   ld hl,abs_allocated_pages

allocate_pages_loop:

   push bc
   push hl
   
   ld hl,__nextos_rc_banktype_zx * 256 + __nextos_rc_bank_alloc
   call __NEXTOS_IDE_BANK
   
   pop hl
   pop bc
   
   jr nc, allocate_exit        ; if allocation error
   
   ld (hl),e
   inc hl

   djnz allocate_pages_loop
   
   scf

allocate_exit:

   pop hl                      ; h = mangled BANK678, l = mangled BANKM
   
   ld a,h
   ld (__SYSVAR_BANK678),a
   
   ld a,l
   ld (__SYSVAR_BANKM),a
   
   jp __SYSVAR_SWAP

allocated_pages:

   defs DOTN_EXTRA_PAGES + 6,0xff

;; DEPHASE

__allocate_pages_end:

;;

__deallocate_pages_begin:

;; PHASE __SYSVAR_TSTACK - (__deallocate_pages_end - __deallocate_pages_begin) + 1
;;
;; PHASE does not allow forward labels so this phase statement is illegal see issue #541
;; Instead we rely on relocatable code here and compute the destination address

defc abs_deallocate_len    = __deallocate_pages_end - __deallocate_pages_begin
defc abs_deallocate_pages  = __SYSVAR_TSTACK - abs_deallocate_len + 1
defc abs_deallocated_pages = deallocated_pages - deallocate_pages + abs_deallocate_pages

deallocate_pages:

   ; hl = mangled 1ffd/7ffd restore state
   
   push hl
   
   call __SYSVAR_SWAP          ; bank in NextOS
   di
   
   ld b,DOTN_EXTRA_PAGES + 6
   ld hl,abs_deallocated_pages

deallocate_pages_loop:

   ld e,(hl)
   inc hl
   
   inc e
   jr z, deallocate_skip
   dec e
   
   push bc
   push hl
   
   ld hl,__nextos_rc_banktype_zx * 256 + __nextos_rc_bank_free
   call __NEXTOS_IDE_BANK
   
   pop hl
   pop bc

deallocate_skip:

   djnz deallocate_pages_loop

deallocate_exit:

   pop hl                      ; h = mangled BANK678, l = mangled BANKM
   
   ld a,h
   ld (__SYSVAR_BANK678),a
   
   ld a,l
   ld (__SYSVAR_BANKM),a
   
   jp __SYSVAR_SWAP

deallocated_pages:

   defs DOTN_EXTRA_PAGES + 6,0xff

;; DEPHASE

__deallocate_pages_end:
