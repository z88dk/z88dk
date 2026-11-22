;       Startup for NextZXOS "dotn" commands (classic library)
;
;       A dotn command is a dot command that can be bigger than 8k.  The first
;       8k of the file is loaded to 0x2000 by NextZXOS and runs the loader
;       below.  The loader then
;
;         - allocates ram pages (and optionally divmmc pages) from NextZXOS
;         - reads the rest of the file into them
;         - pages the main binary (org CRT_ORG_MAIN, default 0x8000) into mmu2-7
;         - runs the C program
;         - maps everything back and frees the pages on exit
;
;       Appmake (--dotn) builds the file and fills in the allocation tables in
;       dotn_allocation.asm.  Everything that the loader uses before the main
;       binary is paged in must live in this stub (the code at org 0x2000).
;
;       This is the classic counterpart of newlib's zxn_crt_768.asm.m4.
;
;       Options (-pragma-define:NAME=value), see dotn_rules.asm
;
;           DOTN_LAST_PAGE, DOTN_LAST_DIVMMC, DOTN_NUM_EXTRA,
;           DOTN_MAIN_OVERLAY_MASK, DOTN_MAIN_ABSOLUTE_MASK, CRT_ORG_MAIN
;
;       The program stack is REGISTER_SP (default: top of memory).

    INCLUDE "target/zx/def/esxdos.def"

    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__register_sp = 0            ; main program stack: top of memory
    defc    TAR__crt_enable_eidi = 0x20     ; ei on exit
    defc    TAR__crt_interrupt_mode_exit = 1

IF !DEFINED_CRT_COMMANDLINE_REDIRECTION
    define  DEFINED_CRT_COMMANDLINE_REDIRECTION
    defc    CRT_COMMANDLINE_REDIRECTION = 0
ENDIF

    INCLUDE "crt/classic/crt_rules.inc"
    INCLUDE "target/zxn/classic/dotn_rules.asm"

    ; The 8k stub must be at 0x2000

    defc    CRT_ORG_CODE = 0x2000

    defc    DIVMMC_BUFSZ = 64


    org     CRT_ORG_CODE

program:

    ;; remember the command line, and what we must restore for basic

    ld      l,c
    ld      h,b
    ld      (__command_line),hl

    push    iy
    exx
    push    hl

    ld      (__sp),sp

    ;; check for nextos

    rst     __ESX_RST_SYS
    defb    __ESX_M_DOSVERSION

    ; __return_status is statically initialized to error_msg_nextos

    jp      c, error_crt            ; if esxdos present

    or      a
    jp      nz, error_crt           ; if nextos is in 48k mode

IF __NEXTOS_VERSION > 0

    ld      hl,+(((__NEXTOS_VERSION / 1000) % 10) << 12) + (((__NEXTOS_VERSION / 100) % 10) << 8) + (((__NEXTOS_VERSION / 10) % 10) << 4) + (__NEXTOS_VERSION % 10)

    ex      de,hl
    sbc     hl,de

    jp      c, error_crt            ; if nextos version not met

ENDIF

IF __DOTN_LAST_DIVMMC >= 0

    ;; reserve space for the divmmc loader (relocated to basic's workspace)

    ld      bc,load_divmmc_end - load_divmmc_begin + DIVMMC_BUFSZ

    rst     __ESX_RST_ROM
    defw    __ROM3_BC_SPACES

    ld      hl,load_divmmc_begin
    ld      bc,load_divmmc_end - load_divmmc_begin

    ld      (__load_divmmc),de      ; address of divmmc load function

    ldir                            ; copy load function to final location

    ld      (__load_buffer),de      ; address of load buffer

    in      a,(__IO_DIVIDE_CONTROL)
    ld      (__divide_control),a    ; save esxdos divmmc control

ENDIF

    ;; speed up the load process

    call    turbo_save
    call    turbo_14

    ;; save current mmu state

    ld      hl,__z_saved_mmu_state
    call    read_mmu_state

    ;; save basic bank state

    ld      hl,(__SYSVAR_BANKM)
    ld      a,(__SYSVAR_BANK678)
    ld      h,a
    ld      (__z_saved_bank_state),hl

    ;; get handle to load rest of dot command

    rst     __ESX_RST_SYS
    defb    __ESX_M_GETHANDLE

    ld      c,a                     ; c = file handle

    ;; select mmu for loading

    ld      ix,load_using_mmu7

    ld      a,(__sp + 1)

    cp      0xe0
    jr      c, end_select

    ld      ix,load_using_mmu3

end_select:

    ;; allocate and load pages

    ld      hl,(__z_page_sz)        ; num pages and num extra

    ld      a,l
    add     a,h
    ld      b,a                     ; b = total number of pages

    jr      z, alloc_cancel         ; if no pages are being allocated

    ld      hl,__z_page_alloc_table
    ld      de,__z_page_table

alloc_loop:

    ;  b = num pages
    ;  c = file handle
    ; de = logical table position
    ; hl = alloc table position
    ; ix = mmu function

    ld      a,(hl)

    cp      0xff
    jr      z, alloc_not_used       ; 0xff indicates page not used

    cp      0xfc                    ; alloc flag < 0xfc is undefined
    jr      nc, alloc_continue

alloc_error:

    ld      hl,error_msg_malformed_alloc
    jp      terminate

alloc_continue:

    push    de                      ; save logical table position

    bit     0,a
    jr      nz, alloc_load          ; if allocation not requested

    ;; allocate

    push    ix                      ; save mmu function
    push    bc                      ; save num pages, file handle
    push    hl                      ; save allocation table position

    ld      hl,__nextos_rc_bank_alloc + (__nextos_rc_banktype_zx * 256)

    exx

    ld      de,__NEXTOS_IDE_BANK
    ld      c,7

    rst     __ESX_RST_SYS
    defb    __ESX_M_P3DOS

    ld      hl,error_msg_out_of_memory
    jp      nc, terminate

    pop     hl                      ; hl = allocation table position
    pop     bc                      ; b = num pages, c = file handle
    pop     ix                      ; ix = mmu function

    ld      a,(hl)                  ; a = allocation flag
    ld      (hl),e                  ; write allocated bank into allocation table

    ex      (sp),hl
    ld      (hl),e                  ; write allocated bank into logical table
    ex      (sp),hl

alloc_load:

    ;; load

    ;  a = alloc flag
    ;  b = num pages
    ;  c = file handle
    ; hl = alloc table position
    ; ix = mmu function
    ; stack = logical table position

    and     0x02
    jr      nz, alloc_no_load       ; if load not requested

    pop     de
    push    de                      ; de = logical table position

    push    bc                      ; save num pages, file handle
    push    hl                      ; save alloc table
    push    ix                      ; save mmu function

    ld      a,(de)                  ; a = destination physical page
    call    call_ix                 ; carry is reset to page in target page

    ld      a,c                     ; file handle
    ld      bc,0x2000               ; page size

    rst     __ESX_RST_SYS
    defb    __ESX_F_READ

    ld      l,a
    ld      h,0

    jp      c, terminate            ; if read error

    ld      hl,0x2000
    sbc     hl,bc

    ld      hl,__ESX_EIO
    jp      nz, terminate           ; if did not read 0x2000 bytes

    pop     ix                      ; restore mmu function
    pop     hl                      ; hl = alloc table
    pop     bc                      ; b = num pages, c = handle

    scf
    call    call_ix                 ; carry is set to restore target page

alloc_no_load:

    pop     de

alloc_not_used:

    ;  b = num pages
    ;  c = file handle
    ; de = logical table position
    ; hl = alloc table position
    ; ix = mmu function

    inc     hl
    inc     de

    djnz    alloc_loop

alloc_cancel:

IF __DOTN_LAST_DIVMMC >= 0

    ;; allocate and load divmmc pages

    ld      a,(__z_div_sz)          ; num divmmc pages

    or      a
    jr      z, div_alloc_cancel

    ld      b,a

    ld      hl,__z_div_alloc_table
    ld      de,__z_div_table

div_alloc_loop:

    ;  b = num pages
    ;  c = file handle
    ; de = div logical table position
    ; hl = div alloc table position

    ld      a,(hl)

    cp      0xff
    jr      z, div_alloc_not_used   ; 0xff indicates page not used

    cp      0xfc                    ; alloc flag < 0xfc is undefined
    jr      c, alloc_error

    push    de                      ; save logical table position

    bit     0,a
    jr      nz, div_alloc_load      ; if allocation not requested

    ;; allocate

    push    bc                      ; save num pages, file handle
    push    hl                      ; save allocation table position

    ld      hl,__nextos_rc_bank_alloc + (__nextos_rc_banktype_mmc * 256)

    exx

    ld      de,__NEXTOS_IDE_BANK
    ld      c,7

    rst     __ESX_RST_SYS
    defb    __ESX_M_P3DOS

    ld      hl,error_msg_divmmc_out_of_memory
    jp      nc, terminate

    pop     hl                      ; hl = allocation table position
    pop     bc                      ; b = num pages, c = file handle

    ld      a,(hl)                  ; a = allocation flag
    ld      (hl),e                  ; write allocated bank into allocation table

    ex      (sp),hl
    ld      (hl),e                  ; write allocated bank into logical table
    ex      (sp),hl

div_alloc_load:

    ;; load

    ;  a = alloc flag
    ;  b = num pages
    ;  c = file handle
    ; hl = alloc table position
    ; stack = logical table position

    and     0x02
    jr      nz, div_alloc_no_load   ; if load not requested

    pop     de
    push    de                      ; de = logical table position

    push    bc                      ; save num pages, file handle
    push    hl                      ; save alloc table

    ld      a,(de)                  ; a = physical divmmc page to load into
    ld      de,(__load_buffer)      ; de = load buffer
    ld      hl,__divide_control
    ld      b,(hl)                  ; b = esxdos divmmc control
    ld      hl,(__load_divmmc)      ; address of divmmc loader

    call    call_hl

    ld      a,h
    or      l
    jp      nz, terminate           ; if error, hl = error code

    pop     hl                      ; hl = alloc table
    pop     bc                      ; b = num pages, c = file handle

div_alloc_no_load:

    pop     de

div_alloc_not_used:

    inc     hl
    inc     de

    djnz    div_alloc_loop

div_alloc_cancel:

ENDIF

    ;; parse command line in divmmc memory

    ld      sp,__DOTN_DIVMMC_SP     ; move stack to divmmc memory

    ld      hl,(__command_line)

    ex      de,hl
    ld      hl,-128                 ; copy argument to stack, max 128 characters
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    ld      bc,128
    ldir
    ld      hl,0
    add     hl,sp

    ; (terminated by $00, $0d or ':')

    ld      bc,$7f00

find_argument_end:

    ld      a,(hl)
    and     a
    jr      z,found_end
    cp      $0d
    jr      z,found_end
    cp      ':'
    jr      z,found_end
    inc     hl
    inc     c
    djnz    find_argument_end

found_end:

    ld      (hl),0
    ld      b,0

    ; hl = argument ends
    ;  c = length, b = 0

    INCLUDE "crt/classic/crt_command_line.inc"

    ; bc = argc, hl = argv (in divmmc memory, so it stays mapped)

    ld      (__argc),bc
    ld      (__argv),hl

    ;; page main bank into memory

    ld      hl,(__z_page_table+10)

    ld      a,l
    mmu2    a

    ld      a,h
    mmu3    a

    ld      hl,(__z_page_table+4)

    ld      a,l
    mmu4    a

    ld      a,h
    mmu5    a

    ld      hl,(__z_page_table+0)

    ld      a,l
    mmu6    a

    ld      a,h
    mmu7    a

    ;; move stack to main bank

    INCLUDE "crt/classic/crt_init_sp.inc"

    ;; register basic error intercept so pages are freed

    ld      hl,__basic_error_intercept

    rst     __ESX_RST_SYS
    defb    __ESX_M_ERRH

    ;; initialise bss, data, atexit

    call    crt0_init

    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ;; restore original cpu speed

    call    turbo_restore

    ;; main

    ld      hl,(__argv)
    ld      bc,(__argc)

    push    hl                      ; argv
    push    bc                      ; argc

    call    _main

    pop     bc
    pop     bc

error_basic:

__Exit:

    push    hl                      ; save return status
    call    crt0_exit
    pop     hl                      ; hl = return status

    ;; terminate

    inc     h
    dec     h

    jr      z, terminate            ; if there is no custom error message

    ;; must copy the error message to divmmc memory

    ld      de,__DOTN_DIVMMC_SP - 128 - 10
    ld      bc,128

custom_loop:

    ld      a,(hl)
    and     0x80

    ldi

    jr      nz, custom_done
    jp      pe, custom_loop

    dec     de

    ex      de,hl
    set     7,(hl)

custom_done:

    ld      hl,__DOTN_DIVMMC_SP - 128 - 10

terminate:

    call    turbo_14                ; speed up to 14MHz

    ld      (__return_status),hl
    ld      sp,__DOTN_DIVMMC_SP     ; stack to divmmc memory

    ;; restore banked state

    ;; unlock port 7ffd

    ld      bc,__IO_NEXTREG_REG

    ld      a,__REG_PERIPHERAL_3
    out     (c),a

    inc     b

    in      a,(c)
    or      __RP3_UNLOCK_7FFD

    out     (c),a

    ;; restore sys vars area

    ld      iy,__SYS_IY             ; expected by rom isr
    im      1                       ; rom isr will not run until the stack is moved out of divmmc

    ld      a,(__z_saved_mmu_state + 2)
    mmu2    a

    ;; restore bank state

    ld      hl,(__z_saved_bank_state)

    ld      a,h
    ld      (__SYSVAR_BANK678),a
    ld      a,l
    ld      (__SYSVAR_BANKM),a

    ld      bc,__IO_1FFD
    out     (c),h                   ; 1ffd, 7ffd, dffd=0
    xor     a
    ld      b,__IO_DFFD/256         ; must precede 7ffd in case of locking
    out     (c),a
    ld      b,__IO_7FFD/256
    out     (c),l

    ;; restore mmu state

    ld      hl,__z_saved_mmu_state
    call    write_mmu_state

    ld      sp,(__sp)               ; back to basic's stack

    ;; deallocate pages

    ld      hl,(__z_page_sz)        ; pages and extra

    ld      a,l
    add     a,h
    ld      b,a                     ; b = total number of pages

    jr      z, dealloc_cancel

    ld      hl,__z_page_alloc_table

dealloc_loop:

    ld      a,(hl)

    cp      __ZXNEXT_LAST_PAGE + 1
    jr      nc, dealloc_not_used

    push    bc
    push    hl

    ld      e,a
    ld      hl,__nextos_rc_bank_free + (__nextos_rc_banktype_zx * 256)

    exx

    ld      de,__NEXTOS_IDE_BANK
    ld      c,7

    rst     __ESX_RST_SYS
    defb    __ESX_M_P3DOS

    pop     hl
    pop     bc

dealloc_not_used:

    inc     hl
    djnz    dealloc_loop

dealloc_cancel:

IF __DOTN_LAST_DIVMMC >= 0

    ;; deallocate divmmc pages

    ld      a,(__z_div_sz)          ; divmmc pages

    or      a
    jr      z, div_dealloc_cancel

    ld      b,a                     ; b = total number of pages

    ld      hl,__z_div_alloc_table

div_dealloc_loop:

    ld      a,(hl)

    cp      __ZXNEXT_LAST_DIVMMC + 1
    jr      nc, div_dealloc_not_used

    push    bc
    push    hl

    ld      e,a
    ld      hl,__nextos_rc_bank_free + (__nextos_rc_banktype_mmc * 256)

    exx

    ld      de,__NEXTOS_IDE_BANK
    ld      c,7

    rst     __ESX_RST_SYS
    defb    __ESX_M_P3DOS

    pop     hl
    pop     bc

div_dealloc_not_used:

    inc     hl
    djnz    div_dealloc_loop

div_dealloc_cancel:

ENDIF

    ;; return to basic

    INCLUDE "crt/classic/crt_exit_eidi.inc"

    call    turbo_restore           ; restore original z80 speed

error_crt:

    ; direct jumps here have not saved original z80 speed

    ld      sp,(__sp)

    pop     hl
    exx
    pop     iy

    ld      hl,(__return_status)

    ; If you exit with carry set and A<>0, the corresponding error code will be printed in BASIC.
    ; If carry set and A=0, HL should be pointing to a custom error message (with last char +$80 as END marker).
    ; If carry reset, exit cleanly to BASIC

    ld      a,h
    or      l
    ret     z                       ; status == 0, no error

    scf
    ld      a,l

    inc     h
    dec     h

    ret     z                       ; status < 256, basic error code in status&0xff

    ld      a,0                     ; status = & custom error message
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__basic_error_intercept:

    ; basic error has occurred during a rst $10 or rst $18
    ; must free allocated pages and close open files

    ; enter :  a = basic error code - 1
    ;         de = return address to restart

    ld      hl,error_msg_d_break

    cp      __ERRB_D_BREAK_CONT_REPEATS - 1
    jp      z, error_basic

    ld      hl,__ESX_ENONSENSE
    jp      error_basic


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TURBO MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; speed up the whole load process by going 14MHz
; the speed set by the user is restored before starting the program
; and before returning

turbo_save:

    ld      bc,__IO_NEXTREG_REG

    ld      a,__REG_TURBO_MODE
    out     (c),a

    inc     b

    in      a,(c)
    ld      (__turbo_save),a

    ret

turbo_restore:

    ld      a,(__turbo_save)

    nextreg __REG_TURBO_MODE,a
    ret

turbo_14:

    nextreg __REG_TURBO_MODE,__RTM_14MHZ
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MMU UTILITIES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; these cannot be library calls: the library is in the main binary,
; which is not paged in while the loader runs

; hl = address to store the 8 mmu pages

read_mmu_state:

    ld      bc,__IO_NEXTREG_REG
    ld      de,0x0800 + __REG_MMU0

read_mmu_loop:

    out     (c),e
    inc     b
    ini
    inc     e
    dec     d
    jr      nz, read_mmu_loop

    ret

; hl = address of the 8 saved mmu pages

write_mmu_state:

    ld      bc,__IO_NEXTREG_REG
    ld      de,0x0800 + __REG_MMU0

write_mmu_loop:

    ld      a,(hl)
    inc     hl
    cp      __ZXNEXT_LAST_PAGE + 1
    jr      c, write_mmu
    ld      a,e
    cp      __REG_MMU2
    jr      nc, write_mmu_skip
    ld      a,0xff

write_mmu:

    out     (c),e
    inc     b
    out     (c),a
    dec     b

write_mmu_skip:

    inc     e
    dec     d
    jr      nz, write_mmu_loop

    ret

call_ix:

    defb    0xdd

call_hl:

    jp      (hl)

; load using mmu3
;
; enter : a = physical page, carry reset to page in, carry set to restore
; exit  : hl = address the page appears at

load_using_mmu3:

    jr      c, load_restore_mmu3    ; carry set indicates restore page

load_set_mmu3:

    ld      hl,0x6000               ; start of mmu3

    mmu3    a
    ret

load_restore_mmu3:

    ld      a,(__z_saved_mmu_state + 3)
    mmu3    a

    ret

; load using mmu7

load_using_mmu7:

    jr      c, load_restore_mmu7    ; carry set indicates restore page

load_set_mmu7:

    ld      hl,0xe000               ; start of mmu7

    mmu7    a
    ret

load_restore_mmu7:

    ld      a,(__z_saved_mmu_state + 7)
    mmu7    a

    ret

IF __DOTN_LAST_DIVMMC >= 0

;; divmmc loader
;;
;; This is copied to basic's workspace and run from there, because the dot
;; command is paged out while a divmmc page is mapped at 0x2000.  It must
;; be position independent and not touch any variable in the dot command.
;;
;; enter :  a = divmmc page to load into
;;          b = esxdos divmmc control (to restore)
;;          c = file handle
;;         de = DIVMMC_BUFSZ byte buffer
;; exit  : hl = 0 on success, else error code

load_divmmc_begin:

    or      __IDC_CONMEM

    push    de                      ; buffer
    push    bc                      ; b = divmmc control, c = handle
    push    af                      ; a = page + conmem

    ld      de,0x2000               ; destination in divmmc page
    ld      b,8192 / DIVMMC_BUFSZ   ; loop count

    push    de                      ; destination
    push    bc                      ; loop count

    ; ix frame:  +1 loop count   +2 destination   +5 page
    ;            +6 handle       +7 divmmc control  +8 buffer

load_divmmc_loop:

    ld      ix,0
    add     ix,sp                   ; esxdos may not preserve ix

    ld      a,(ix+6)                ; file handle
    ld      l,(ix+8)
    ld      h,(ix+9)                ; buffer
    ld      bc,DIVMMC_BUFSZ

    rst     __ESX_RST_SYS
    defb    __ESX_F_READ

    jr      c, load_divmmc_error

    ld      hl,DIVMMC_BUFSZ
    or      a
    sbc     hl,bc

    ld      hl,__ESX_EIO
    jr      nz, load_divmmc_done    ; if full amount not read

    ld      ix,0
    add     ix,sp

    ld      a,(ix+5)
    out     (__IO_DIVIDE_CONTROL),a ; map destination divmmc page

    ld      l,(ix+8)
    ld      h,(ix+9)                ; hl = buffer
    ld      e,(ix+2)
    ld      d,(ix+3)                ; de = destination
    ld      bc,DIVMMC_BUFSZ

    ldir

    ld      (ix+2),e
    ld      (ix+3),d                ; advance destination

    ld      a,(ix+7)
    out     (__IO_DIVIDE_CONTROL),a ; restore esxdos divmmc page

    dec     (ix+1)
    jr      nz, load_divmmc_loop

    ld      hl,0
    jr      load_divmmc_done

load_divmmc_error:

    ld      l,a
    ld      h,0

load_divmmc_done:

    ld      ix,0
    add     ix,sp

    ld      bc,10
    add     ix,bc
    ld      sp,ix                   ; drop frame, return address on top

    ret

load_divmmc_end:

ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ERROR MESSAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __NEXTOS_VERSION > 0

error_msg_nextos:

    defm    "Requires NextZXOS 128k "

IF ((__NEXTOS_VERSION / 1000) % 10)
    defb    (__NEXTOS_VERSION / 1000) % 10 + '0'
ENDIF

    defb    (__NEXTOS_VERSION / 100) % 10 + '0'
    defb    '.'
    defb    (__NEXTOS_VERSION / 10) % 10 + '0'
    defb    __NEXTOS_VERSION % 10 + '0' + 0x80

ELSE

error_msg_nextos:

    defm    "Requires NextZXOS 128", 'k'+0x80

ENDIF

error_msg_out_of_memory:

    defm    "4 Out of page memor", 'y'+0x80

error_msg_malformed_alloc:

    defm    "Alloc table malforme", 'd'+0x80

error_msg_d_break:

    defm    "D BREAK - no repea", 't'+0x80

IF __DOTN_LAST_DIVMMC >= 0

error_msg_divmmc_out_of_memory:

    defm    "4 Out of divmmc memor", 'y'+0x80

ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUNTIME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_dcal: jp      (hl)            ;Used for function pointer calls

call_rom3:
    exx                      ; Use alternate registers
    ex      (sp),hl          ; get return address
    ld      c,(hl)
    inc     hl
    ld      b,(hl)           ; BC=BASIC address
    inc     hl
    ex      (sp),hl          ; restore return address
    ld      (restart_address),bc
    exx                      ; Back to the regular set
    rst     $18
restart_address:
    defw    0
    ret

__command_line:     defw    0
__argv:             defw    0
__argc:             defw    0
__sp:               defw    0

__turbo_save:       defb    0

IF __DOTN_LAST_DIVMMC >= 0

__load_divmmc:      defw    0
__load_buffer:      defw    0
__divide_control:   defb    0

ENDIF

__return_status:    defw    error_msg_nextos

    PUBLIC  __z_saved_bank_state
    PUBLIC  __z_saved_mmu_state

__z_saved_bank_state:   defw    0
__z_saved_mmu_state:    defs    8

    ;; allocation variables filled in by appmake

    INCLUDE "target/zxn/classic/dotn_allocation.asm"

    INCLUDE "crt/classic/crt_runtime_selection.inc"


    ;; The main binary: everything from here is paged in above 0x4000

    SECTION MAIN
    org     CRT_ORG_MAIN

    INCLUDE "target/zxn/classic/memory_map.asm"

    SECTION rodata_clib
end:            defb    0               ; null file name
