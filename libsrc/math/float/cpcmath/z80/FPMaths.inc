;; MATHS ROUTINES
;;=============================================================================
;;
;;Limited documentation for these can be found at
;;https://www.cpcwiki.eu/index.php/BIOS_Function_Summary

;;=============================================================================
;; REAL: PI to DE
REAL_PI_to_DE:                    ;{{Addr=$2f73 Code Calls/jump count: 0 Data use count: 1}}
        ld      de,PI_const       ;{{2f73:11782f}} 
        jr      REAL_copy_atDE_to_atHL;{{2f76:1819}} 

;;+
;;PI const
PI_const:                         ;{{Addr=$2f78 Data Calls/jump count: 0 Data use count: 1}}
        defb $a2,$da,$0f,$49,$82  ; PI in floating point format 3.14159265

;;===========================================================================================
;; REAL: ONE to DE
REAL_ONE_to_DE:                   ;{{Addr=$2f7d Code Calls/jump count: 4 Data use count: 0}}
        ld      de,ONE_const      ;{{2f7d:11822f}} 
        jr      REAL_copy_atDE_to_atHL;{{2f80:180f}}  (+&0f)

;;+
;;ONE const
ONE_const:                        ;{{Addr=$2f82 Data Calls/jump count: 0 Data use count: 2}}
        defb $00,$00,$00,$00,$81  ; 1 in floating point format

;;===========================================================================================
;;REAL copy atHL to b10e swapped
REAL_copy_atHL_to_b10e_swapped:   ;{{Addr=$2f87 Code Calls/jump count: 3 Data use count: 0}}
        ex      de,hl             ;{{2f87:eb}} 

;;= REAL move DE to b10e
REAL_move_DE_to_b10e:             ;{{Addr=$2f88 Code Calls/jump count: 1 Data use count: 0}}
        ld      hl,internal_REAL_store_3;{{2f88:210eb1}} 
        jr      REAL_copy_atDE_to_atHL;{{2f8b:1804}}  (+&04)

;;---------------------------------------
;;REAL copy atHL to b104
_real_move_de_to_b10e_2:          ;{{Addr=$2f8d Code Calls/jump count: 3 Data use count: 0}}
        ld      de,internal_REAL_store_1;{{2f8d:1104b1}} 

;;= REAL copy atHL to atDE swapped
REAL_copy_atHL_to_atDE_swapped:   ;{{Addr=$2f90 Code Calls/jump count: 2 Data use count: 0}}
        ex      de,hl             ;{{2f90:eb}} 

;;=---------------------------------------
;; REAL copy atDE to atHL
;; HL = points to address to write floating point number to
;; DE = points to address of a floating point number

REAL_copy_atDE_to_atHL:           ;{{Addr=$2f91 Code Calls/jump count: 3 Data use count: 1}}
        push    hl                ;{{2f91:e5}} 
        push    de                ;{{2f92:d5}} 
        push    bc                ;{{2f93:c5}} 
        ex      de,hl             ;{{2f94:eb}} 
        ld      bc,$0005          ;{{2f95:010500}} ##LIT##;WARNING: Code area used as literal
        ldir                      ;{{2f98:edb0}} 
        pop     bc                ;{{2f9a:c1}} 
        pop     de                ;{{2f9b:d1}} 
        pop     hl                ;{{2f9c:e1}} 
        scf                       ;{{2f9d:37}} 
        ret                       ;{{2f9e:c9}} 

;;============================================================================================
;; REAL: INT to real
REAL_INT_to_real:                 ;{{Addr=$2f9f Code Calls/jump count: 2 Data use count: 1}}
        push    de                ;{{2f9f:d5}} 
        push    bc                ;{{2fa0:c5}} 
        or      $7f               ;{{2fa1:f67f}} 
        ld      b,a               ;{{2fa3:47}} 
        xor     a                 ;{{2fa4:af}} 
        ld      (de),a            ;{{2fa5:12}} 
        inc     de                ;{{2fa6:13}} 
        ld      (de),a            ;{{2fa7:12}} 
        inc     de                ;{{2fa8:13}} 
        ld      c,$90             ;{{2fa9:0e90}} 
        or      h                 ;{{2fab:b4}} 
        jr      nz,_real_int_to_real_21;{{2fac:200d}}  (+&0d)
        ld      c,a               ;{{2fae:4f}} 
        or      l                 ;{{2faf:b5}} 
        jr      z,_real_int_to_real_23;{{2fb0:280d}}  (+&0d)
        ld      l,h               ;{{2fb2:6c}} 
        ld      c,$88             ;{{2fb3:0e88}} 
        jr      _real_int_to_real_21;{{2fb5:1804}}  (+&04)
_real_int_to_real_18:             ;{{Addr=$2fb7 Code Calls/jump count: 1 Data use count: 0}}
        dec     c                 ;{{2fb7:0d}} 
        sla     l                 ;{{2fb8:cb25}} 
        adc     a,a               ;{{2fba:8f}} 
_real_int_to_real_21:             ;{{Addr=$2fbb Code Calls/jump count: 2 Data use count: 0}}
        jp      p,_real_int_to_real_18;{{2fbb:f2b72f}} 
        and     b                 ;{{2fbe:a0}} 
_real_int_to_real_23:             ;{{Addr=$2fbf Code Calls/jump count: 1 Data use count: 0}}
        ex      de,hl             ;{{2fbf:eb}} 
        ld      (hl),e            ;{{2fc0:73}} 
        inc     hl                ;{{2fc1:23}} 
        ld      (hl),a            ;{{2fc2:77}} 
        inc     hl                ;{{2fc3:23}} 
        ld      (hl),c            ;{{2fc4:71}} 
        pop     bc                ;{{2fc5:c1}} 
        pop     hl                ;{{2fc6:e1}} 
        ret                       ;{{2fc7:c9}} 

;;============================================================================================
;; REAL: BIN to real
REAL_BIN_to_real:                 ;{{Addr=$2fc8 Code Calls/jump count: 0 Data use count: 1}}
        push    bc                ;{{2fc8:c5}} 
        ld      bc,$a000          ;{{2fc9:0100a0}} 
        call    _real_5byte_to_real_1;{{2fcc:cdd32f}} 
        pop     bc                ;{{2fcf:c1}} 
        ret                       ;{{2fd0:c9}} 

;;============================================================================================
;; REAL 5-byte to real
REAL_5byte_to_real:               ;{{Addr=$2fd1 Code Calls/jump count: 0 Data use count: 1}}
        ld      b,$a8             ;{{2fd1:06a8}} 
_real_5byte_to_real_1:            ;{{Addr=$2fd3 Code Calls/jump count: 1 Data use count: 0}}
        push    de                ;{{2fd3:d5}} 
        call    Process_REAL_at_HL;{{2fd4:cd9c37}} 
        pop     de                ;{{2fd7:d1}} 
        ret                       ;{{2fd8:c9}} 

;;============================================================================================
;; REAL to int
REAL_to_int:                      ;{{Addr=$2fd9 Code Calls/jump count: 1 Data use count: 1}}
        push    hl                ;{{2fd9:e5}} 
        pop     ix                ;{{2fda:dde1}} 
        xor     a                 ;{{2fdc:af}} 
        sub     (ix+$04)          ;{{2fdd:dd9604}} 
        jr      z,_real_to_int_22 ;{{2fe0:281b}}  (+&1b)
        add     a,$90             ;{{2fe2:c690}} 
        ret     nc                ;{{2fe4:d0}} 

        push    de                ;{{2fe5:d5}} 
        push    bc                ;{{2fe6:c5}} 
        add     a,$10             ;{{2fe7:c610}} 
        call    x373d_code        ;{{2fe9:cd3d37}} 
        sla     c                 ;{{2fec:cb21}} 
        adc     hl,de             ;{{2fee:ed5a}} 
        jr      z,_real_to_int_20 ;{{2ff0:2808}}  (+&08)
        ld      a,(ix+$03)        ;{{2ff2:dd7e03}} 
        or      a                 ;{{2ff5:b7}} 
_real_to_int_16:                  ;{{Addr=$2ff6 Code Calls/jump count: 1 Data use count: 0}}
        ccf                       ;{{2ff6:3f}} 
        pop     bc                ;{{2ff7:c1}} 
        pop     de                ;{{2ff8:d1}} 
        ret                       ;{{2ff9:c9}} 

_real_to_int_20:                  ;{{Addr=$2ffa Code Calls/jump count: 1 Data use count: 0}}
        sbc     a,a               ;{{2ffa:9f}} 
        jr      _real_to_int_16   ;{{2ffb:18f9}}  (-&07)
_real_to_int_22:                  ;{{Addr=$2ffd Code Calls/jump count: 1 Data use count: 0}}
        ld      l,a               ;{{2ffd:6f}} 
        ld      h,a               ;{{2ffe:67}} 
        scf                       ;{{2fff:37}} 
        ret                       ;{{3000:c9}} 

;;============================================================================================
;; REAL to bin
REAL_to_bin:                      ;{{Addr=$3001 Code Calls/jump count: 1 Data use count: 1}}
        call    REAL_fix          ;{{3001:cd1430}} 
        ret     nc                ;{{3004:d0}} 

        ret     p                 ;{{3005:f0}} 

_real_to_bin_3:                   ;{{Addr=$3006 Code Calls/jump count: 1 Data use count: 0}}
        push    hl                ;{{3006:e5}} 
        ld      a,c               ;{{3007:79}} 
_real_to_bin_5:                   ;{{Addr=$3008 Code Calls/jump count: 1 Data use count: 0}}
        inc     (hl)              ;{{3008:34}} 
        jr      nz,_real_to_bin_12;{{3009:2006}}  (+&06)
        inc     hl                ;{{300b:23}} 
        dec     a                 ;{{300c:3d}} 
        jr      nz,_real_to_bin_5 ;{{300d:20f9}}  (-&07)
        inc     (hl)              ;{{300f:34}} 
        inc     c                 ;{{3010:0c}} 
_real_to_bin_12:                  ;{{Addr=$3011 Code Calls/jump count: 1 Data use count: 0}}
        pop     hl                ;{{3011:e1}} 
        scf                       ;{{3012:37}} 
        ret                       ;{{3013:c9}} 

;;============================================================================================
;; REAL fix

REAL_fix:                         ;{{Addr=$3014 Code Calls/jump count: 3 Data use count: 1}}
        push    hl                ;{{3014:e5}} 
        push    de                ;{{3015:d5}} 
        push    hl                ;{{3016:e5}} 
        pop     ix                ;{{3017:dde1}} 
        xor     a                 ;{{3019:af}} 
        sub     (ix+$04)          ;{{301a:dd9604}} 
        jr      nz,_real_fix_13   ;{{301d:200a}}  (+&0a)
        ld      b,$04             ;{{301f:0604}} 
_real_fix_8:                      ;{{Addr=$3021 Code Calls/jump count: 1 Data use count: 0}}
        ld      (hl),a            ;{{3021:77}} 
        inc     hl                ;{{3022:23}} 
        djnz    _real_fix_8       ;{{3023:10fc}}  (-&04)
        ld      c,$01             ;{{3025:0e01}} 
        jr      _real_fix_45      ;{{3027:1828}}  (+&28)

