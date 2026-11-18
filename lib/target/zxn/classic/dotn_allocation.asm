;       Allocation tables for NextZXOS dotn commands
;
;       Do not alter this file.  Appmake fills in the table contents when the
;       dotn command is built (see zxn_dotn_command() in appmake/zx-util.c).
;
;       To make your own allocation map, copy this file to your local directory,
;       modify it there and name it the same, then replace the definition of
;       "__appmake_handle" with "__user_handle" so appmake leaves the tables alone.

    PUBLIC __appmake_handle

__appmake_handle:

;   PUBLIC __user_handle
;
;__user_handle:

    PUBLIC __z_page_sz
    PUBLIC __z_extra_sz

    ; z_page_sz must be at least 11
    ; z_extra_sz can be 0

__z_page_sz:            defb __DOTN_LAST_PAGE + 1   ; must be in this order
__z_extra_sz:           defb __DOTN_NUM_EXTRA       ; must be in this order

    PUBLIC __z_page_alloc_table
    PUBLIC __z_extra_alloc_table

    ; 0xff = skip
    ; 0xfe = allocate but do not load
    ; 0xfd = load but do not allocate
    ; 0xfc = allocate and load

__z_page_alloc_table:   defs __DOTN_LAST_PAGE + 1, 0xff    ; must be in this order
__z_extra_alloc_table:  defs __DOTN_NUM_EXTRA, 0xfe        ; must be in this order

    PUBLIC __z_page_table
    PUBLIC __z_extra_table

    ; logical to physical page mapping, normally 1:1 (appmake fills this in)
    ; entries are overwritten when a page is allocated

__z_page_table:         defs __DOTN_LAST_PAGE + 1, 0xff    ; must be in this order
__z_extra_table:        defs __DOTN_NUM_EXTRA              ; must be in this order

IF __DOTN_LAST_DIVMMC >= 0

    PUBLIC __z_div_sz

__z_div_sz:             defb __DOTN_LAST_DIVMMC + 1

    PUBLIC __z_div_alloc_table

__z_div_alloc_table:    defs __DOTN_LAST_DIVMMC + 1, 0xff

    PUBLIC __z_div_table

__z_div_table:          defs __DOTN_LAST_DIVMMC + 1, 0xff

ENDIF
