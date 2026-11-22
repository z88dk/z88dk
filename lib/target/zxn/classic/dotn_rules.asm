;       NextZXOS dotn command: configuration
;
;       Every symbol can be overridden with -pragma-define:NAME=value
;       Appmake reads the __DOTN_* symbols from the map file.

    ;; Temporary stack in divmmc memory, used while the loader runs and
    ;; while the command line is parsed.  It is internal: the program's own
    ;; stack is set by REGISTER_SP as for any other classic target (default
    ;; top of memory).  DOTN_REGISTER_SP is accepted as an override for
    ;; compatibility with the newlib dotn.

    IFDEF DOTN_REGISTER_SP
        defc __DOTN_DIVMMC_SP = DOTN_REGISTER_SP
    ELSE
        defc __DOTN_DIVMMC_SP = 0x4000
    ENDIF

    ;; last ram page in page table

    PUBLIC __DOTN_LAST_PAGE

    IFNDEF DOTN_LAST_PAGE
        defc DOTN_LAST_PAGE = __ZXNEXT_LAST_PAGE
    ENDIF

    IF DOTN_LAST_PAGE < 11
        error "DOTN_LAST_PAGE must be at least 11"
    ELSE
        IF DOTN_LAST_PAGE > __ZXNEXT_LAST_PAGE
            error "DOTN_LAST_PAGE cannot exceed 223"
        ELSE
            defc __DOTN_LAST_PAGE = DOTN_LAST_PAGE
        ENDIF
    ENDIF

    ;; last divmmc page in divmmc table

    PUBLIC __DOTN_LAST_DIVMMC

    IFNDEF DOTN_LAST_DIVMMC
        defc DOTN_LAST_DIVMMC = -1
    ENDIF

    IF DOTN_LAST_DIVMMC > __ZXNEXT_LAST_DIVMMC
        error "DOTN_LAST_DIVMMC cannot exceed 15"
    ELSE
        defc __DOTN_LAST_DIVMMC = DOTN_LAST_DIVMMC
    ENDIF

    ;; number of extra ram pages to allocate

    PUBLIC __DOTN_NUM_EXTRA

    IFNDEF DOTN_NUM_EXTRA
        defc DOTN_NUM_EXTRA = 0
    ENDIF

    defc __DOTN_NUM_EXTRA = DOTN_NUM_EXTRA

    ;; set bits indicate mmus that should be allocated in the main bank

    PUBLIC __DOTN_MAIN_OVERLAY_MASK

    IFNDEF DOTN_MAIN_OVERLAY_MASK
        defc DOTN_MAIN_OVERLAY_MASK = 0
    ENDIF

    defc __DOTN_MAIN_OVERLAY_MASK = DOTN_MAIN_OVERLAY_MASK & 0xff

    ;; set bits indicate mmus that should not be allocated in the main bank

    PUBLIC __DOTN_MAIN_ABSOLUTE_MASK

    IFNDEF DOTN_MAIN_ABSOLUTE_MASK
        defc DOTN_MAIN_ABSOLUTE_MASK = 0
    ENDIF

    defc __DOTN_MAIN_ABSOLUTE_MASK = DOTN_MAIN_ABSOLUTE_MASK & 0xff

    ;; where the main binary lives (must be 0x4000 or above, appmake treats
    ;; anything below as part of the 8k dot command)

    IFNDEF CRT_ORG_MAIN
        defc CRT_ORG_MAIN = 0x8000
    ENDIF