_real_fix_13:                     ;{{Addr=$3029 Code Calls/jump count: 1 Data use count: 0}}
        add     a,$a0             ;{{3029:c6a0}} 
        jr      nc,_real_fix_46   ;{{302b:3025}}  (+&25)
        push    hl                ;{{302d:e5}} 
        call    x373d_code        ;{{302e:cd3d37}} 
        xor     a                 ;{{3031:af}} 
        cp      b                 ;{{3032:b8}} 
        adc     a,a               ;{{3033:8f}} 
        or      c                 ;{{3034:b1}} 
        ld      c,l               ;{{3035:4d}} 
        ld      b,h               ;{{3036:44}} 
        pop     hl                ;{{3037:e1}} 
        ld      (hl),c            ;{{3038:71}} 
        inc     hl                ;{{3039:23}} 
        ld      (hl),b            ;{{303a:70}} 
        inc     hl                ;{{303b:23}} 
        ld      (hl),e            ;{{303c:73}} 
        inc     hl                ;{{303d:23}} 
        ld      e,a               ;{{303e:5f}} 
        ld      a,(hl)            ;{{303f:7e}} 
        ld      (hl),d            ;{{3040:72}} 
        and     $80               ;{{3041:e680}} 
        ld      b,a               ;{{3043:47}} 
        ld      c,$04             ;{{3044:0e04}} 
        xor     a                 ;{{3046:af}} 
_real_fix_37:                     ;{{Addr=$3047 Code Calls/jump count: 1 Data use count: 0}}
        or      (hl)              ;{{3047:b6}} 
        jr      nz,_real_fix_43   ;{{3048:2005}}  (+&05)
        dec     hl                ;{{304a:2b}} 
        dec     c                 ;{{304b:0d}} 
        jr      nz,_real_fix_37   ;{{304c:20f9}}  (-&07)
        inc     c                 ;{{304e:0c}} 
_real_fix_43:                     ;{{Addr=$304f Code Calls/jump count: 1 Data use count: 0}}
        ld      a,e               ;{{304f:7b}} 
        or      a                 ;{{3050:b7}} 
_real_fix_45:                     ;{{Addr=$3051 Code Calls/jump count: 1 Data use count: 0}}
        scf                       ;{{3051:37}} 
_real_fix_46:                     ;{{Addr=$3052 Code Calls/jump count: 1 Data use count: 0}}
        pop     de                ;{{3052:d1}} 
        pop     hl                ;{{3053:e1}} 
        ret                       ;{{3054:c9}} 

;;============================================================================================
;; REAL int

REAL_int:                         ;{{Addr=$3055 Code Calls/jump count: 0 Data use count: 1}}
        call    REAL_fix          ;{{3055:cd1430}} 
        ret     nc                ;{{3058:d0}} 

        ret     z                 ;{{3059:c8}} 

        bit     7,b               ;{{305a:cb78}} 
        ret     z                 ;{{305c:c8}} 

        jr      _real_to_bin_3    ;{{305d:18a7}}  (-&59)

;;================================================================
;; REAL prepare for decimal

REAL_prepare_for_decimal:         ;{{Addr=$305f Code Calls/jump count: 0 Data use count: 1}}
        call    REAL_SGN          ;{{305f:cd2737}} 
        ld      b,a               ;{{3062:47}} 
        jr      z,_real_prepare_for_decimal_55;{{3063:2852}}  (+&52)
        call    m,_real_negate_2  ;{{3065:fc3437}} 
        push    hl                ;{{3068:e5}} 
        ld      a,(ix+$04)        ;{{3069:dd7e04}} 
        sub     $80               ;{{306c:d680}} 
        ld      e,a               ;{{306e:5f}} 
        sbc     a,a               ;{{306f:9f}} 
        ld      d,a               ;{{3070:57}} 
        ld      l,e               ;{{3071:6b}} 
        ld      h,d               ;{{3072:62}} 
        add     hl,hl             ;{{3073:29}} 
        add     hl,hl             ;{{3074:29}} 
        add     hl,hl             ;{{3075:29}} 
        add     hl,de             ;{{3076:19}} 
        add     hl,hl             ;{{3077:29}} 
        add     hl,de             ;{{3078:19}} 
        add     hl,hl             ;{{3079:29}} 
        add     hl,hl             ;{{307a:29}} 
        add     hl,de             ;{{307b:19}} 
        ld      a,h               ;{{307c:7c}} 
        sub     $09               ;{{307d:d609}} 
        ld      c,a               ;{{307f:4f}} 
        pop     hl                ;{{3080:e1}} 
        push    bc                ;{{3081:c5}} 
        call    nz,_real_exp_a_2  ;{{3082:c4c830}} 
_real_prepare_for_decimal_27:     ;{{Addr=$3085 Code Calls/jump count: 1 Data use count: 0}}
        ld      de,Jumpblock_BD76_constant_a;{{3085:11bc30}} 
        call    _real_compare_2   ;{{3088:cde236}} 
        jr      nc,_real_prepare_for_decimal_36;{{308b:300b}}  (+&0b)
        ld      de,powers_of_10_constants;{{308d:11f530}}  start of power's of ten
        call    REAL_multiplication;{{3090:cd7735}} 
        pop     de                ;{{3093:d1}} 
        dec     e                 ;{{3094:1d}} 
        push    de                ;{{3095:d5}} 
        jr      _real_prepare_for_decimal_27;{{3096:18ed}}  (-&13)
_real_prepare_for_decimal_36:     ;{{Addr=$3098 Code Calls/jump count: 2 Data use count: 0}}
        ld      de,Jumpblock_BD76_constant_b;{{3098:11c130}} 
        call    _real_compare_2   ;{{309b:cde236}} 
        jr      c,_real_prepare_for_decimal_45;{{309e:380b}}  (+&0b)
        ld      de,powers_of_10_constants;{{30a0:11f530}}  start of power's of ten
        call    REAL_division     ;{{30a3:cd0436}} 
        pop     de                ;{{30a6:d1}} 
        inc     e                 ;{{30a7:1c}} 
        push    de                ;{{30a8:d5}} 
        jr      _real_prepare_for_decimal_36;{{30a9:18ed}}  (-&13)
_real_prepare_for_decimal_45:     ;{{Addr=$30ab Code Calls/jump count: 1 Data use count: 0}}
        call    REAL_to_bin       ;{{30ab:cd0130}} 
        ld      a,c               ;{{30ae:79}} 
        pop     de                ;{{30af:d1}} 
        ld      b,d               ;{{30b0:42}} 
        dec     a                 ;{{30b1:3d}} 
        add     a,l               ;{{30b2:85}} 
        ld      l,a               ;{{30b3:6f}} 
        ret     nc                ;{{30b4:d0}} 

        inc     h                 ;{{30b5:24}} 
        ret                       ;{{30b6:c9}} 

_real_prepare_for_decimal_55:     ;{{Addr=$30b7 Code Calls/jump count: 1 Data use count: 0}}
        ld      e,a               ;{{30b7:5f}} 
        ld      (hl),a            ;{{30b8:77}} 
        ld      c,$01             ;{{30b9:0e01}} 
        ret                       ;{{30bb:c9}} 

;;=Jumpblock BD76 constant a
Jumpblock_BD76_constant_a:        ;{{Addr=$30bc Data Calls/jump count: 0 Data use count: 1}}
        defb $f0,$1f,$bc,$3e,$96  ;3124999.98
;;=Jumpblock BD76 constant b
Jumpblock_BD76_constant_b:        ;{{Addr=$30c1 Data Calls/jump count: 0 Data use count: 1}}
        defb $fe,$27,$6b,$6e,$9e  ;Manual fix (corrected to data from a ROM dump) 1e+09
;30c1 defb &fe,&27,&7b,&6e,&9e   ;(original line from disassembly listing) 1.00026e+09

;;============================================================================================
;; REAL exp A
REAL_exp_A:                       ;{{Addr=$30c6 Code Calls/jump count: 0 Data use count: 1}}
        cpl                       ;{{30c6:2f}} 
        inc     a                 ;{{30c7:3c}} 
_real_exp_a_2:                    ;{{Addr=$30c8 Code Calls/jump count: 1 Data use count: 0}}
        or      a                 ;{{30c8:b7}} 
        scf                       ;{{30c9:37}} 
        ret     z                 ;{{30ca:c8}} 

        ld      c,a               ;{{30cb:4f}} 
        jp      p,_real_exp_a_9   ;{{30cc:f2d130}} 
        cpl                       ;{{30cf:2f}} 
        inc     a                 ;{{30d0:3c}} 
_real_exp_a_9:                    ;{{Addr=$30d1 Code Calls/jump count: 2 Data use count: 0}}
        ld      de,_powers_of_10_constants_12;{{30d1:113131}} 
        sub     $0d               ;{{30d4:d60d}} 
        jr      z,_real_exp_a_28  ;{{30d6:2815}}  (+&15)
        jr      c,_real_exp_a_19  ;{{30d8:3809}}  (+&09)
        push    bc                ;{{30da:c5}} 
        push    af                ;{{30db:f5}} 
        call    _real_exp_a_28    ;{{30dc:cded30}} 
        pop     af                ;{{30df:f1}} 
        pop     bc                ;{{30e0:c1}} 
        jr      _real_exp_a_9     ;{{30e1:18ee}}  (-&12)
_real_exp_a_19:                   ;{{Addr=$30e3 Code Calls/jump count: 1 Data use count: 0}}
        ld      b,a               ;{{30e3:47}} 
        add     a,a               ;{{30e4:87}} 
        add     a,a               ;{{30e5:87}} 
        add     a,b               ;{{30e6:80}} 
        add     a,e               ;{{30e7:83}} 
        ld      e,a               ;{{30e8:5f}} 
        ld      a,$ff             ;{{30e9:3eff}} 
        adc     a,d               ;{{30eb:8a}} 
        ld      d,a               ;{{30ec:57}} 
_real_exp_a_28:                   ;{{Addr=$30ed Code Calls/jump count: 2 Data use count: 0}}
        ld      a,c               ;{{30ed:79}} 
        or      a                 ;{{30ee:b7}} 
        jp      p,REAL_division   ;{{30ef:f20436}} 
        jp      REAL_multiplication;{{30f2:c37735}} 

;;===========================================================================================
;; power's of 10 constants
;; in internal floating point representation
;;
powers_of_10_constants:           ;{{Addr=$30f5 Data Calls/jump count: 0 Data use count: 2}}
        defb $00,$00,$00,$20,$84  ; 10 (10^1)  (Data corrected to match that from a ROM dump) 10
;30f5 defb &00,&00,&00,&00,&84			;; 10 (10^1)  (Original line from disassembly) 8
        defb $00,$00,$00,$48,$87  ; 100 (10^2) 100
        defb $00,$00,$00,$7A,$8A  ; 1000 (10^3) 1000
        defb $00,$00,$40,$1c,$8e  ; 10000 (10^4) (1E+4) 10000
        defb $00,$00,$50,$43,$91  ; 100000 (10^5) (1E+5) 100000
        defb $00,$00,$24,$74,$94  ; 1000000 (10^6) (1E+6) 1000000
        defb $00,$80,$96,$18,$98  ; 10000000 (10^7) (1E+7) 10000000
        defb $00,$20,$bc,$3e,$9b  ; 100000000 (10^8) (1E+8) 100000000
        defb $00,$28,$6b,$6e,$9e  ; 1000000000 (10^9) (1E+9) 1e+09
        defb $00,$f9,$02,$15,$a2  ; 10000000000 (10^10) (1E+10) 1e+10
        defb $40,$b7,$43,$3a,$a5  ; 100000000000 (10^11) (1E+11) 1e+11
        defb $10,$a5,$d4,$68,$a8  ; 1000000000000 (10^12) (1E+12) 1e+12
_powers_of_10_constants_12:       ;{{Addr=$3131 Data Calls/jump count: 0 Data use count: 1}}
        defb $2a,$e7,$84,$11,$ac  ; 10000000000000 (10^13) (1E+13) 1e+13

