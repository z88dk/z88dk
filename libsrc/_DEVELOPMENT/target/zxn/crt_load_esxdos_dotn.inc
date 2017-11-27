   ;;
   ;; attempt to load extended binary
   ;;

   ld a,'$'
   ld hl,__esxdos_dtn_fname
   ld b,__ESXDOS_MODE_OPEN_EXIST | __ESXDOS_MODE_READ
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN

   jr c, load_unsuccessful

   push af                     ; save file handle

   EXTERN __DTN_END_tail
   
   ld bc,__DTN_END_tail - __DTN_head
   ld hl,__DTN_head
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ

   pop hl                      ; h = file handle
   push af
   
   ld a,h
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   pop af

   jr nc, load_successful

load_unsuccessful:

   ld l,a
   ld h,0
   
   push hl   
   jr error_load

load_successful:
