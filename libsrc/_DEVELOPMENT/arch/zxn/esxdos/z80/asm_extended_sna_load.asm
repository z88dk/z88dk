; unsigned char extended_sna_load(char *sna_name)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_extended_sna_load

EXTERN error_znc
EXTERN __esxdos_error_mc

asm_extended_sna_load:

   ; load pages stored in an extended sna into memory
   ; uses mmu2 to load pages
   ;
   ; enter : hl = char *sna_name
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
   
   ld a,'*'
   ld b,__ESXDOS_MODE_READ | __ESXDOS_MODE_OPEN_EXIST

IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN
   
   jp c, __esxdos_error_mc
   
   ; a = file handle
   
   push af
   
   ld bc,0x2
   ld de,0x001f                ; seek past end of actual 128k sna
   
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
   
   jr c, close_error

load_page_loop:

   ; stack = file handle
   
   pop af                      ; a = file handle
   push af
   
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
   
   jr c, close_error
   
   ld a,b
   or c

   jr z, close_success         ; nothing read indicates eof
   
   ; load into page
   
   ld a,(destination_page)
   mmu2 a
   
   pop af                      ; a = file handle
   push af
   
   ld hl,0x4000                ; destination is mmu2

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
   
   jr c, close_error
   
   ld hl,0x2000
   sbc hl,bc
   
   jr z, load_page_loop        ; if page loaded successfully
   
   ld a,__ESXDOS_EIO           ; indicate io error if entire 8k not read

close_error:

   pop hl                      ; h = file handle
   push af                     ; save error code
   
   ld a,h
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   pop af                      ; a = error code
   jp __esxdos_error_mc
   
close_success:

   pop af                      ; a = file handle
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   jp error_znc


SECTION bss_arch

destination_page:
   defb 0