;;===========================================================================================
;; REAL init random number generator
;;Called (only) at start of BASIC ROM and at start of RANDOMIZE seed (below). 
;;The data locations appear to store the last random number generated.
;;Possibly initialise/reset of random number generator?
REAL_init_random_number_generator:;{{Addr=$3136 Code Calls/jump count: 1 Data use count: 1}}
        ld      hl,$8965          ;{{3136:216589}} 
        ld      (last_random_number),hl;{{3139:2202b1}} 
        ld      hl,$6c07          ;{{313c:21076c}} 
        ld      (C6_last_random_number),hl;{{313f:2200b1}} 
        ret                       ;{{3142:c9}} 

;;============================================================================================
;; REAL: RANDOMIZE seed
REAL_RANDOMIZE_seed:              ;{{Addr=$3143 Code Calls/jump count: 0 Data use count: 1}}
        ex      de,hl             ;{{3143:eb}} 
        call    REAL_init_random_number_generator;{{3144:cd3631}} 
        ex      de,hl             ;{{3147:eb}} 
        call    REAL_SGN          ;{{3148:cd2737}} 
        ret     z                 ;{{314b:c8}} 

        ld      de,C6_last_random_number;{{314c:1100b1}} 
        ld      b,$04             ;{{314f:0604}} 
_real_randomize_seed_7:           ;{{Addr=$3151 Code Calls/jump count: 1 Data use count: 0}}
        ld      a,(de)            ;{{3151:1a}} 
        xor     (hl)              ;{{3152:ae}} 
        ld      (de),a            ;{{3153:12}} 
        inc     de                ;{{3154:13}} 
        inc     hl                ;{{3155:23}} 
        djnz    _real_randomize_seed_7;{{3156:10f9}}  (-&07)
        ret                       ;{{3158:c9}} 

;;============================================================================================
;; REAL rnd
REAL_rnd:                         ;{{Addr=$3159 Code Calls/jump count: 0 Data use count: 1}}
        push    hl                ;{{3159:e5}} 
        ld      hl,(last_random_number);{{315a:2a02b1}} 
        ld      bc,$6c07          ;{{315d:01076c}} 
        call    _real_rnd0_7      ;{{3160:cd9c31}} 
        push    hl                ;{{3163:e5}} 
        ld      hl,(C6_last_random_number);{{3164:2a00b1}} 
        ld      bc,$8965          ;{{3167:016589}} 
        call    _real_rnd0_7      ;{{316a:cd9c31}} 
        push    de                ;{{316d:d5}} 
        push    hl                ;{{316e:e5}} 
        ld      hl,(last_random_number);{{316f:2a02b1}} 
        call    _real_rnd0_7      ;{{3172:cd9c31}} 
        ex      (sp),hl           ;{{3175:e3}} 
        add     hl,bc             ;{{3176:09}} 
        ld      (C6_last_random_number),hl;{{3177:2200b1}} 
        pop     hl                ;{{317a:e1}} 
        ld      bc,$6c07          ;{{317b:01076c}} 
        adc     hl,bc             ;{{317e:ed4a}} 
        pop     bc                ;{{3180:c1}} 
        add     hl,bc             ;{{3181:09}} 
        pop     bc                ;{{3182:c1}} 
        add     hl,bc             ;{{3183:09}} 
        ld      (last_random_number),hl;{{3184:2202b1}} 
        pop     hl                ;{{3187:e1}} 

;;============================================================================================
;; REAL rnd0
REAL_rnd0:                        ;{{Addr=$3188 Code Calls/jump count: 0 Data use count: 1}}
        push    hl                ;{{3188:e5}} 
        pop     ix                ;{{3189:dde1}} 
        ld      hl,(C6_last_random_number);{{318b:2a00b1}} 
        ld      de,(last_random_number);{{318e:ed5b02b1}} 
        ld      bc,$0000          ;{{3192:010000}} ##LIT##;WARNING: Code area used as literal
        ld      (ix+$04),$80      ;{{3195:dd360480}} 
        jp      _process_real_at_hl_13;{{3199:c3ac37}} 

_real_rnd0_7:                     ;{{Addr=$319c Code Calls/jump count: 3 Data use count: 0}}
        ex      de,hl             ;{{319c:eb}} 
        ld      hl,$0000          ;{{319d:210000}} ##LIT##;WARNING: Code area used as literal
        ld      a,$11             ;{{31a0:3e11}} 
_real_rnd0_10:                    ;{{Addr=$31a2 Code Calls/jump count: 3 Data use count: 0}}
        dec     a                 ;{{31a2:3d}} 
        ret     z                 ;{{31a3:c8}} 

        add     hl,hl             ;{{31a4:29}} 
        rl      e                 ;{{31a5:cb13}} 
        rl      d                 ;{{31a7:cb12}} 
        jr      nc,_real_rnd0_10  ;{{31a9:30f7}}  (-&09)
        add     hl,bc             ;{{31ab:09}} 
        jr      nc,_real_rnd0_10  ;{{31ac:30f4}}  (-&0c)
        inc     de                ;{{31ae:13}} 
        jr      _real_rnd0_10     ;{{31af:18f1}}  (-&0f)

;;============================================================================================
;; REAL log10
REAL_log10:                       ;{{Addr=$31b1 Code Calls/jump count: 0 Data use count: 1}}
        ld      de,const_0301029996;{{31b1:112a32}} 
        jr      _real_log_1       ;{{31b4:1803}}  (+&03)

;;============================================================================================
;; REAL log
REAL_log:                         ;{{Addr=$31b6 Code Calls/jump count: 1 Data use count: 1}}
        ld      de,const_0693147181;{{31b6:112532}} 
_real_log_1:                      ;{{Addr=$31b9 Code Calls/jump count: 1 Data use count: 0}}
        call    REAL_SGN          ;{{31b9:cd2737}} 
        dec     a                 ;{{31bc:3d}} 
        cp      $01               ;{{31bd:fe01}} 
        ret     nc                ;{{31bf:d0}} 

        push    de                ;{{31c0:d5}} 
        call    _real_division_121;{{31c1:cdd336}} 
        push    af                ;{{31c4:f5}} 
        ld      (ix+$04),$80      ;{{31c5:dd360480}} 
        ld      de,const_0707106781;{{31c9:112032}} 
        call    REAL_compare      ;{{31cc:cddf36}} 
        jr      nc,_real_log_16   ;{{31cf:3006}}  (+&06)
        inc     (ix+$04)          ;{{31d1:dd3404}} 
        pop     af                ;{{31d4:f1}} 
        dec     a                 ;{{31d5:3d}} 
        push    af                ;{{31d6:f5}} 
_real_log_16:                     ;{{Addr=$31d7 Code Calls/jump count: 1 Data use count: 0}}
        call    REAL_copy_atHL_to_b10e_swapped;{{31d7:cd872f}} 
        push    de                ;{{31da:d5}} 
        ld      de,ONE_const      ;{{31db:11822f}} 
        push    de                ;{{31de:d5}} 
        call    REAL_addition     ;{{31df:cda234}} 
        pop     de                ;{{31e2:d1}} 
        ex      (sp),hl           ;{{31e3:e3}} 
        call    x349a_code        ;{{31e4:cd9a34}} 
        pop     de                ;{{31e7:d1}} 
        call    REAL_division     ;{{31e8:cd0436}} 
        call    process_inline_parameters;{{31eb:cd4034}} Code takes inline parameter block

;Inline parameter block
        defb $04                  ;Parameter count
        defb $4c,$4b,$57,$5e,$7f  ; 0.434259751
        defb $0d,$08,$9b,$13,$80  ; 0.576584342
        defb $23,$93,$38,$76,$80  ; 0.961800762
        defb $20,$3b,$aa,$38,$82  ; 2.88539007

;Return address
        push    de                ;{{3203:d5}} 
        call    REAL_multiplication;{{3204:cd7735}} 
        pop     de                ;{{3207:d1}} 
        ex      (sp),hl           ;{{3208:e3}} 
        ld      a,h               ;{{3209:7c}} 
        or      a                 ;{{320a:b7}} 
        jp      p,_real_log_41    ;{{320b:f21032}} 
        cpl                       ;{{320e:2f}} 
        inc     a                 ;{{320f:3c}} 
_real_log_41:                     ;{{Addr=$3210 Code Calls/jump count: 1 Data use count: 0}}
        ld      l,a               ;{{3210:6f}} 
        ld      a,h               ;{{3211:7c}} 
        ld      h,$00             ;{{3212:2600}} 
        call    REAL_INT_to_real  ;{{3214:cd9f2f}} 
        ex      de,hl             ;{{3217:eb}} 
        pop     hl                ;{{3218:e1}} 
        call    REAL_addition     ;{{3219:cda234}} 
        pop     de                ;{{321c:d1}} 
        jp      REAL_multiplication;{{321d:c37735}} 

;;= const 0_707106781
const_0707106781:                 ;{{Addr=$3220 Data Calls/jump count: 0 Data use count: 1}}
        defb $34,$f3,$04,$35,$80  ; 0.707106781
;;= const 0_693147181
const_0693147181:                 ;{{Addr=$3225 Data Calls/jump count: 0 Data use count: 1}}
        defb $f8,$17,$72,$31,$80  ; 0.693147181
;;= const 0_301029996
const_0301029996:                 ;{{Addr=$322a Data Calls/jump count: 0 Data use count: 1}}
        defb $85,$9a,$20,$1a,$7f  ; 0.301029996

;;============================================================================================
;; REAL exp
REAL_exp:                         ;{{Addr=$322f Code Calls/jump count: 1 Data use count: 1}}
        ld      b,$e1             ;{{322f:06e1}} 
        call    x3492_code        ;{{3231:cd9234}} 
        jp      nc,REAL_ONE_to_DE ;{{3234:d27d2f}} 
        ld      de,exp_constant_c ;{{3237:11a232}} 
        call    REAL_compare      ;{{323a:cddf36}} 
        jp      p,REAL_at_IX_to_max_pos;{{323d:f2e837}} 
        ld      de,exp_constant_d ;{{3240:11a732}} 
        call    REAL_compare      ;{{3243:cddf36}} 
        jp      m,_process_real_at_hl_42;{{3246:fae237}} 
        ld      de,exp_constant_b ;{{3249:119d32}} 
        call    x3469_code        ;{{324c:cd6934}} 
        ld      a,e               ;{{324f:7b}} 
        jp      p,_real_exp_14    ;{{3250:f25532}} 
        neg                       ;{{3253:ed44}} 
_real_exp_14:                     ;{{Addr=$3255 Code Calls/jump count: 1 Data use count: 0}}
        push    af                ;{{3255:f5}} 
        call    _real_addition_119;{{3256:cd7035}} 
        call    _real_move_de_to_b10e_2;{{3259:cd8d2f}} 
        push    de                ;{{325c:d5}} 
        call    _process_inline_parameters_1;{{325d:cd4334}} Code takes inline parameter block

;Inline parameter block
        defb $03                  ;Parameter count
        defb $f4,$32,$eb,$0f,$73  ; 6.86258e-05
        defb $08,$b8,$d5,$52,$7b  ; 2.57367e-02
;;= exp constant a
exp_constant_a:                   ;{{Addr=$326b Data Calls/jump count: 0 Data use count: 3}}
        defb $00,$00,$00,$00,$80  ; 0.5

;Return address
        ex      (sp),hl           ;{{3270:e3}} 
        call    _process_inline_parameters_1;{{3271:cd4334}} Code takes inline parameter block

;Inline parameter block
        defb $02                  ;parameter count
        defb $09,$60,$de,$01,$78  ; 1.98164e-03
        defb $f8,$17,$72,$31,$7e  ; 0.173286795

;Return address
        call    REAL_multiplication;{{32ff:cd7735}} 
        pop     de                ;{{3282:d1}} 
        push    hl                ;{{3283:e5}} 
        ex      de,hl             ;{{3284:eb}} 
        call    x349a_code        ;{{3285:cd9a34}} 
        ex      de,hl             ;{{3288:eb}} 
        pop     hl                ;{{3289:e1}} 
        call    REAL_division     ;{{328a:cd0436}} 
        ld      de,exp_constant_a ;{{328d:116b32}} 
        call    REAL_addition     ;{{3290:cda234}} 
        pop     af                ;{{3293:f1}} 
        scf                       ;{{3294:37}} 
        adc     a,(ix+$04)        ;{{3295:dd8e04}} 
        ld      (ix+$04),a        ;{{3298:dd7704}} 
        scf                       ;{{329b:37}} 
        ret                       ;{{329c:c9}} 

;;= exp constant b
exp_constant_b:                   ;{{Addr=$329d Data Calls/jump count: 0 Data use count: 1}}
        defb $29,$3b,$aa,$38,$81  ;   1.44269504
;;= exp constant c
exp_constant_c:                   ;{{Addr=$32a2 Data Calls/jump count: 0 Data use count: 1}}
        defb $c7,$33,$0f,$30,$87  ;  88.0296919
;;= exp constant d
exp_constant_d:                   ;{{Addr=$32a7 Data Calls/jump count: 0 Data use count: 1}}
        defb $f8,$17,$72,$b1,$87  ; -88.7228391

;;============================================================================================
;; REAL sqr
REAL_sqr:                         ;{{Addr=$32ac Code Calls/jump count: 0 Data use count: 1}}
        ld      de,exp_constant_a ;{{32ac:116b32}} 

;;============================================================================================
;; REAL power
REAL_power:                       ;{{Addr=$32af Code Calls/jump count: 0 Data use count: 1}}
        ex      de,hl             ;{{32af:eb}} 
        call    REAL_SGN          ;{{32b0:cd2737}} 
        ex      de,hl             ;{{32b3:eb}} 
        jp      z,REAL_ONE_to_DE  ;{{32b4:ca7d2f}} 
        push    af                ;{{32b7:f5}} 
        call    REAL_SGN          ;{{32b8:cd2737}} 
        jr      z,_real_power_29  ;{{32bb:2825}}  (+&25)
        ld      b,a               ;{{32bd:47}} 
        call    m,_real_negate_2  ;{{32be:fc3437}} 
        push    hl                ;{{32c1:e5}} 
        call    _real_power_72    ;{{32c2:cd2433}} 
        pop     hl                ;{{32c5:e1}} 
        jr      c,_real_power_38  ;{{32c6:3825}}  (+&25)
        ex      (sp),hl           ;{{32c8:e3}} 
        pop     hl                ;{{32c9:e1}} 
        jp      m,_real_power_35  ;{{32ca:faea32}} 
        push    bc                ;{{32cd:c5}} 
        push    de                ;{{32ce:d5}} 
        call    REAL_log          ;{{32cf:cdb631}} 
        pop     de                ;{{32d2:d1}} 
        call    c,REAL_multiplication;{{32d3:dc7735}} 
        call    c,REAL_exp        ;{{32d6:dc2f32}} 
_real_power_22:                   ;{{Addr=$32d9 Code Calls/jump count: 1 Data use count: 0}}
        pop     bc                ;{{32d9:c1}} 
        ret     nc                ;{{32da:d0}} 

        ld      a,b               ;{{32db:78}} 
        or      a                 ;{{32dc:b7}} 
        call    m,REAL_Negate     ;{{32dd:fc3137}} 
        scf                       ;{{32e0:37}} 
        ret                       ;{{32e1:c9}} 

_real_power_29:                   ;{{Addr=$32e2 Code Calls/jump count: 1 Data use count: 0}}
        pop     af                ;{{32e2:f1}} 
        scf                       ;{{32e3:37}} 
        ret     p                 ;{{32e4:f0}} 

        call    REAL_at_IX_to_max_pos;{{32e5:cde837}} 
        xor     a                 ;{{32e8:af}} 
        ret                       ;{{32e9:c9}} 

_real_power_35:                   ;{{Addr=$32ea Code Calls/jump count: 1 Data use count: 0}}
        xor     a                 ;{{32ea:af}} 
        inc     a                 ;{{32eb:3c}} 
        ret                       ;{{32ec:c9}} 

_real_power_38:                   ;{{Addr=$32ed Code Calls/jump count: 1 Data use count: 0}}
        ld      c,a               ;{{32ed:4f}} 
        pop     af                ;{{32ee:f1}} 
        push    bc                ;{{32ef:c5}} 
        push    af                ;{{32f0:f5}} 
        ld      a,c               ;{{32f1:79}} 
        scf                       ;{{32f2:37}} 
_real_power_44:                   ;{{Addr=$32f3 Code Calls/jump count: 1 Data use count: 0}}
        adc     a,a               ;{{32f3:8f}} 
        jr      nc,_real_power_44 ;{{32f4:30fd}}  (-&03)
        ld      b,a               ;{{32f6:47}} 
        call    _real_move_de_to_b10e_2;{{32f7:cd8d2f}} 
        ex      de,hl             ;{{32fa:eb}} 
        ld      a,b               ;{{32fb:78}} 
_real_power_50:                   ;{{Addr=$32fc Code Calls/jump count: 2 Data use count: 0}}
        add     a,a               ;{{32fc:87}} 
        jr      z,_real_power_63  ;{{32fd:2815}}  (+&15)
        push    af                ;{{32ff:f5}} 
        call    _real_addition_119;{{3300:cd7035}} 
        jr      nc,_real_power_67 ;{{3303:3016}}  (+&16)
        pop     af                ;{{3305:f1}} 
        jr      nc,_real_power_50 ;{{3306:30f4}}  (-&0c)
        push    af                ;{{3308:f5}} 
        ld      de,internal_REAL_store_1;{{3309:1104b1}} 
        call    REAL_multiplication;{{330c:cd7735}} 
        jr      nc,_real_power_67 ;{{330f:300a}}  (+&0a)
        pop     af                ;{{3311:f1}} 
        jr      _real_power_50    ;{{3312:18e8}}  (-&18)

_real_power_63:                   ;{{Addr=$3314 Code Calls/jump count: 1 Data use count: 0}}
        pop     af                ;{{3314:f1}} 
        scf                       ;{{3315:37}} 
        call    m,_real_multiplication_72;{{3316:fcfb35}} 
        jr      _real_power_22    ;{{3319:18be}}  (-&42)

_real_power_67:                   ;{{Addr=$331b Code Calls/jump count: 2 Data use count: 0}}
        pop     af                ;{{331b:f1}} 
        pop     af                ;{{331c:f1}} 
        pop     bc                ;{{331d:c1}} 
        jp      m,_process_real_at_hl_42;{{331e:fae237}} 
        jp      REAL_at_IX_to_max_pos_or_max_neg;{{3321:c3ea37}} 

_real_power_72:                   ;{{Addr=$3324 Code Calls/jump count: 1 Data use count: 0}}
        push    bc                ;{{3324:c5}} 
        call    REAL_move_DE_to_b10e;{{3325:cd882f}} 
        call    REAL_fix          ;{{3328:cd1430}} 
        ld      a,c               ;{{332b:79}} 
        pop     bc                ;{{332c:c1}} 
        jr      nc,_real_power_79 ;{{332d:3002}}  (+&02)
        jr      z,_real_power_82  ;{{332f:2803}}  (+&03)
_real_power_79:                   ;{{Addr=$3331 Code Calls/jump count: 1 Data use count: 0}}
        ld      a,b               ;{{3331:78}} 
        or      a                 ;{{3332:b7}} 
        ret                       ;{{3333:c9}} 

_real_power_82:                   ;{{Addr=$3334 Code Calls/jump count: 1 Data use count: 0}}
        ld      c,a               ;{{3334:4f}} 
        ld      a,(hl)            ;{{3335:7e}} 
        rra                       ;{{3336:1f}} 
        sbc     a,a               ;{{3337:9f}} 
        and     b                 ;{{3338:a0}} 
        ld      b,a               ;{{3339:47}} 
        ld      a,c               ;{{333a:79}} 
        cp      $02               ;{{333b:fe02}} 
        sbc     a,a               ;{{333d:9f}} 
        ret     nc                ;{{333e:d0}} 

        ld      a,(hl)            ;{{333f:7e}} 
        cp      $27               ;{{3340:fe27}} 
        ret     c                 ;{{3342:d8}} 

        xor     a                 ;{{3343:af}} 
        ret                       ;{{3344:c9}} 

;;============================================================================================
;; REAL set degrees or radians
REAL_set_degrees_or_radians:      ;{{Addr=$3345 Code Calls/jump count: 0 Data use count: 1}}
        ld      (DEG__RAD_flag_),a;{{3345:3213b1}} 
        ret                       ;{{3348:c9}} 

;;============================================================================================
;; REAL cosine
REAL_cosine:                      ;{{Addr=$3349 Code Calls/jump count: 1 Data use count: 1}}
        call    REAL_SGN          ;{{3349:cd2737}} 
        call    m,_real_negate_2  ;{{334c:fc3437}} 
        or      $01               ;{{334f:f601}} 
        jr      _real_sin_1       ;{{3351:1801}}  (+&01)

;;============================================================================================
;; REAL sin
REAL_sin:                         ;{{Addr=$3353 Code Calls/jump count: 1 Data use count: 1}}
        xor     a                 ;{{3353:af}} 
_real_sin_1:                      ;{{Addr=$3354 Code Calls/jump count: 1 Data use count: 0}}
        push    af                ;{{3354:f5}} 
        ld      de,sin_constant_b ;{{3355:11b433}} 
        ld      b,$f0             ;{{3358:06f0}} 
        ld      a,(DEG__RAD_flag_);{{335a:3a13b1}} 
        or      a                 ;{{335d:b7}} 
        jr      z,_real_sin_9     ;{{335e:2805}}  (+&05)
        ld      de,sin_constant_c ;{{3360:11b933}} 
        ld      b,$f6             ;{{3363:06f6}} 
_real_sin_9:                      ;{{Addr=$3365 Code Calls/jump count: 1 Data use count: 0}}
        call    x3492_code        ;{{3365:cd9234}} 
        jr      nc,_sin_code_block_2_1;{{3368:303a}}  (+&3a)
        pop     af                ;{{336a:f1}} 
        call    x346a_code        ;{{336b:cd6a34}} 
        ret     nc                ;{{336e:d0}} 

        ld      a,e               ;{{336f:7b}} 
        rra                       ;{{3370:1f}} 
        call    c,_real_negate_2  ;{{3371:dc3437}} 
        ld      b,$e8             ;{{3374:06e8}} 
        call    x3492_code        ;{{3376:cd9234}} 
        jp      nc,_process_real_at_hl_42;{{3379:d2e237}} 
        inc     (ix+$04)          ;{{337c:dd3404}} 
        call    process_inline_parameters;{{337f:cd4034}} Code pops parameter block address from stack

;Inline parameter block
        defb $06                  ;Parameter count (6)
        defb $1b,$2d,$1a,$e6,$6e  ; -3.42879e-06
        defb $f8,$fb,$07,$28,$74  ;  1.60247e-04
        defb $01,$89,$68,$99,$79  ; -4.68165e-03
        defb $e1,$df,$35,$23,$7d  ;  7.96926e-02
        defb $28,$e7,$5d,$a5,$80  ; -0.645964095
;;=sin constant a
sin_constant_a:                   ;{{Addr=$339c Data Calls/jump count: 0 Data use count: 1}}
        defb $a2,$da,$0f,$49,$81  ;  1.57079633

;;=Sin code block 2
;Code returns here
        jp      REAL_multiplication;{{33a1:c37735}} 

_sin_code_block_2_1:              ;{{Addr=$33a4 Code Calls/jump count: 1 Data use count: 0}}
        pop     af                ;{{33a4:f1}} 
        jp      nz,REAL_ONE_to_DE ;{{33a5:c27d2f}} 
        ld      a,(DEG__RAD_flag_);{{33a8:3a13b1}} 
        cp      $01               ;{{33ab:fe01}} 
        ret     c                 ;{{33ad:d8}} 

        ld      de,sin_constant_d ;{{33ae:11be33}} 
        jp      REAL_multiplication;{{33b1:c37735}} 

;;=sin constant b
sin_constant_b:                   ;{{Addr=$33b4 Data Calls/jump count: 0 Data use count: 1}}
        defb $6e,$83,$f9,$22,$7f  ;  0.318309886
;;=sin constant c
sin_constant_c:                   ;{{Addr=$33b9 Data Calls/jump count: 0 Data use count: 1}}
        defb $b6,$60,$0b,$36,$79  ;  5.55556e-03
;;=sin constant d
sin_constant_d:                   ;{{Addr=$33be Data Calls/jump count: 0 Data use count: 1}}
        defb $13,$35,$fa,$0e,$7b  ;  1.74533e-02
;;=sin constant e
sin_constant_e:                   ;{{Addr=$33c3 Data Calls/jump count: 0 Data use count: 1}}
        defb $d3,$e0,$2e,$65,$86  ; 57.2957795

;;============================================================================================
;; REAL tan
REAL_tan:                         ;{{Addr=$33c8 Code Calls/jump count: 0 Data use count: 1}}
        call    _real_move_de_to_b10e_2;{{33c8:cd8d2f}} 
        push    de                ;{{33cb:d5}} 
        call    REAL_cosine       ;{{33cc:cd4933}} 
        ex      (sp),hl           ;{{33cf:e3}} 
        call    c,REAL_sin        ;{{33d0:dc5333}} 
        pop     de                ;{{33d3:d1}} 
        jp      c,REAL_division   ;{{33d4:da0436}} 
        ret                       ;{{33d7:c9}} 

;;============================================================================================
;; REAL arctan
REAL_arctan:                      ;{{Addr=$33d8 Code Calls/jump count: 0 Data use count: 1}}
        call    REAL_SGN          ;{{33d8:cd2737}} 
        push    af                ;{{33db:f5}} 
        call    m,_real_negate_2  ;{{33dc:fc3437}} 
        ld      b,$f0             ;{{33df:06f0}} 
        call    x3492_code        ;{{33e1:cd9234}} 
        jr      nc,_real_arctan_26;{{33e4:304a}}  (+&4a)
        dec     a                 ;{{33e6:3d}} 
        push    af                ;{{33e7:f5}} 
        call    p,_real_multiplication_72;{{33e8:f4fb35}} 
        call    process_inline_parameters;{{33eb:cd4034}} Code which takes an inline parameter block

;Inline paremeter blcok, address retrieved from the call stack
        defb $0b                  ;Parameter count (11)
        defb $ff,$c1,$03,$0f,$77  ;  1.09112e-03
        defb $83,$fc,$e8,$eb,$79  ; -0.007199405 
        defb $6f,$ca,$78,$36,$7b  ;  2.22744e-02
        defb $d5,$3e,$b0,$b5,$7c  ; -4.43575e-02
        defb $b0,$c1,$8b,$09,$7d  ;  6.71611e-02
        defb $af,$e8,$32,$b4,$7d  ; -8.79877e-02
        defb $74,$6c,$65,$62,$7d  ;  0.110545013
        defb $d1,$f5,$37,$92,$7e  ; -0.142791596
        defb $7a,$c3,$cb,$4c,$7e  ;  0.199996046
        defb $83,$a7,$aa,$aa,$7f  ; -0.333333239
        defb $fe,$ff,$ff,$7f,$80  ;  1

        call    REAL_multiplication;{{3426:cd7735}} Return address after data block
        pop     af                ;{{3429:f1}} 
        ld      de,sin_constant_a ;{{342a:119c33}} 
        call    p,REAL_reverse_subtract;{{342d:f49e34}} 
_real_arctan_26:                  ;{{Addr=$3430 Code Calls/jump count: 1 Data use count: 0}}
        ld      a,(DEG__RAD_flag_);{{3430:3a13b1}} 
        or      a                 ;{{3433:b7}} 
        ld      de,sin_constant_e ;{{3434:11c333}} 
        call    nz,REAL_multiplication;{{3437:c47735}} 
        pop     af                ;{{343a:f1}} 
        call    m,_real_negate_2  ;{{343b:fc3437}} 
        scf                       ;{{343e:37}} 
        ret                       ;{{343f:c9}} 


;;=====================================================
;; process inline parameters
;This code takes a list of parameters starting at the next byte after the call.
;It pops the return value off the stack, reads in the values, and eventually returns 
;to the address after the data block.
;The first byte of the data block is the count of the number of parameters. Each 
;parameter is five bytes long (a real).

process_inline_parameters:        ;{{Addr=$3440 Code Calls/jump count: 3 Data use count: 0}}
        call    _real_addition_119;{{3440:cd7035}} 
_process_inline_parameters_1:     ;{{Addr=$3443 Code Calls/jump count: 2 Data use count: 0}}
        call    REAL_copy_atHL_to_b10e_swapped;{{3443:cd872f}} 
        pop     hl                ;{{3446:e1}} Pop the return address/address of data block
        ld      b,(hl)            ;{{3447:46}} Parameter count
        inc     hl                ;{{3448:23}} First parameter
        call    REAL_copy_atHL_to_atDE_swapped;{{3449:cd902f}} 
_process_inline_parameters_6:     ;{{Addr=$344c Code Calls/jump count: 1 Data use count: 0}}
        inc     de                ;{{344c:13}} Advance to next parameter
        inc     de                ;{{344d:13}} 
        inc     de                ;{{344e:13}} 
        inc     de                ;{{344f:13}} 
        inc     de                ;{{3450:13}} 
        push    de                ;{{3451:d5}} Possible return address
        ld      de,internal_REAL_store_2;{{3452:1109b1}} 
        dec     b                 ;{{3455:05}} 
        ret     z                 ;{{3456:c8}} 

        push    bc                ;{{3457:c5}} 
        ld      de,internal_REAL_store_3;{{3458:110eb1}} 
        call    REAL_multiplication;{{345b:cd7735}} 
        pop     bc                ;{{345e:c1}} 
        pop     de                ;{{345f:d1}} Get back address of next parameter
        push    de                ;{{3460:d5}} 
        push    bc                ;{{3461:c5}} 
        call    REAL_addition     ;{{3462:cda234}} 
        pop     bc                ;{{3465:c1}} 
        pop     de                ;{{3466:d1}} 
        jr      _process_inline_parameters_6;{{3467:18e3}}  (-&1d)

;;=======================================================

x3469_code:                       ;{{Addr=$3469 Code Calls/jump count: 1 Data use count: 0}}
        xor     a                 ;{{3469:af}} 
x346a_code:                       ;{{Addr=$346a Code Calls/jump count: 1 Data use count: 0}}
        push    af                ;{{346a:f5}} 
        call    REAL_multiplication;{{346b:cd7735}} 
        pop     af                ;{{346e:f1}} 
        ld      de,exp_constant_a ;{{346f:116b32}} 
        call    nz,REAL_addition  ;{{3472:c4a234}} 
        push    hl                ;{{3475:e5}} 
        call    REAL_to_int       ;{{3476:cdd92f}} 
        jr      nc,x348e_code     ;{{3479:3013}}  (+&13)
        pop     de                ;{{347b:d1}} 
        push    hl                ;{{347c:e5}} 
        push    af                ;{{347d:f5}} 
        push    de                ;{{347e:d5}} 
        ld      de,internal_REAL_store_2;{{347f:1109b1}} 
        call    REAL_INT_to_real  ;{{3482:cd9f2f}} 
        ex      de,hl             ;{{3485:eb}} 
        pop     hl                ;{{3486:e1}} 
        call    x349a_code        ;{{3487:cd9a34}} 
        pop     af                ;{{348a:f1}} 
        pop     de                ;{{348b:d1}} 
        scf                       ;{{348c:37}} 
        ret                       ;{{348d:c9}} 

x348e_code:                       ;{{Addr=$348e Code Calls/jump count: 1 Data use count: 0}}
        pop     hl                ;{{348e:e1}} 
        xor     a                 ;{{348f:af}} 
        inc     a                 ;{{3490:3c}} 
        ret                       ;{{3491:c9}} 

x3492_code:                       ;{{Addr=$3492 Code Calls/jump count: 4 Data use count: 0}}
        call    _real_division_121;{{3492:cdd336}} 
        ret     p                 ;{{3495:f0}} 

        cp      b                 ;{{3496:b8}} 
        ret     z                 ;{{3497:c8}} 

        ccf                       ;{{3498:3f}} 
        ret                       ;{{3499:c9}} 

x349a_code:                       ;{{Addr=$349a Code Calls/jump count: 3 Data use count: 0}}
        ld      a,$01             ;{{349a:3e01}} 
        jr      _real_addition_1  ;{{349c:1805}}  (+&05)

;;============================================================================================
;; REAL reverse subtract
REAL_reverse_subtract:            ;{{Addr=$349e Code Calls/jump count: 1 Data use count: 1}}
        ld      a,$80             ;{{349e:3e80}} 
        jr      _real_addition_1  ;{{34a0:1801}}  (+&01)

;;============================================================================================
;; REAL addition
REAL_addition:                    ;{{Addr=$34a2 Code Calls/jump count: 5 Data use count: 1}}
        xor     a                 ;{{34a2:af}} 

; A = function, &00, &01 or &80
_real_addition_1:                 ;{{Addr=$34a3 Code Calls/jump count: 2 Data use count: 0}}
        push    hl                ;{{34a3:e5}} 
        pop     ix                ;{{34a4:dde1}} 
        push    de                ;{{34a6:d5}} 
        pop     iy                ;{{34a7:fde1}} 
        ld      b,(ix+$03)        ;{{34a9:dd4603}} 
        ld      c,(iy+$03)        ;{{34ac:fd4e03}} 
        or      a                 ;{{34af:b7}} 
        jr      z,_real_addition_16;{{34b0:280a}}  (+&0a)
        jp      m,_real_addition_14;{{34b2:faba34}} 
        rrca                      ;{{34b5:0f}} 
        xor     c                 ;{{34b6:a9}} 
        ld      c,a               ;{{34b7:4f}} 
        jr      _real_addition_16 ;{{34b8:1802}}  (+&02)

_real_addition_14:                ;{{Addr=$34ba Code Calls/jump count: 1 Data use count: 0}}
        xor     b                 ;{{34ba:a8}} 
        ld      b,a               ;{{34bb:47}} 
_real_addition_16:                ;{{Addr=$34bc Code Calls/jump count: 2 Data use count: 0}}
        ld      a,(ix+$04)        ;{{34bc:dd7e04}} 
        cp      (iy+$04)          ;{{34bf:fdbe04}} 
        jr      nc,_real_addition_31;{{34c2:3014}}  (+&14)
        ld      d,b               ;{{34c4:50}} 
        ld      b,c               ;{{34c5:41}} 
        ld      c,d               ;{{34c6:4a}} 
        or      a                 ;{{34c7:b7}} 
        ld      d,a               ;{{34c8:57}} 
        ld      a,(iy+$04)        ;{{34c9:fd7e04}} 
        ld      (ix+$04),a        ;{{34cc:dd7704}} 
        jr      z,_real_addition_74;{{34cf:2854}}  (+&54)
        sub     d                 ;{{34d1:92}} 
        cp      $21               ;{{34d2:fe21}} 
        jr      nc,_real_addition_74;{{34d4:304f}}  (+&4f)
        jr      _real_addition_40 ;{{34d6:1811}}  (+&11)

_real_addition_31:                ;{{Addr=$34d8 Code Calls/jump count: 1 Data use count: 0}}
        xor     a                 ;{{34d8:af}} 
        sub     (iy+$04)          ;{{34d9:fd9604}} 
        jr      z,_real_addition_80;{{34dc:2859}}  (+&59)
        add     a,(ix+$04)        ;{{34de:dd8604}} 
        cp      $21               ;{{34e1:fe21}} 
        jr      nc,_real_addition_80;{{34e3:3052}}  (+&52)
        push    hl                ;{{34e5:e5}} 
        pop     iy                ;{{34e6:fde1}} 
        ex      de,hl             ;{{34e8:eb}} 
_real_addition_40:                ;{{Addr=$34e9 Code Calls/jump count: 1 Data use count: 0}}
        ld      e,a               ;{{34e9:5f}} 
        ld      a,b               ;{{34ea:78}} 
        xor     c                 ;{{34eb:a9}} 
        push    af                ;{{34ec:f5}} 
        push    bc                ;{{34ed:c5}} 
        ld      a,e               ;{{34ee:7b}} 
        call    x3743_code        ;{{34ef:cd4337}} 
        ld      a,c               ;{{34f2:79}} 
        pop     bc                ;{{34f3:c1}} 
        ld      c,a               ;{{34f4:4f}} 
        pop     af                ;{{34f5:f1}} 
        jp      m,_real_addition_83;{{34f6:fa3c35}} 
        ld      a,(iy+$00)        ;{{34f9:fd7e00}} 
        add     a,l               ;{{34fc:85}} 
        ld      l,a               ;{{34fd:6f}} 
        ld      a,(iy+$01)        ;{{34fe:fd7e01}} 
        adc     a,h               ;{{3501:8c}} 
        ld      h,a               ;{{3502:67}} 
        ld      a,(iy+$02)        ;{{3503:fd7e02}} 
        adc     a,e               ;{{3506:8b}} 
        ld      e,a               ;{{3507:5f}} 
        ld      a,(iy+$03)        ;{{3508:fd7e03}} 
        set     7,a               ;{{350b:cbff}} 
        adc     a,d               ;{{350d:8a}} 
        ld      d,a               ;{{350e:57}} 
        jp      nc,_process_real_at_hl_18;{{350f:d2b737}} 
        rr      d                 ;{{3512:cb1a}} 
        rr      e                 ;{{3514:cb1b}} 
        rr      h                 ;{{3516:cb1c}} 
        rr      l                 ;{{3518:cb1d}} 
        rr      c                 ;{{351a:cb19}} 
        inc     (ix+$04)          ;{{351c:dd3404}} 
        jp      nz,_process_real_at_hl_18;{{351f:c2b737}} 
        jp      REAL_at_IX_to_max_pos_or_max_neg;{{3522:c3ea37}} 

_real_addition_74:                ;{{Addr=$3525 Code Calls/jump count: 2 Data use count: 0}}
        ld      a,(iy+$02)        ;{{3525:fd7e02}} 
        ld      (ix+$02),a        ;{{3528:dd7702}} 
        ld      a,(iy+$01)        ;{{352b:fd7e01}} 
        ld      (ix+$01),a        ;{{352e:dd7701}} 
        ld      a,(iy+$00)        ;{{3531:fd7e00}} 
        ld      (ix+$00),a        ;{{3534:dd7700}} 
_real_addition_80:                ;{{Addr=$3537 Code Calls/jump count: 2 Data use count: 0}}
        ld      (ix+$03),b        ;{{3537:dd7003}} 
        scf                       ;{{353a:37}} 
        ret                       ;{{353b:c9}} 

_real_addition_83:                ;{{Addr=$353c Code Calls/jump count: 1 Data use count: 0}}
        xor     a                 ;{{353c:af}} 
        sub     c                 ;{{353d:91}} 
        ld      c,a               ;{{353e:4f}} 
        ld      a,(iy+$00)        ;{{353f:fd7e00}} 
        sbc     a,l               ;{{3542:9d}} 
        ld      l,a               ;{{3543:6f}} 
        ld      a,(iy+$01)        ;{{3544:fd7e01}} 
        sbc     a,h               ;{{3547:9c}} 
        ld      h,a               ;{{3548:67}} 
        ld      a,(iy+$02)        ;{{3549:fd7e02}} 
        sbc     a,e               ;{{354c:9b}} 
        ld      e,a               ;{{354d:5f}} 
        ld      a,(iy+$03)        ;{{354e:fd7e03}} 
        set     7,a               ;{{3551:cbff}} 
        sbc     a,d               ;{{3553:9a}} 
        ld      d,a               ;{{3554:57}} 
        jr      nc,_real_addition_118;{{3555:3016}}  (+&16)
        ld      a,b               ;{{3557:78}} 
        cpl                       ;{{3558:2f}} 
        ld      b,a               ;{{3559:47}} 
        xor     a                 ;{{355a:af}} 
        sub     c                 ;{{355b:91}} 
        ld      c,a               ;{{355c:4f}} 
        ld      a,$00             ;{{355d:3e00}} 
        sbc     a,l               ;{{355f:9d}} 
        ld      l,a               ;{{3560:6f}} 
        ld      a,$00             ;{{3561:3e00}} 
        sbc     a,h               ;{{3563:9c}} 
        ld      h,a               ;{{3564:67}} 
        ld      a,$00             ;{{3565:3e00}} 
        sbc     a,e               ;{{3567:9b}} 
        ld      e,a               ;{{3568:5f}} 
        ld      a,$00             ;{{3569:3e00}} 
        sbc     a,d               ;{{356b:9a}} 
        ld      d,a               ;{{356c:57}} 
_real_addition_118:               ;{{Addr=$356d Code Calls/jump count: 1 Data use count: 0}}
        jp      _process_real_at_hl_13;{{356d:c3ac37}} 

_real_addition_119:               ;{{Addr=$3570 Code Calls/jump count: 3 Data use count: 0}}
        ld      de,internal_REAL_store_2;{{3570:1109b1}} 
        call    REAL_copy_atHL_to_atDE_swapped;{{3573:cd902f}} 
        ex      de,hl             ;{{3576:eb}} 

;;============================================================================================
;; REAL multiplication
REAL_multiplication:              ;{{Addr=$3577 Code Calls/jump count: 13 Data use count: 1}}
        push    de                ;{{3577:d5}} 
        pop     iy                ;{{3578:fde1}} 
        push    hl                ;{{357a:e5}} 
        pop     ix                ;{{357b:dde1}} 
        ld      a,(iy+$04)        ;{{357d:fd7e04}} 
        or      a                 ;{{3580:b7}} 
        jr      z,_real_multiplication_30;{{3581:282a}}  (+&2a)
        dec     a                 ;{{3583:3d}} 
        call    _real_division_98 ;{{3584:cdaf36}} 
        jr      z,_real_multiplication_30;{{3587:2824}}  (+&24)
        jr      nc,_real_multiplication_29;{{3589:301f}}  (+&1f)
        push    af                ;{{358b:f5}} 
        push    bc                ;{{358c:c5}} 
        call    _real_multiplication_31;{{358d:cdb035}} 
        ld      a,c               ;{{3590:79}} 
        pop     bc                ;{{3591:c1}} 
        ld      c,a               ;{{3592:4f}} 
        pop     af                ;{{3593:f1}} 
        bit     7,d               ;{{3594:cb7a}} 
        jr      nz,_real_multiplication_26;{{3596:200b}}  (+&0b)
        dec     a                 ;{{3598:3d}} 
        jr      z,_real_multiplication_30;{{3599:2812}}  (+&12)
        sla     c                 ;{{359b:cb21}} 
        adc     hl,hl             ;{{359d:ed6a}} 
        rl      e                 ;{{359f:cb13}} 
        rl      d                 ;{{35a1:cb12}} 
_real_multiplication_26:          ;{{Addr=$35a3 Code Calls/jump count: 1 Data use count: 0}}
        ld      (ix+$04),a        ;{{35a3:dd7704}} 
        or      a                 ;{{35a6:b7}} 
        jp      nz,_process_real_at_hl_18;{{35a7:c2b737}} 
_real_multiplication_29:          ;{{Addr=$35aa Code Calls/jump count: 1 Data use count: 0}}
        jp      REAL_at_IX_to_max_pos_or_max_neg;{{35aa:c3ea37}} 

_real_multiplication_30:          ;{{Addr=$35ad Code Calls/jump count: 3 Data use count: 0}}
        jp      _process_real_at_hl_42;{{35ad:c3e237}} 

_real_multiplication_31:          ;{{Addr=$35b0 Code Calls/jump count: 1 Data use count: 0}}
        ld      hl,$0000          ;{{35b0:210000}} ##LIT##;WARNING: Code area used as literal
        ld      e,l               ;{{35b3:5d}} 
        ld      d,h               ;{{35b4:54}} 
        ld      a,(iy+$00)        ;{{35b5:fd7e00}} 
        call    _real_multiplication_65;{{35b8:cdf335}} 
        ld      a,(iy+$01)        ;{{35bb:fd7e01}} 
        call    _real_multiplication_65;{{35be:cdf335}} 
        ld      a,(iy+$02)        ;{{35c1:fd7e02}} 
        call    _real_multiplication_65;{{35c4:cdf335}} 
        ld      a,(iy+$03)        ;{{35c7:fd7e03}} 
        or      $80               ;{{35ca:f680}} 
_real_multiplication_42:          ;{{Addr=$35cc Code Calls/jump count: 1 Data use count: 0}}
        ld      b,$08             ;{{35cc:0608}} 
        rra                       ;{{35ce:1f}} 
        ld      c,a               ;{{35cf:4f}} 
_real_multiplication_45:          ;{{Addr=$35d0 Code Calls/jump count: 1 Data use count: 0}}
        jr      nc,_real_multiplication_58;{{35d0:3014}}  (+&14)
        ld      a,l               ;{{35d2:7d}} 
        add     a,(ix+$00)        ;{{35d3:dd8600}} 
        ld      l,a               ;{{35d6:6f}} 
        ld      a,h               ;{{35d7:7c}} 
        adc     a,(ix+$01)        ;{{35d8:dd8e01}} 
        ld      h,a               ;{{35db:67}} 
        ld      a,e               ;{{35dc:7b}} 
        adc     a,(ix+$02)        ;{{35dd:dd8e02}} 
        ld      e,a               ;{{35e0:5f}} 
        ld      a,d               ;{{35e1:7a}} 
        adc     a,(ix+$03)        ;{{35e2:dd8e03}} 
        ld      d,a               ;{{35e5:57}} 
_real_multiplication_58:          ;{{Addr=$35e6 Code Calls/jump count: 1 Data use count: 0}}
        rr      d                 ;{{35e6:cb1a}} 
        rr      e                 ;{{35e8:cb1b}} 
        rr      h                 ;{{35ea:cb1c}} 
        rr      l                 ;{{35ec:cb1d}} 
        rr      c                 ;{{35ee:cb19}} 
        djnz    _real_multiplication_45;{{35f0:10de}}  (-&22)
        ret                       ;{{35f2:c9}} 

