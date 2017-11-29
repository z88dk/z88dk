__allocate_pages_begin:

;; PHASE __SYSVAR_TSTACK - (__allocate_pages_end - __allocate_pages_begin) + 1
;;
;; PHASE does not allow forward labels so this phase statement is illegal see issue #541
;; Instead we rely on relocatable code here and compute the destination address

defc abs_allocate_len    = __allocate_pages_end - __allocate_pages_begin
defc abs_allocate_pages  = __SYSVAR_TSTACK - abs_allocate_len + 1
defc abs_allocated_pages = allocated_pages - allocate_pages + abs_allocate_pages

allocate_pages:

   push bc
   
   ld hl,__nextos_rc_banktype_zx * 256 + __nextos_rc_bank_total
   call __NEXTOS_IDE_BANK
   
   pop bc                      ; b = num_pages
   ret nc                      ; if error
   
   ld a,e
   cp b
   ccf
   ret nc                      ; if avail_pages < num_pages

   ld hl,abs_allocated_pages

allocate_pages_loop:

   push bc
   push hl
   
   ld hl,__nextos_rc_banktype_zx * 256 + __nextos_rc_bank_alloc
   call __NEXTOS_IDE_BANK
   
   pop hl
   
   ld (hl),e
   inc hl
   
   pop bc
   djnz allocate_pages_loop
   
   scf
   ret

allocated_pages:

   defs 6,0xff

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

   ld b,6
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
   ret

deallocated_pages:

   defs 6,0xff

;; DEPHASE

__deallocate_pages_end:
