; unsigned char extended_sna_load(unsigned char handle)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_extended_sna_load

EXTERN error_znc
EXTERN __esxdos_error_mc

IF __ZXNEXT

asm_extended_sna_load:

   ; load pages stored in an extended sna into memory
   ; uses mmu2 to load pages
   ;
   ; enter : l = handle
   ;
   ; exit  : success
   ;
   ;            l = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            l = -1
   ;            carry set, errno set
   ;
   ; uses  : all except iy

   ; seek past end of standard sna
   
   push hl
   
   ld a,l
   
   ld bc,0x2
   ld de,0x001f
   
   ld l,__ESXDOS_SEEK_SET

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_SEEK
   
   pop hl
   jp c, __esxdos_error_mc

load_page_loop:

   push hl
   
   ld a,l                      ; a = handle
   ld hl,destination_page

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   ld bc,1
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ
   
   pop de
   jp c, __esxdos_error_mc
   
   ld a,b
   or c

   jp z, error_znc             ; nothing read indicates eof
   
   ld a,(destination_page)
   inc a
   
   jp z, error_znc             ; if stop marker met
   
   ; load into page
   
   dec a
   mmu2 a
   
   ; verify the page is valid
   
   ld hl,0x4000                ; destination is mmu2
   
   ld a,(hl)
   cpl
   ld (hl),a
   cp (hl)
   
   ld a,__ESXDOS_EVERIFY
   jp nz, __esxdos_error_mc
   
   push de
   
   ld a,e                      ; a = handle

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   ld bc,0x2000                ; read 8k
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ
   
   mmu2 10                     ; restore page 10
   
   pop de
   jp c, __esxdos_error_mc
   
   ld hl,0x2000
   sbc hl,bc
   
   ex de,hl
   jr z, load_page_loop        ; if page loaded successfully
   
   ld a,__ESXDOS_EIO           ; indicate io error if entire 8k not read
   jp __esxdos_error_mc


SECTION bss_esxdos

destination_page:
   defb 0

ELSE

defc asm_extended_sna_load = __esxdos_error_mc

ENDIF