_real_multiplication_65:          ;{{Addr=$35f3 Code Calls/jump count: 3 Data use count: 0}}
        or      a                 ;{{35f3:b7}} 
        jr      nz,_real_multiplication_42;{{35f4:20d6}}  (-&2a)
        ld      l,h               ;{{35f6:6c}} 
        ld      h,e               ;{{35f7:63}} 
        ld      e,d               ;{{35f8:5a}} 
        ld      d,a               ;{{35f9:57}} 
        ret                       ;{{35fa:c9}} 

_real_multiplication_72:          ;{{Addr=$35fb Code Calls/jump count: 2 Data use count: 0}}
        call    REAL_copy_atHL_to_b10e_swapped;{{35fb:cd872f}} 
        ex      de,hl             ;{{35fe:eb}} 
        push    de                ;{{35ff:d5}} 
        call    REAL_ONE_to_DE    ;{{3600:cd7d2f}} 
        pop     de                ;{{3603:d1}} 

;;============================================================================================
;; REAL division
REAL_division:                    ;{{Addr=$3604 Code Calls/jump count: 5 Data use count: 1}}
        push    de                ;{{3604:d5}} 
        pop     iy                ;{{3605:fde1}} 
        push    hl                ;{{3607:e5}} 
        pop     ix                ;{{3608:dde1}} 
        xor     a                 ;{{360a:af}} 
        sub     (iy+$04)          ;{{360b:fd9604}} 
        jr      z,_real_division_54;{{360e:285a}}  (+&5a)
        call    _real_division_98 ;{{3610:cdaf36}} 
        jp      z,_process_real_at_hl_42;{{3613:cae237}} 
        jr      nc,_real_division_53;{{3616:304f}}  (+&4f)
        push    bc                ;{{3618:c5}} 
        ld      c,a               ;{{3619:4f}} 
        ld      e,(hl)            ;{{361a:5e}} 
        inc     hl                ;{{361b:23}} 
        ld      d,(hl)            ;{{361c:56}} 
        inc     hl                ;{{361d:23}} 
        ld      a,(hl)            ;{{361e:7e}} 
        inc     hl                ;{{361f:23}} 
        ld      h,(hl)            ;{{3620:66}} 
        ld      l,a               ;{{3621:6f}} 
        ex      de,hl             ;{{3622:eb}} 
        ld      b,(iy+$03)        ;{{3623:fd4603}} 
        set     7,b               ;{{3626:cbf8}} 
        call    _real_division_86 ;{{3628:cd9d36}} 
        jr      c,_real_division_29;{{362b:3806}}  (+&06)
        ld      a,c               ;{{362d:79}} 
        or      a                 ;{{362e:b7}} 
        jr      nz,_real_division_33;{{362f:2008}}  (+&08)
        jr      _real_division_52 ;{{3631:1833}}  (+&33)

_real_division_29:                ;{{Addr=$3633 Code Calls/jump count: 1 Data use count: 0}}
        dec     c                 ;{{3633:0d}} 
        add     hl,hl             ;{{3634:29}} 
        rl      e                 ;{{3635:cb13}} 
        rl      d                 ;{{3637:cb12}} 
_real_division_33:                ;{{Addr=$3639 Code Calls/jump count: 1 Data use count: 0}}
        ld      (ix+$04),c        ;{{3639:dd7104}} 
        call    _real_division_58 ;{{363c:cd7236}} 
        ld      (ix+$03),c        ;{{363f:dd7103}} 
        call    _real_division_58 ;{{3642:cd7236}} 
        ld      (ix+$02),c        ;{{3645:dd7102}} 
        call    _real_division_58 ;{{3648:cd7236}} 
        ld      (ix+$01),c        ;{{364b:dd7101}} 
        call    _real_division_58 ;{{364e:cd7236}} 
        ccf                       ;{{3651:3f}} 
        call    c,_real_division_86;{{3652:dc9d36}} 
        ccf                       ;{{3655:3f}} 
        sbc     a,a               ;{{3656:9f}} 
        ld      l,c               ;{{3657:69}} 
        ld      h,(ix+$01)        ;{{3658:dd6601}} 
        ld      e,(ix+$02)        ;{{365b:dd5e02}} 
        ld      d,(ix+$03)        ;{{365e:dd5603}} 
        pop     bc                ;{{3661:c1}} 
        ld      c,a               ;{{3662:4f}} 
        jp      _process_real_at_hl_18;{{3663:c3b737}} 

_real_division_52:                ;{{Addr=$3666 Code Calls/jump count: 1 Data use count: 0}}
        pop     bc                ;{{3666:c1}} 
_real_division_53:                ;{{Addr=$3667 Code Calls/jump count: 1 Data use count: 0}}
        jp      REAL_at_IX_to_max_pos_or_max_neg;{{3667:c3ea37}} 

_real_division_54:                ;{{Addr=$366a Code Calls/jump count: 1 Data use count: 0}}
        ld      b,(ix+$03)        ;{{366a:dd4603}} 
        call    REAL_at_IX_to_max_pos_or_max_neg;{{366d:cdea37}} 
        xor     a                 ;{{3670:af}} 
        ret                       ;{{3671:c9}} 

_real_division_58:                ;{{Addr=$3672 Code Calls/jump count: 4 Data use count: 0}}
        ld      c,$01             ;{{3672:0e01}} 
_real_division_59:                ;{{Addr=$3674 Code Calls/jump count: 1 Data use count: 0}}
        jr      c,_real_division_65;{{3674:3808}}  (+&08)
        ld      a,d               ;{{3676:7a}} 
        cp      b                 ;{{3677:b8}} 
        call    z,_real_division_89;{{3678:cca036}} 
        ccf                       ;{{367b:3f}} 
        jr      nc,_real_division_78;{{367c:3013}}  (+&13)
_real_division_65:                ;{{Addr=$367e Code Calls/jump count: 1 Data use count: 0}}
        ld      a,l               ;{{367e:7d}} 
        sub     (iy+$00)          ;{{367f:fd9600}} 
        ld      l,a               ;{{3682:6f}} 
        ld      a,h               ;{{3683:7c}} 
        sbc     a,(iy+$01)        ;{{3684:fd9e01}} 
        ld      h,a               ;{{3687:67}} 
        ld      a,e               ;{{3688:7b}} 
        sbc     a,(iy+$02)        ;{{3689:fd9e02}} 
        ld      e,a               ;{{368c:5f}} 
        ld      a,d               ;{{368d:7a}} 
        sbc     a,b               ;{{368e:98}} 
        ld      d,a               ;{{368f:57}} 
        scf                       ;{{3690:37}} 
_real_division_78:                ;{{Addr=$3691 Code Calls/jump count: 1 Data use count: 0}}
        rl      c                 ;{{3691:cb11}} 
        sbc     a,a               ;{{3693:9f}} 
        add     hl,hl             ;{{3694:29}} 
        rl      e                 ;{{3695:cb13}} 
        rl      d                 ;{{3697:cb12}} 
        inc     a                 ;{{3699:3c}} 
        jr      nz,_real_division_59;{{369a:20d8}}  (-&28)
        ret                       ;{{369c:c9}} 

_real_division_86:                ;{{Addr=$369d Code Calls/jump count: 2 Data use count: 0}}
        ld      a,d               ;{{369d:7a}} 
        cp      b                 ;{{369e:b8}} 
        ret     nz                ;{{369f:c0}} 

_real_division_89:                ;{{Addr=$36a0 Code Calls/jump count: 1 Data use count: 0}}
        ld      a,e               ;{{36a0:7b}} 
        cp      (iy+$02)          ;{{36a1:fdbe02}} 
        ret     nz                ;{{36a4:c0}} 

        ld      a,h               ;{{36a5:7c}} 
        cp      (iy+$01)          ;{{36a6:fdbe01}} 
        ret     nz                ;{{36a9:c0}} 

        ld      a,l               ;{{36aa:7d}} 
        cp      (iy+$00)          ;{{36ab:fdbe00}} 
        ret                       ;{{36ae:c9}} 

_real_division_98:                ;{{Addr=$36af Code Calls/jump count: 2 Data use count: 0}}
        ld      c,a               ;{{36af:4f}} 
        ld      a,(ix+$03)        ;{{36b0:dd7e03}} 
        xor     (iy+$03)          ;{{36b3:fdae03}} 
        ld      b,a               ;{{36b6:47}} 
        ld      a,(ix+$04)        ;{{36b7:dd7e04}} 
        or      a                 ;{{36ba:b7}} 
        ret     z                 ;{{36bb:c8}} 

        add     a,c               ;{{36bc:81}} 
        ld      c,a               ;{{36bd:4f}} 
        rra                       ;{{36be:1f}} 
        xor     c                 ;{{36bf:a9}} 
        ld      a,c               ;{{36c0:79}} 
        jp      p,_real_division_117;{{36c1:f2cf36}} 
        set     7,(ix+$03)        ;{{36c4:ddcb03fe}} 
        sub     $7f               ;{{36c8:d67f}} 
        scf                       ;{{36ca:37}} 
        ret     nz                ;{{36cb:c0}} 

        cp      $01               ;{{36cc:fe01}} 
        ret                       ;{{36ce:c9}} 

_real_division_117:               ;{{Addr=$36cf Code Calls/jump count: 1 Data use count: 0}}
        or      a                 ;{{36cf:b7}} 
        ret     m                 ;{{36d0:f8}} 

        xor     a                 ;{{36d1:af}} 
        ret                       ;{{36d2:c9}} 

_real_division_121:               ;{{Addr=$36d3 Code Calls/jump count: 2 Data use count: 0}}
        push    hl                ;{{36d3:e5}} 
        pop     ix                ;{{36d4:dde1}} 
        ld      a,(ix+$04)        ;{{36d6:dd7e04}} 
        or      a                 ;{{36d9:b7}} 
        ret     z                 ;{{36da:c8}} 

        sub     $80               ;{{36db:d680}} 
        scf                       ;{{36dd:37}} 
        ret                       ;{{36de:c9}} 

;;============================================================================================
;; REAL compare

REAL_compare:                     ;{{Addr=$36df Code Calls/jump count: 3 Data use count: 1}}
        push    hl                ;{{36df:e5}} 
        pop     ix                ;{{36e0:dde1}} 
_real_compare_2:                  ;{{Addr=$36e2 Code Calls/jump count: 2 Data use count: 0}}
        push    de                ;{{36e2:d5}} 
        pop     iy                ;{{36e3:fde1}} 
        ld      a,(ix+$04)        ;{{36e5:dd7e04}} 
        cp      (iy+$04)          ;{{36e8:fdbe04}} 
        jr      c,_real_compare_25;{{36eb:382c}}  (+&2c)
        jr      nz,_real_compare_32;{{36ed:2033}}  (+&33)
        or      a                 ;{{36ef:b7}} 
        ret     z                 ;{{36f0:c8}} 

        ld      a,(ix+$03)        ;{{36f1:dd7e03}} 
        xor     (iy+$03)          ;{{36f4:fdae03}} 
        jp      m,_real_compare_32;{{36f7:fa2237}} 
        ld      a,(ix+$03)        ;{{36fa:dd7e03}} 
        sub     (iy+$03)          ;{{36fd:fd9603}} 
        jr      nz,_real_compare_25;{{3700:2017}}  (+&17)
        ld      a,(ix+$02)        ;{{3702:dd7e02}} 
        sub     (iy+$02)          ;{{3705:fd9602}} 
        jr      nz,_real_compare_25;{{3708:200f}}  (+&0f)
        ld      a,(ix+$01)        ;{{370a:dd7e01}} 
        sub     (iy+$01)          ;{{370d:fd9601}} 
        jr      nz,_real_compare_25;{{3710:2007}}  (+&07)
        ld      a,(ix+$00)        ;{{3712:dd7e00}} 
        sub     (iy+$00)          ;{{3715:fd9600}} 
        ret     z                 ;{{3718:c8}} 

