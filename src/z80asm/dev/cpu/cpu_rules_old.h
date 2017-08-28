/* altd djnz NN */
| label? _TK_ALTD _TK_DJNZ expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_jr(0x10); 
}

/* altd ld a,xpc */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* call c,NN */
| label? _TK_CALL _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(C); 
}

/* call lo,NN */
| label? _TK_CALL _TK_LO _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEC); 
}

/* call lz,NN */
| label? _TK_CALL _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE4); 
}

/* call m,NN */
| label? _TK_CALL _TK_M _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(M); 
}

/* call nc,NN */
| label? _TK_CALL _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(NC); 
}

/* call nv,NN */
| label? _TK_CALL _TK_NV _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE4); 
}

/* call nz,NN */
| label? _TK_CALL _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(NZ); 
}

/* call p,NN */
| label? _TK_CALL _TK_P _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(P); 
}

/* call pe,NN */
| label? _TK_CALL _TK_PE _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(PE); 
}

/* call po,NN */
| label? _TK_CALL _TK_PO _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(PO); 
}

/* call v,NN */
| label? _TK_CALL _TK_V _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEC); 
}

/* call z,NN */
| label? _TK_CALL _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_call_flag(Z); 
}

/* call NN */
| label? _TK_CALL expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xCD); 
}

/* cpd */
| label? _TK_CPD _TK_NEWLINE @{
  DO_stmt_emul(0xEDA9, rcmx_cpd); 
}

/* cpdr */
| label? _TK_CPDR _TK_NEWLINE @{
  DO_stmt_emul(0xEDB9, rcmx_cpdr); 
}

/* cpi */
| label? _TK_CPI _TK_NEWLINE @{
  DO_stmt_emul(0xEDA1, rcmx_cpi); 
}

/* cpir */
| label? _TK_CPIR _TK_NEWLINE @{
  DO_stmt_emul(0xEDB1, rcmx_cpir); 
}

/* djnz b,NN */
| label? _TK_DJNZ _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x10); 
}

/* djnz b',NN */
| label? _TK_DJNZ _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_jr(0x10); 
}

/* djnz NN */
| label? _TK_DJNZ expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x10); 
}

/* in a,(c) */
| label? _TK_IN _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED78); 
}

/* in a,(N) */
| label? _TK_IN _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xDB); 
}

/* in b,(c) */
| label? _TK_IN _TK_B _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED40); 
}

/* in c,(c) */
| label? _TK_IN _TK_C _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED48); 
}

/* in d,(c) */
| label? _TK_IN _TK_D _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED50); 
}

/* in e,(c) */
| label? _TK_IN _TK_E _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED58); 
}

/* in f,(c) */
| label? _TK_IN _TK_F _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED70); 
}

/* in h,(c) */
| label? _TK_IN _TK_H _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED60); 
}

/* in l,(c) */
| label? _TK_IN _TK_L _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED68); 
}

/* in0 a,(N) */
| label? _TK_IN0 _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED38); 
}

/* in0 b,(N) */
| label? _TK_IN0 _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED00); 
}

/* in0 c,(N) */
| label? _TK_IN0 _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED08); 
}

/* in0 d,(N) */
| label? _TK_IN0 _TK_D _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED10); 
}

/* in0 e,(N) */
| label? _TK_IN0 _TK_E _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED18); 
}

/* in0 f,(N) */
| label? _TK_IN0 _TK_F _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED30); 
}

/* in0 h,(N) */
| label? _TK_IN0 _TK_H _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED20); 
}

/* in0 l,(N) */
| label? _TK_IN0 _TK_L _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED28); 
}

/* ind */
| label? _TK_IND _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDAA); 
}

/* indr */
| label? _TK_INDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDBA); 
}

/* ini */
| label? _TK_INI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDA2); 
}

/* inir */
| label? _TK_INIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDB2); 
}

/* ioe ldd */
| label? _TK_IOE _TK_LDD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDA8); 
}

/* ioe lddr */
| label? _TK_IOE _TK_LDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDB8); 
}

/* ioe ldi */
| label? _TK_IOE _TK_LDI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDA0); 
}

/* ioe ldir */
| label? _TK_IOE _TK_LDIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDBEDB0); 
}

/* ioi ldd */
| label? _TK_IOI _TK_LDD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDA8); 
}

/* ioi lddr */
| label? _TK_IOI _TK_LDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDB8); 
}

/* ioi ldi */
| label? _TK_IOI _TK_LDI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDA0); 
}

/* ioi ldir */
| label? _TK_IOI _TK_LDIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD3EDB0); 
}

/* jp c,NN */
| label? _TK_JP _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xDA); 
}

/* jp (hl) */
| label? _TK_JP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xE9); 
}

/* jp (ix) */
| label? _TK_JP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDE9); 
  }
  else {
    DO_stmt(0xFDE9); 
  }
}

/* jp (iy) */
| label? _TK_JP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE9); 
  }
  else {
    DO_stmt(0xDDE9); 
  }
}

/* jp lo,NN */
| label? _TK_JP _TK_LO _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp lz,NN */
| label? _TK_JP _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp m,NN */
| label? _TK_JP _TK_M _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xFA); 
}

/* jp nc,NN */
| label? _TK_JP _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xD2); 
}

/* jp nv,NN */
| label? _TK_JP _TK_NV _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp nz,NN */
| label? _TK_JP _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xC2); 
}

/* jp p,NN */
| label? _TK_JP _TK_P _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xF2); 
}

/* jp pe,NN */
| label? _TK_JP _TK_PE _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp po,NN */
| label? _TK_JP _TK_PO _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xE2); 
}

/* jp v,NN */
| label? _TK_JP _TK_V _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xEA); 
}

/* jp z,NN */
| label? _TK_JP _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xCA); 
}