_real_compare_25:                 ;{{Addr=$3719 Code Calls/jump count: 4 Data use count: 0}}
        sbc     a,a               ;{{3719:9f}} 
        xor     (iy+$03)          ;{{371a:fdae03}} 
_real_compare_27:                 ;{{Addr=$371d Code Calls/jump count: 1 Data use count: 0}}
        add     a,a               ;{{371d:87}} 
        sbc     a,a               ;{{371e:9f}} 
        ret     c                 ;{{371f:d8}} 

        inc     a                 ;{{3720:3c}} 
        ret                       ;{{3721:c9}} 

_real_compare_32:                 ;{{Addr=$3722 Code Calls/jump count: 3 Data use count: 0}}
        ld      a,(ix+$03)        ;{{3722:dd7e03}} 
        jr      _real_compare_27  ;{{3725:18f6}}  (-&0a)

;;============================================================================================
;; REAL SGN

REAL_SGN:                         ;{{Addr=$3727 Code Calls/jump count: 7 Data use count: 1}}
        push    hl                ;{{3727:e5}} 
        pop     ix                ;{{3728:dde1}} 
        ld      a,(ix+$04)        ;{{372a:dd7e04}} 
        or      a                 ;{{372d:b7}} 
        ret     z                 ;{{372e:c8}} 

        jr      _real_compare_32  ;{{372f:18f1}}  (-&0f)

;;============================================================================================
;; REAL Negate

REAL_Negate:                      ;{{Addr=$3731 Code Calls/jump count: 1 Data use count: 1}}
        push    hl                ;{{3731:e5}} 
        pop     ix                ;{{3732:dde1}} 
_real_negate_2:                   ;{{Addr=$3734 Code Calls/jump count: 6 Data use count: 0}}
        ld      a,(ix+$03)        ;{{3734:dd7e03}} 
        xor     $80               ;{{3737:ee80}} 
        ld      (ix+$03),a        ;{{3739:dd7703}} 
        ret                       ;{{373c:c9}} 

;;============================================================================================
x373d_code:                       ;{{Addr=$373d Code Calls/jump count: 2 Data use count: 0}}
        cp      $21               ;{{373d:fe21}} 
        jr      c,x3743_code      ;{{373f:3802}}  (+&02)
        ld      a,$21             ;{{3741:3e21}} 
x3743_code:                       ;{{Addr=$3743 Code Calls/jump count: 2 Data use count: 0}}
        ld      e,(hl)            ;{{3743:5e}} 
        inc     hl                ;{{3744:23}} 
        ld      d,(hl)            ;{{3745:56}} 
        inc     hl                ;{{3746:23}} 
        ld      c,(hl)            ;{{3747:4e}} 
        inc     hl                ;{{3748:23}} 
        ld      h,(hl)            ;{{3749:66}} 
        ld      l,c               ;{{374a:69}} 
        ex      de,hl             ;{{374b:eb}} 
        set     7,d               ;{{374c:cbfa}} 
        ld      bc,$0000          ;{{374e:010000}} ##LIT##;WARNING: Code area used as literal
        jr      x375e_code        ;{{3751:180b}}  (+&0b)

x3753_code:                       ;{{Addr=$3753 Code Calls/jump count: 1 Data use count: 0}}
        ld      c,a               ;{{3753:4f}} 
        ld      a,b               ;{{3754:78}} 
        or      l                 ;{{3755:b5}} 
        ld      b,a               ;{{3756:47}} 
        ld      a,c               ;{{3757:79}} 
        ld      c,l               ;{{3758:4d}} 
        ld      l,h               ;{{3759:6c}} 
        ld      h,e               ;{{375a:63}} 
        ld      e,d               ;{{375b:5a}} 
        ld      d,$00             ;{{375c:1600}} 
x375e_code:                       ;{{Addr=$375e Code Calls/jump count: 1 Data use count: 0}}
        sub     $08               ;{{375e:d608}} 
        jr      nc,x3753_code     ;{{3760:30f1}}  (-&0f)
        add     a,$08             ;{{3762:c608}} 
        ret     z                 ;{{3764:c8}} 

x3765_code:                       ;{{Addr=$3765 Code Calls/jump count: 1 Data use count: 0}}
        srl     d                 ;{{3765:cb3a}} 
        rr      e                 ;{{3767:cb1b}} 
        rr      h                 ;{{3769:cb1c}} 
        rr      l                 ;{{376b:cb1d}} 
        rr      c                 ;{{376d:cb19}} 
        dec     a                 ;{{376f:3d}} 
        jr      nz,x3765_code     ;{{3770:20f3}}  (-&0d)
        ret                       ;{{3772:c9}} 

;;============================================================================================
x3773_code:                       ;{{Addr=$3773 Code Calls/jump count: 1 Data use count: 0}}
        jr      nz,x378c_code     ;{{3773:2017}}  (+&17)
        ld      d,a               ;{{3775:57}} 
        ld      a,e               ;{{3776:7b}} 
        or      h                 ;{{3777:b4}} 
        or      l                 ;{{3778:b5}} 
        or      c                 ;{{3779:b1}} 
        ret     z                 ;{{377a:c8}} 

        ld      a,d               ;{{377b:7a}} 
x377c_code:                       ;{{Addr=$377c Code Calls/jump count: 1 Data use count: 0}}
        sub     $08               ;{{377c:d608}} 
        jr      c,x379a_code      ;{{377e:381a}}  (+&1a)
        ret     z                 ;{{3780:c8}} 

        ld      d,e               ;{{3781:53}} 
        ld      e,h               ;{{3782:5c}} 
        ld      h,l               ;{{3783:65}} 
        ld      l,c               ;{{3784:69}} 
        ld      c,$00             ;{{3785:0e00}} 
        inc     d                 ;{{3787:14}} 
        dec     d                 ;{{3788:15}} 
        jr      z,x377c_code      ;{{3789:28f1}}  (-&0f)
        ret     m                 ;{{378b:f8}} 

x378c_code:                       ;{{Addr=$378c Code Calls/jump count: 2 Data use count: 0}}
        dec     a                 ;{{378c:3d}} 
        ret     z                 ;{{378d:c8}} 

        sla     c                 ;{{378e:cb21}} 
        adc     hl,hl             ;{{3790:ed6a}} 
        rl      e                 ;{{3792:cb13}} 
        rl      d                 ;{{3794:cb12}} 
        jp      p,x378c_code      ;{{3796:f28c37}} 
        ret                       ;{{3799:c9}} 

x379a_code:                       ;{{Addr=$379a Code Calls/jump count: 1 Data use count: 0}}
        xor     a                 ;{{379a:af}} 
        ret                       ;{{379b:c9}} 

;;============================================
;;Process REAL at (HL)
Process_REAL_at_HL:               ;{{Addr=$379c Code Calls/jump count: 1 Data use count: 0}}
        push    hl                ;{{379c:e5}} 
        pop     ix                ;{{379d:dde1}} 
        ld      (ix+$04),b        ;{{379f:dd7004}} 
        ld      b,a               ;{{37a2:47}} 
        ld      e,(hl)            ;{{37a3:5e}} 
        inc     hl                ;{{37a4:23}} 
        ld      d,(hl)            ;{{37a5:56}} 
        inc     hl                ;{{37a6:23}} 
        ld      a,(hl)            ;{{37a7:7e}} 
        inc     hl                ;{{37a8:23}} 
        ld      h,(hl)            ;{{37a9:66}} 
        ld      l,a               ;{{37aa:6f}} 
        ex      de,hl             ;{{37ab:eb}} 
_process_real_at_hl_13:           ;{{Addr=$37ac Code Calls/jump count: 2 Data use count: 0}}
        ld      a,(ix+$04)        ;{{37ac:dd7e04}} 
        dec     d                 ;{{37af:15}} 
        inc     d                 ;{{37b0:14}} 
        call    p,x3773_code      ;{{37b1:f47337}} 
        ld      (ix+$04),a        ;{{37b4:dd7704}} 
_process_real_at_hl_18:           ;{{Addr=$37b7 Code Calls/jump count: 4 Data use count: 0}}
        sla     c                 ;{{37b7:cb21}} 
        jr      nc,_process_real_at_hl_31;{{37b9:3012}}  (+&12)
        inc     l                 ;{{37bb:2c}} 
        jr      nz,_process_real_at_hl_31;{{37bc:200f}}  (+&0f)
        inc     h                 ;{{37be:24}} 
        jr      nz,_process_real_at_hl_31;{{37bf:200c}}  (+&0c)
        inc     de                ;{{37c1:13}} 
        ld      a,d               ;{{37c2:7a}} 
        or      e                 ;{{37c3:b3}} 
        jr      nz,_process_real_at_hl_31;{{37c4:2007}}  (+&07)
        inc     (ix+$04)          ;{{37c6:dd3404}} 
        jr      z,REAL_at_IX_to_max_pos_or_max_neg;{{37c9:281f}}  (+&1f)
        ld      d,$80             ;{{37cb:1680}} 
_process_real_at_hl_31:           ;{{Addr=$37cd Code Calls/jump count: 4 Data use count: 0}}
        ld      a,b               ;{{37cd:78}} 
        or      $7f               ;{{37ce:f67f}} 
        and     d                 ;{{37d0:a2}} 
        ld      (ix+$03),a        ;{{37d1:dd7703}} 
        ld      (ix+$02),e        ;{{37d4:dd7302}} 
        ld      (ix+$01),h        ;{{37d7:dd7401}} 
        ld      (ix+$00),l        ;{{37da:dd7500}} 
_process_real_at_hl_38:           ;{{Addr=$37dd Code Calls/jump count: 1 Data use count: 0}}
        push    ix                ;{{37dd:dde5}} 
        pop     hl                ;{{37df:e1}} 
        scf                       ;{{37e0:37}} 
        ret                       ;{{37e1:c9}} 

_process_real_at_hl_42:           ;{{Addr=$37e2 Code Calls/jump count: 5 Data use count: 0}}
        xor     a                 ;{{37e2:af}} 
        ld      (ix+$04),a        ;{{37e3:dd7704}} 
        jr      _process_real_at_hl_38;{{37e6:18f5}}  (-&0b)

;;============================================
;; REAL at IX to max pos
REAL_at_IX_to_max_pos:            ;{{Addr=$37e8 Code Calls/jump count: 2 Data use count: 0}}
        ld      b,$00             ;{{37e8:0600}} 

;;=REAL at IX to max pos or max neg
;;If B >= 0 store max positive real at (IX), otherwise max negative

REAL_at_IX_to_max_pos_or_max_neg: ;{{Addr=$37ea Code Calls/jump count: 6 Data use count: 0}}
        push    ix                ;{{37ea:dde5}} 
        pop     hl                ;{{37ec:e1}} 
        ld      a,b               ;{{37ed:78}} 
        or      $7f               ;{{37ee:f67f}} 
        ld      (ix+$03),a        ;{{37f0:dd7703}} 
        or      $ff               ;{{37f3:f6ff}} 
        ld      (ix+$04),a        ;{{37f5:dd7704}} 
        ld      (hl),a            ;{{37f8:77}} 
        ld      (ix+$01),a        ;{{37f9:dd7701}} 
        ld      (ix+$02),a        ;{{37fc:dd7702}} 
        ret                       ;{{37ff:c9}} 