/* jp NN */
| label? _TK_JP expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_nn(0xC3); 
}

/* jr c,NN */
| label? _TK_JR _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x38); 
}

/* jr nc,NN */
| label? _TK_JR _TK_NC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x30); 
}

/* jr nz,NN */
| label? _TK_JR _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x20); 
}

/* jr z,NN */
| label? _TK_JR _TK_Z _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x28); 
}

/* jr NN */
| label? _TK_JR expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_jr(0x18); 
}

/* ld a,xpc */
| label? _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED77); 
}

/* ld a',xpc */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* ld xpc,a */
| label? _TK_LD _TK_XPC _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED67); 
}

/* ldd */
| label? _TK_LDD _TK_NEWLINE @{
  DO_stmt(0xEDA8); 
}

/* lddr */
| label? _TK_LDDR _TK_NEWLINE @{
  DO_stmt(0xEDB8); 
}

/* lddsr */
| label? _TK_LDDSR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED98); 
}

/* ldi */
| label? _TK_LDI _TK_NEWLINE @{
  DO_stmt(0xEDA0); 
}

/* ldir */
| label? _TK_LDIR _TK_NEWLINE @{
  DO_stmt(0xEDB0); 
}

/* ldisr */
| label? _TK_LDISR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED90); 
}

/* lsddr */
| label? _TK_LSDDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDD8); 
}

/* lsdr */
| label? _TK_LSDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDF8); 
}

/* lsidr */
| label? _TK_LSIDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDD0); 
}

/* lsir */
| label? _TK_LSIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDF0); 
}

/* otdm */
| label? _TK_OTDM _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED8B); 
}

/* otdmr */
| label? _TK_OTDMR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED9B); 
}

/* otdr */
| label? _TK_OTDR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDBB); 
}

/* otim */
| label? _TK_OTIM _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED83); 
}

/* otimr */
| label? _TK_OTIMR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED93); 
}

/* otir */
| label? _TK_OTIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDB3); 
}

/* out (c),a */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED79); 
}

/* out (c),b */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED41); 
}

/* out (c),c */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED49); 
}

/* out (c),d */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED51); 
}

/* out (c),e */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED59); 
}

/* out (c),h */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED61); 
}

/* out (c),l */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED69); 
}

/* out (c),0 */
| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED71); 
  }
  else
    error_int_range(expr_value);

}

/* out (N),a */
| label? _TK_OUT expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xD3); 
}

/* out0 (N),a */
| label? _TK_OUT0 expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED39); 
}

/* out0 (N),b */
| label? _TK_OUT0 expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED01); 
}

/* out0 (N),c */
| label? _TK_OUT0 expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED09); 
}

/* out0 (N),d */
| label? _TK_OUT0 expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED11); 
}

/* out0 (N),e */
| label? _TK_OUT0 expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED19); 
}

/* out0 (N),h */
| label? _TK_OUT0 expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED21); 
}

/* out0 (N),l */
| label? _TK_OUT0 expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_n(0xED29); 
}

/* outd */
| label? _TK_OUTD _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDAB); 
}

/* outi */
| label? _TK_OUTI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDA3); 
}

/* ret */
| label? _TK_RET _TK_NEWLINE @{
  DO_stmt(0xC9); 
}

/* ret c */
| label? _TK_RET _TK_C _TK_NEWLINE @{
  DO_stmt(0xD8); 
}

/* ret lo */
| label? _TK_RET _TK_LO _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xE8); 
}

/* ret lz */
| label? _TK_RET _TK_LZ _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xE0); 
}

/* ret m */
| label? _TK_RET _TK_M _TK_NEWLINE @{
  DO_stmt(0xF8); 
}

/* ret nc */
| label? _TK_RET _TK_NC _TK_NEWLINE @{
  DO_stmt(0xD0); 
}

/* ret nv */
| label? _TK_RET _TK_NV _TK_NEWLINE @{
  DO_stmt(0xE0); 
}

/* ret nz */
| label? _TK_RET _TK_NZ _TK_NEWLINE @{
  DO_stmt(0xC0); 
}

/* ret p */
| label? _TK_RET _TK_P _TK_NEWLINE @{
  DO_stmt(0xF0); 
}

/* ret pe */
| label? _TK_RET _TK_PE _TK_NEWLINE @{
  DO_stmt(0xE8); 
}

/* ret po */
| label? _TK_RET _TK_PO _TK_NEWLINE @{
  DO_stmt(0xE0); 
}

/* ret v */
| label? _TK_RET _TK_V _TK_NEWLINE @{
  DO_stmt(0xE8); 
}

/* ret z */
| label? _TK_RET _TK_Z _TK_NEWLINE @{
  DO_stmt(0xC8); 
}

/* rst 0 */
/* rst 16 */
/* rst 24 */
/* rst 32 */
/* rst 40 */
/* rst 48 */
/* rst 56 */
/* rst 8 */
| label? _TK_RST const_expr _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xC7); 
  }
  else if (expr_value == 8) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xCF); 
  }
  else if (expr_value == 16) {
    DO_stmt(0xD7); 
  }
  else if (expr_value == 24) {
    DO_stmt(0xDF); 
  }
  else if (expr_value == 32) {
    DO_stmt(0xE7); 
  }
  else if (expr_value == 40) {
    DO_stmt(0xEF); 
  }
  else if (expr_value == 48) {
    if ((opts.cpu & CPU_ZILOG) == 0) { error_illegal_ident(); return FALSE; }
    DO_stmt(0xF7); 
  }
  else if (expr_value == 56) {
    DO_stmt(0xFF); 
  }
  else
    error_int_range(expr_value);

}

/* tstio N */
| label? _TK_TSTIO expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED74); 
}

