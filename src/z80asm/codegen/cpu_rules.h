/* adc a */
| label? _TK_ADC _TK_A _TK_NEWLINE @{
  DO_stmt(0x8F); 
}

/* adc a,a */
| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x8F); 
}

/* adc a,b */
| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x88); 
}

/* adc a,c */
| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x89); 
}

/* adc a,d */
| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x8A); 
}

/* adc a,e */
| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x8B); 
}

/* adc a,h */
| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x8C); 
}

/* adc a,(hl) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x8E); 
}

/* adc a,(ix) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8E00); 
  }
  else {
    DO_stmt(0xFD8E00); 
  }
}

/* adc a,(ix+DIS) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD8E); 
  }
  else {
    DO_stmt_idx(0xFD8E); 
  }
}

/* adc a,(iy) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8E00); 
  }
  else {
    DO_stmt(0xDD8E00); 
  }
}

/* adc a,(iy+DIS) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD8E); 
  }
  else {
    DO_stmt_idx(0xDD8E); 
  }
}

/* adc a,ixh */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8C); 
  }
  else {
    DO_stmt(0xFD8C); 
  }
}

/* adc a,ixl */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8D); 
  }
  else {
    DO_stmt(0xFD8D); 
  }
}

/* adc a,iyh */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8C); 
  }
  else {
    DO_stmt(0xDD8C); 
  }
}

/* adc a,iyl */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8D); 
  }
  else {
    DO_stmt(0xDD8D); 
  }
}

/* adc a,l */
| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x8D); 
}

/* adc a,N */
| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xCE); 
}

/* adc a',a */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8F); 
}

/* adc a',b */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x88); 
}

/* adc a',c */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x89); 
}

/* adc a',d */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8A); 
}

/* adc a',e */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8B); 
}

/* adc a',h */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8C); 
}

/* adc a',(hl) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8E); 
}

/* adc a',(ix) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
}

/* adc a',(ix+DIS) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
}

/* adc a',(iy) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
}

/* adc a',(iy+DIS) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
}

/* adc a',l */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8D); 
}

/* adc a',N */
| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xCE); 
}

/* adc b */
| label? _TK_ADC _TK_B _TK_NEWLINE @{
  DO_stmt(0x88); 
}

/* adc c */
| label? _TK_ADC _TK_C _TK_NEWLINE @{
  DO_stmt(0x89); 
}

/* adc d */
| label? _TK_ADC _TK_D _TK_NEWLINE @{
  DO_stmt(0x8A); 
}

/* adc e */
| label? _TK_ADC _TK_E _TK_NEWLINE @{
  DO_stmt(0x8B); 
}

/* adc h */
| label? _TK_ADC _TK_H _TK_NEWLINE @{
  DO_stmt(0x8C); 
}

/* adc hl,bc */
| label? _TK_ADC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  DO_stmt(0xED4A); 
}

/* adc hl,de */
| label? _TK_ADC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  DO_stmt(0xED5A); 
}

/* adc hl,hl */
| label? _TK_ADC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  DO_stmt(0xED6A); 
}

/* adc hl,sp */
| label? _TK_ADC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  DO_stmt(0xED7A); 
}

/* adc hl',bc */
| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED4A); 
}

/* adc hl',de */
| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5A); 
}

/* adc hl',hl */
| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED6A); 
}

/* adc hl',sp */
| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED7A); 
}

/* adc (hl) */
| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x8E); 
}

/* adc (ix) */
| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8E00); 
  }
  else {
    DO_stmt(0xFD8E00); 
  }
}

/* adc (ix+DIS) */
| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD8E); 
  }
  else {
    DO_stmt_idx(0xFD8E); 
  }
}

/* adc (iy) */
| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8E00); 
  }
  else {
    DO_stmt(0xDD8E00); 
  }
}

/* adc (iy+DIS) */
| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD8E); 
  }
  else {
    DO_stmt_idx(0xDD8E); 
  }
}

/* adc ixh */
| label? _TK_ADC _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8C); 
  }
  else {
    DO_stmt(0xFD8C); 
  }
}

/* adc ixl */
| label? _TK_ADC _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8D); 
  }
  else {
    DO_stmt(0xFD8D); 
  }
}

/* adc iyh */
| label? _TK_ADC _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8C); 
  }
  else {
    DO_stmt(0xDD8C); 
  }
}

/* adc iyl */
| label? _TK_ADC _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8D); 
  }
  else {
    DO_stmt(0xDD8D); 
  }
}

/* adc l */
| label? _TK_ADC _TK_L _TK_NEWLINE @{
  DO_stmt(0x8D); 
}

/* adc N */
| label? _TK_ADC expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xCE); 
}

/* add a */
| label? _TK_ADD _TK_A _TK_NEWLINE @{
  DO_stmt(0x87); 
}

/* add a,a */
| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x87); 
}

/* add a,b */
| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x80); 
}

/* add a,c */
| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x81); 
}

/* add a,d */
| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x82); 
}

/* add a,e */
| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x83); 
}

/* add a,h */
| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x84); 
}

/* add a,(hl) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x86); 
}

/* add a,(ix) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8600); 
  }
  else {
    DO_stmt(0xFD8600); 
  }
}

/* add a,(ix+DIS) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD86); 
  }
  else {
    DO_stmt_idx(0xFD86); 
  }
}

/* add a,(iy) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8600); 
  }
  else {
    DO_stmt(0xDD8600); 
  }
}

/* add a,(iy+DIS) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD86); 
  }
  else {
    DO_stmt_idx(0xDD86); 
  }
}

/* add a,ixh */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD84); 
  }
  else {
    DO_stmt(0xFD84); 
  }
}

/* add a,ixl */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD85); 
  }
  else {
    DO_stmt(0xFD85); 
  }
}

/* add a,iyh */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD84); 
  }
  else {
    DO_stmt(0xDD84); 
  }
}

/* add a,iyl */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD85); 
  }
  else {
    DO_stmt(0xDD85); 
  }
}

/* add a,l */
| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x85); 
}

/* add a,N */
| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xC6); 
}

/* add a',a */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x87); 
}

/* add a',b */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x80); 
}

/* add a',c */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x81); 
}

/* add a',d */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x82); 
}

/* add a',e */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x83); 
}

/* add a',h */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x84); 
}

/* add a',(hl) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x86); 
}

/* add a',(ix) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
}

/* add a',(ix+DIS) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
}

/* add a',(iy) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
}

/* add a',(iy+DIS) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
}

/* add a',l */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x85); 
}

/* add a',N */
| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xC6); 
}

/* add b */
| label? _TK_ADD _TK_B _TK_NEWLINE @{
  DO_stmt(0x80); 
}

/* add c */
| label? _TK_ADD _TK_C _TK_NEWLINE @{
  DO_stmt(0x81); 
}

/* add d */
| label? _TK_ADD _TK_D _TK_NEWLINE @{
  DO_stmt(0x82); 
}

/* add e */
| label? _TK_ADD _TK_E _TK_NEWLINE @{
  DO_stmt(0x83); 
}

/* add h */
| label? _TK_ADD _TK_H _TK_NEWLINE @{
  DO_stmt(0x84); 
}

/* add hl,bc */
| label? _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  DO_stmt(0x09); 
}

/* add hl,de */
| label? _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  DO_stmt(0x19); 
}

/* add hl,hl */
| label? _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  DO_stmt(0x29); 
}

/* add hl,sp */
| label? _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  DO_stmt(0x39); 
}

/* add hl',bc */
| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x09); 
}

/* add hl',de */
| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x19); 
}

/* add hl',hl */
| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x29); 
}

/* add hl',sp */
| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x39); 
}

/* add (hl) */
| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x86); 
}

/* add (ix) */
| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD8600); 
  }
  else {
    DO_stmt(0xFD8600); 
  }
}

/* add (ix+DIS) */
| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD86); 
  }
  else {
    DO_stmt_idx(0xFD86); 
  }
}

/* add (iy) */
| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD8600); 
  }
  else {
    DO_stmt(0xDD8600); 
  }
}

/* add (iy+DIS) */
| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD86); 
  }
  else {
    DO_stmt_idx(0xDD86); 
  }
}

/* add ix,bc */
| label? _TK_ADD _TK_IX _TK_COMMA _TK_BC _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD09); 
  }
  else {
    DO_stmt(0xFD09); 
  }
}

/* add ix,de */
| label? _TK_ADD _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD19); 
  }
  else {
    DO_stmt(0xFD19); 
  }
}

/* add ix,ix */
| label? _TK_ADD _TK_IX _TK_COMMA _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD29); 
  }
  else {
    DO_stmt(0xFD29); 
  }
}

/* add ix,sp */
| label? _TK_ADD _TK_IX _TK_COMMA _TK_SP _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD39); 
  }
  else {
    DO_stmt(0xFD39); 
  }
}

/* add ixh */
| label? _TK_ADD _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD84); 
  }
  else {
    DO_stmt(0xFD84); 
  }
}

/* add ixl */
| label? _TK_ADD _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD85); 
  }
  else {
    DO_stmt(0xFD85); 
  }
}

/* add iy,bc */
| label? _TK_ADD _TK_IY _TK_COMMA _TK_BC _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD09); 
  }
  else {
    DO_stmt(0xDD09); 
  }
}

/* add iy,de */
| label? _TK_ADD _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD19); 
  }
  else {
    DO_stmt(0xDD19); 
  }
}

/* add iy,iy */
| label? _TK_ADD _TK_IY _TK_COMMA _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD29); 
  }
  else {
    DO_stmt(0xDD29); 
  }
}

/* add iy,sp */
| label? _TK_ADD _TK_IY _TK_COMMA _TK_SP _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD39); 
  }
  else {
    DO_stmt(0xDD39); 
  }
}

/* add iyh */
| label? _TK_ADD _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD84); 
  }
  else {
    DO_stmt(0xDD84); 
  }
}

/* add iyl */
| label? _TK_ADD _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD85); 
  }
  else {
    DO_stmt(0xDD85); 
  }
}

/* add l */
| label? _TK_ADD _TK_L _TK_NEWLINE @{
  DO_stmt(0x85); 
}

/* add sp,SN */
| label? _TK_ADD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt_d(0x27); 
}

/* add N */
| label? _TK_ADD expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xC6); 
}

/* altd adc a */
| label? _TK_ALTD _TK_ADC _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8F); 
}

/* altd adc a,a */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8F); 
}

/* altd adc a,b */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x88); 
}

/* altd adc a,c */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x89); 
}

/* altd adc a,d */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8A); 
}

/* altd adc a,e */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8B); 
}

/* altd adc a,h */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8C); 
}

/* altd adc a,(hl) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8E); 
}

/* altd adc a,(ix) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
}

/* altd adc a,(ix+DIS) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
}

/* altd adc a,(iy) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
}

/* altd adc a,(iy+DIS) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
}

/* altd adc a,l */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8D); 
}

/* altd adc a,N */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xCE); 
}

/* altd adc b */
| label? _TK_ALTD _TK_ADC _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x88); 
}

/* altd adc c */
| label? _TK_ALTD _TK_ADC _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x89); 
}

/* altd adc d */
| label? _TK_ALTD _TK_ADC _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8A); 
}

/* altd adc e */
| label? _TK_ALTD _TK_ADC _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8B); 
}

/* altd adc h */
| label? _TK_ALTD _TK_ADC _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8C); 
}

/* altd adc hl,bc */
| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED4A); 
}

/* altd adc hl,de */
| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5A); 
}

/* altd adc hl,hl */
| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED6A); 
}

/* altd adc hl,sp */
| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED7A); 
}

/* altd adc (hl) */
| label? _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8E); 
}

/* altd adc (ix) */
| label? _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
}

/* altd adc (ix+DIS) */
| label? _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
}

/* altd adc (iy) */
| label? _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8E00); 
  }
}

/* altd adc (iy+DIS) */
| label? _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD8E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD8E); 
  }
}

/* altd adc l */
| label? _TK_ALTD _TK_ADC _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x8D); 
}

/* altd adc N */
| label? _TK_ALTD _TK_ADC expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xCE); 
}

/* altd add a */
| label? _TK_ALTD _TK_ADD _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x87); 
}

/* altd add a,a */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x87); 
}

/* altd add a,b */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x80); 
}

/* altd add a,c */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x81); 
}

/* altd add a,d */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x82); 
}

/* altd add a,e */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x83); 
}

/* altd add a,h */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x84); 
}

/* altd add a,(hl) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x86); 
}

/* altd add a,(ix) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
}

/* altd add a,(ix+DIS) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
}

/* altd add a,(iy) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
}

/* altd add a,(iy+DIS) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
}

/* altd add a,l */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x85); 
}

/* altd add a,N */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xC6); 
}

/* altd add b */
| label? _TK_ALTD _TK_ADD _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x80); 
}

/* altd add c */
| label? _TK_ALTD _TK_ADD _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x81); 
}

/* altd add d */
| label? _TK_ALTD _TK_ADD _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x82); 
}

/* altd add e */
| label? _TK_ALTD _TK_ADD _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x83); 
}

/* altd add h */
| label? _TK_ALTD _TK_ADD _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x84); 
}

/* altd add hl,bc */
| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x09); 
}

/* altd add hl,de */
| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x19); 
}

/* altd add hl,hl */
| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x29); 
}

/* altd add hl,sp */
| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x39); 
}

/* altd add (hl) */
| label? _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x86); 
}

/* altd add (ix) */
| label? _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
}

/* altd add (ix+DIS) */
| label? _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
}

/* altd add (iy) */
| label? _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD8600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD8600); 
  }
}

/* altd add (iy+DIS) */
| label? _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD86); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD86); 
  }
}

/* altd add l */
| label? _TK_ALTD _TK_ADD _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x85); 
}

/* altd add N */
| label? _TK_ALTD _TK_ADD expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xC6); 
}

/* altd and a */
| label? _TK_ALTD _TK_AND _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA7); 
}

/* altd and a,a */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA7); 
}

/* altd and a,b */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA0); 
}

/* altd and a,c */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA1); 
}

/* altd and a,d */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA2); 
}

/* altd and a,e */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA3); 
}

/* altd and a,h */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA4); 
}

/* altd and a,(hl) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA6); 
}

/* altd and a,(ix) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
}

/* altd and a,(ix+DIS) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
}

/* altd and a,(iy) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
}

/* altd and a,(iy+DIS) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
}

/* altd and a,l */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA5); 
}

/* altd and a,N */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xE6); 
}

/* altd and b */
| label? _TK_ALTD _TK_AND _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA0); 
}

/* altd and c */
| label? _TK_ALTD _TK_AND _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA1); 
}

/* altd and d */
| label? _TK_ALTD _TK_AND _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA2); 
}

/* altd and e */
| label? _TK_ALTD _TK_AND _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA3); 
}

/* altd and h */
| label? _TK_ALTD _TK_AND _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA4); 
}

/* altd and hl,de */
| label? _TK_ALTD _TK_AND _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xDC); 
}

/* altd and (hl) */
| label? _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA6); 
}

/* altd and (ix) */
| label? _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
}

/* altd and (ix+DIS) */
| label? _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
}

/* altd and (iy) */
| label? _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
}

/* altd and (iy+DIS) */
| label? _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
}

/* altd and l */
| label? _TK_ALTD _TK_AND _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA5); 
}

/* altd and N */
| label? _TK_ALTD _TK_AND expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xE6); 
}

/* altd bool hl */
| label? _TK_ALTD _TK_BOOL _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xCC); 
}

/* altd ccf */
| label? _TK_ALTD _TK_CCF _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3F); 
}

/* altd ccf f */
| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3F); 
}

/* altd cp a */
| label? _TK_ALTD _TK_CP _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBF); 
}

/* altd cp a,a */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBF); 
}

/* altd cp a,b */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB8); 
}

/* altd cp a,c */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB9); 
}

/* altd cp a,d */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBA); 
}

/* altd cp a,e */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBB); 
}

/* altd cp a,h */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBC); 
}

/* altd cp a,(hl) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBE); 
}

/* altd cp a,(ix) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
}

/* altd cp a,(ix+DIS) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
}

/* altd cp a,(iy) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
}

/* altd cp a,(iy+DIS) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
}

/* altd cp a,l */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBD); 
}

/* altd cp a,N */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xFE); 
}

/* altd cp b */
| label? _TK_ALTD _TK_CP _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB8); 
}

/* altd cp c */
| label? _TK_ALTD _TK_CP _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB9); 
}

/* altd cp d */
| label? _TK_ALTD _TK_CP _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBA); 
}

/* altd cp e */
| label? _TK_ALTD _TK_CP _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBB); 
}

/* altd cp h */
| label? _TK_ALTD _TK_CP _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBC); 
}

/* altd cp (hl) */
| label? _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBE); 
}

/* altd cp (ix) */
| label? _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
}

/* altd cp (ix+DIS) */
| label? _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
}

/* altd cp (iy) */
| label? _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
}

/* altd cp (iy+DIS) */
| label? _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
}

/* altd cp l */
| label? _TK_ALTD _TK_CP _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBD); 
}

/* altd cp N */
| label? _TK_ALTD _TK_CP expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xFE); 
}

/* altd cpl */
| label? _TK_ALTD _TK_CPL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2F); 
}

/* altd cpl a */
| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2F); 
}

/* altd dec a */
| label? _TK_ALTD _TK_DEC _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3D); 
}

/* altd dec b */
| label? _TK_ALTD _TK_DEC _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x05); 
}

/* altd dec bc */
| label? _TK_ALTD _TK_DEC _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0B); 
}

/* altd dec c */
| label? _TK_ALTD _TK_DEC _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0D); 
}

/* altd dec d */
| label? _TK_ALTD _TK_DEC _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x15); 
}

/* altd dec de */
| label? _TK_ALTD _TK_DEC _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1B); 
}

/* altd dec e */
| label? _TK_ALTD _TK_DEC _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1D); 
}

/* altd dec h */
| label? _TK_ALTD _TK_DEC _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x25); 
}

/* altd dec hl */
| label? _TK_ALTD _TK_DEC _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2B); 
}

/* altd dec l */
| label? _TK_ALTD _TK_DEC _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2D); 
}

/* altd djnz NN */
| label? _TK_ALTD _TK_DJNZ expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_jr(0x10); 
}

/* altd ex de,hl */
| label? _TK_ALTD _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xEB); 
}

/* altd ex de',hl */
| label? _TK_ALTD _TK_EX _TK_DE1 _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xE3); 
}

/* altd ex (sp),hl */
| label? _TK_ALTD _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED54); 
}

/* altd inc a */
| label? _TK_ALTD _TK_INC _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3C); 
}

/* altd inc b */
| label? _TK_ALTD _TK_INC _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x04); 
}

/* altd inc bc */
| label? _TK_ALTD _TK_INC _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x03); 
}

/* altd inc c */
| label? _TK_ALTD _TK_INC _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0C); 
}

/* altd inc d */
| label? _TK_ALTD _TK_INC _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x14); 
}

/* altd inc de */
| label? _TK_ALTD _TK_INC _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x13); 
}

/* altd inc e */
| label? _TK_ALTD _TK_INC _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1C); 
}

/* altd inc h */
| label? _TK_ALTD _TK_INC _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x24); 
}

/* altd inc hl */
| label? _TK_ALTD _TK_INC _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x23); 
}

/* altd inc l */
| label? _TK_ALTD _TK_INC _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2C); 
}

/* altd ld a,a */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7F); 
}

/* altd ld a,b */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x78); 
}

/* altd ld a,c */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x79); 
}

/* altd ld a,d */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7A); 
}

/* altd ld a,e */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7B); 
}

/* altd ld a,eir */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED57); 
}

/* altd ld a,h */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7C); 
}

/* altd ld a,iir */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5F); 
}

/* altd ld a,(bc) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0A); 
}

/* altd ld a,(de) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1A); 
}

/* altd ld a,(hl) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7E); 
}

/* altd ld a,(ix) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD7E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD7E00); 
  }
}

/* altd ld a,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD7E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD7E); 
  }
}

/* altd ld a,(iy) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD7E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD7E00); 
  }
}

/* altd ld a,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD7E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD7E); 
  }
}

/* altd ld a,l */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7D); 
}

/* altd ld a,xpc */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* altd ld a,(NN) */
/* altd ld a,N */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0x3A); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_n(0x3E); 
  }
}

/* altd ld b,a */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x47); 
}

/* altd ld b,b */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x40); 
}

/* altd ld b,c */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x41); 
}

/* altd ld b,d */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x42); 
}

/* altd ld b,e */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x43); 
}

/* altd ld b,h */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x44); 
}

/* altd ld b,(hl) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x46); 
}

/* altd ld b,(ix) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD4600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD4600); 
  }
}

/* altd ld b,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD46); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD46); 
  }
}

/* altd ld b,(iy) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD4600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD4600); 
  }
}

/* altd ld b,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD46); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD46); 
  }
}

/* altd ld b,l */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x45); 
}

/* altd ld b,N */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x06); 
}

/* altd ld bc,(NN) */
/* altd ld bc,NN */
| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0xED4B); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x01); 
  }
}

/* altd ld c,a */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4F); 
}

/* altd ld c,b */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x48); 
}

/* altd ld c,c */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x49); 
}

/* altd ld c,d */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4A); 
}

/* altd ld c,e */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4B); 
}

/* altd ld c,h */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4C); 
}

/* altd ld c,(hl) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4E); 
}

/* altd ld c,(ix) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD4E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD4E00); 
  }
}

/* altd ld c,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD4E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD4E); 
  }
}

/* altd ld c,(iy) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD4E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD4E00); 
  }
}

/* altd ld c,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD4E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD4E); 
  }
}

/* altd ld c,l */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4D); 
}

/* altd ld c,N */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x0E); 
}

/* altd ld d,a */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x57); 
}

/* altd ld d,b */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x50); 
}

/* altd ld d,c */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x51); 
}

/* altd ld d,d */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x52); 
}

/* altd ld d,e */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x53); 
}

/* altd ld d,h */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x54); 
}

/* altd ld d,(hl) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x56); 
}

/* altd ld d,(ix) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD5600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD5600); 
  }
}

/* altd ld d,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD56); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD56); 
  }
}

/* altd ld d,(iy) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD5600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD5600); 
  }
}

/* altd ld d,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD56); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD56); 
  }
}

/* altd ld d,l */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x55); 
}

/* altd ld d,N */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x16); 
}

/* altd ld de,(NN) */
/* altd ld de,NN */
| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0xED5B); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x11); 
  }
}

/* altd ld e,a */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5F); 
}

/* altd ld e,b */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x58); 
}

/* altd ld e,c */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x59); 
}

/* altd ld e,d */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5A); 
}

/* altd ld e,e */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5B); 
}

/* altd ld e,h */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5C); 
}

/* altd ld e,(hl) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5E); 
}

/* altd ld e,(ix) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD5E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD5E00); 
  }
}

/* altd ld e,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD5E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD5E); 
  }
}

/* altd ld e,(iy) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD5E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD5E00); 
  }
}

/* altd ld e,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD5E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD5E); 
  }
}

/* altd ld e,l */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5D); 
}

/* altd ld e,N */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x1E); 
}

/* altd ld h,a */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x67); 
}

/* altd ld h,b */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x60); 
}

/* altd ld h,c */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x61); 
}

/* altd ld h,d */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x62); 
}

/* altd ld h,e */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x63); 
}

/* altd ld h,h */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x64); 
}

/* altd ld h,(hl) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x66); 
}

/* altd ld h,(ix) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD6600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD6600); 
  }
}

/* altd ld h,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD66); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD66); 
  }
}

/* altd ld h,(iy) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD6600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD6600); 
  }
}

/* altd ld h,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD66); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD66); 
  }
}

/* altd ld h,l */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x65); 
}

/* altd ld h,N */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x26); 
}

/* altd ld hl,(hl) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xDDE400); 
}

/* altd ld hl,(hl+DIS) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt_idx(0xDDE4); 
}

/* altd ld hl,(ix) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xE400); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDE400); 
  }
}

/* altd ld hl,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xE4); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDE4); 
  }
}

/* altd ld hl,(iy) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDE400); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xE400); 
  }
}

/* altd ld hl,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDE4); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xE4); 
  }
}

/* altd ld hl,(sp) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xC400); 
}

/* altd ld hl,(sp+N) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xC4); 
}

/* altd ld hl,ix */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD7C); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD7C); 
  }
}

/* altd ld hl,iy */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD7C); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD7C); 
  }
}

/* altd ld hl,(NN) */
/* altd ld hl,NN */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0x2A); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x21); 
  }
}

/* altd ld l,a */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6F); 
}

/* altd ld l,b */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x68); 
}

/* altd ld l,c */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x69); 
}

/* altd ld l,d */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6A); 
}

/* altd ld l,e */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6B); 
}

/* altd ld l,h */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6C); 
}

/* altd ld l,(hl) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6E); 
}

/* altd ld l,(ix) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD6E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD6E00); 
  }
}

/* altd ld l,(ix+DIS) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD6E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD6E); 
  }
}

/* altd ld l,(iy) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD6E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD6E00); 
  }
}

/* altd ld l,(iy+DIS) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD6E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD6E); 
  }
}

/* altd ld l,l */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6D); 
}

/* altd ld l,N */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x2E); 
}

/* altd neg */
| label? _TK_ALTD _TK_NEG _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED44); 
}

/* altd neg a */
| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED44); 
}

/* altd or a */
| label? _TK_ALTD _TK_OR _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB7); 
}

/* altd or a,a */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB7); 
}

/* altd or a,b */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB0); 
}

/* altd or a,c */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB1); 
}

/* altd or a,d */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB2); 
}

/* altd or a,e */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB3); 
}

/* altd or a,h */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB4); 
}

/* altd or a,(hl) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB6); 
}

/* altd or a,(ix) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
}

/* altd or a,(ix+DIS) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
}

/* altd or a,(iy) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
}

/* altd or a,(iy+DIS) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
}

/* altd or a,l */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB5); 
}

/* altd or a,N */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xF6); 
}

/* altd or b */
| label? _TK_ALTD _TK_OR _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB0); 
}

/* altd or c */
| label? _TK_ALTD _TK_OR _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB1); 
}

/* altd or d */
| label? _TK_ALTD _TK_OR _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB2); 
}

/* altd or e */
| label? _TK_ALTD _TK_OR _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB3); 
}

/* altd or h */
| label? _TK_ALTD _TK_OR _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB4); 
}

/* altd or hl,de */
| label? _TK_ALTD _TK_OR _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xEC); 
}

/* altd or (hl) */
| label? _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB6); 
}

/* altd or (ix) */
| label? _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
}

/* altd or (ix+DIS) */
| label? _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
}

/* altd or (iy) */
| label? _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
}

/* altd or (iy+DIS) */
| label? _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
}

/* altd or l */
| label? _TK_ALTD _TK_OR _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB5); 
}

/* altd or N */
| label? _TK_ALTD _TK_OR expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xF6); 
}

/* altd pop af */
| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF1); 
}

/* altd pop bc */
| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xC1); 
}

/* altd pop de */
| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xD1); 
}

/* altd pop hl */
| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xE1); 
}

/* altd res 0,a */
/* altd res 1,a */
/* altd res 2,a */
/* altd res 3,a */
/* altd res 4,a */
/* altd res 5,a */
/* altd res 6,a */
/* altd res 7,a */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,b */
/* altd res 1,b */
/* altd res 2,b */
/* altd res 3,b */
/* altd res 4,b */
/* altd res 5,b */
/* altd res 6,b */
/* altd res 7,b */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,c */
/* altd res 1,c */
/* altd res 2,c */
/* altd res 3,c */
/* altd res 4,c */
/* altd res 5,c */
/* altd res 6,c */
/* altd res 7,c */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,d */
/* altd res 1,d */
/* altd res 2,d */
/* altd res 3,d */
/* altd res 4,d */
/* altd res 5,d */
/* altd res 6,d */
/* altd res 7,d */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,e */
/* altd res 1,e */
/* altd res 2,e */
/* altd res 3,e */
/* altd res 4,e */
/* altd res 5,e */
/* altd res 6,e */
/* altd res 7,e */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,h */
/* altd res 1,h */
/* altd res 2,h */
/* altd res 3,h */
/* altd res 4,h */
/* altd res 5,h */
/* altd res 6,h */
/* altd res 7,h */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* altd res 0,l */
/* altd res 1,l */
/* altd res 2,l */
/* altd res 3,l */
/* altd res 4,l */
/* altd res 5,l */
/* altd res 6,l */
/* altd res 7,l */
| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

}

/* altd rl de */
| label? _TK_ALTD _TK_RL _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF3); 
}

/* altd rr de */
| label? _TK_ALTD _TK_RR _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFB); 
}

/* altd rr hl */
| label? _TK_ALTD _TK_RR _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFC); 
}

/* altd sbc a */
| label? _TK_ALTD _TK_SBC _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9F); 
}

/* altd sbc a,a */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9F); 
}

/* altd sbc a,b */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x98); 
}

/* altd sbc a,c */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x99); 
}

/* altd sbc a,d */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9A); 
}

/* altd sbc a,e */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9B); 
}

/* altd sbc a,h */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9C); 
}

/* altd sbc a,(hl) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9E); 
}

/* altd sbc a,(ix) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
}

/* altd sbc a,(ix+DIS) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
}

/* altd sbc a,(iy) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
}

/* altd sbc a,(iy+DIS) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
}

/* altd sbc a,l */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9D); 
}

/* altd sbc a,N */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xDE); 
}

/* altd sbc b */
| label? _TK_ALTD _TK_SBC _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x98); 
}

/* altd sbc c */
| label? _TK_ALTD _TK_SBC _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x99); 
}

/* altd sbc d */
| label? _TK_ALTD _TK_SBC _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9A); 
}

/* altd sbc e */
| label? _TK_ALTD _TK_SBC _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9B); 
}

/* altd sbc h */
| label? _TK_ALTD _TK_SBC _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9C); 
}

/* altd sbc hl,bc */
| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED42); 
}

/* altd sbc hl,de */
| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED52); 
}

/* altd sbc hl,hl */
| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED62); 
}

/* altd sbc hl,sp */
| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED72); 
}

/* altd sbc (hl) */
| label? _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9E); 
}

/* altd sbc (ix) */
| label? _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
}

/* altd sbc (ix+DIS) */
| label? _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
}

/* altd sbc (iy) */
| label? _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
}

/* altd sbc (iy+DIS) */
| label? _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
}

/* altd sbc l */
| label? _TK_ALTD _TK_SBC _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9D); 
}

/* altd sbc N */
| label? _TK_ALTD _TK_SBC expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xDE); 
}

/* altd scf */
| label? _TK_ALTD _TK_SCF _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x37); 
}

/* altd scf f */
| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x37); 
}

/* altd set 0,a */
/* altd set 1,a */
/* altd set 2,a */
/* altd set 3,a */
/* altd set 4,a */
/* altd set 5,a */
/* altd set 6,a */
/* altd set 7,a */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,b */
/* altd set 1,b */
/* altd set 2,b */
/* altd set 3,b */
/* altd set 4,b */
/* altd set 5,b */
/* altd set 6,b */
/* altd set 7,b */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,c */
/* altd set 1,c */
/* altd set 2,c */
/* altd set 3,c */
/* altd set 4,c */
/* altd set 5,c */
/* altd set 6,c */
/* altd set 7,c */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,d */
/* altd set 1,d */
/* altd set 2,d */
/* altd set 3,d */
/* altd set 4,d */
/* altd set 5,d */
/* altd set 6,d */
/* altd set 7,d */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,e */
/* altd set 1,e */
/* altd set 2,e */
/* altd set 3,e */
/* altd set 4,e */
/* altd set 5,e */
/* altd set 6,e */
/* altd set 7,e */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,h */
/* altd set 1,h */
/* altd set 2,h */
/* altd set 3,h */
/* altd set 4,h */
/* altd set 5,h */
/* altd set 6,h */
/* altd set 7,h */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* altd set 0,l */
/* altd set 1,l */
/* altd set 2,l */
/* altd set 3,l */
/* altd set 4,l */
/* altd set 5,l */
/* altd set 6,l */
/* altd set 7,l */
| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* altd sub a */
| label? _TK_ALTD _TK_SUB _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x97); 
}

/* altd sub a,a */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x97); 
}

/* altd sub a,b */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x90); 
}

/* altd sub a,c */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x91); 
}

/* altd sub a,d */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x92); 
}

/* altd sub a,e */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x93); 
}

/* altd sub a,h */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x94); 
}

/* altd sub a,(hl) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x96); 
}

/* altd sub a,(ix) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
}

/* altd sub a,(ix+DIS) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
}

/* altd sub a,(iy) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
}

/* altd sub a,(iy+DIS) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
}

/* altd sub a,l */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x95); 
}

/* altd sub a,N */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xD6); 
}

/* altd sub b */
| label? _TK_ALTD _TK_SUB _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x90); 
}

/* altd sub c */
| label? _TK_ALTD _TK_SUB _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x91); 
}

/* altd sub d */
| label? _TK_ALTD _TK_SUB _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x92); 
}

/* altd sub e */
| label? _TK_ALTD _TK_SUB _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x93); 
}

/* altd sub h */
| label? _TK_ALTD _TK_SUB _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x94); 
}

/* altd sub (hl) */
| label? _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x96); 
}

/* altd sub (ix) */
| label? _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
}

/* altd sub (ix+DIS) */
| label? _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
}

/* altd sub (iy) */
| label? _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
}

/* altd sub (iy+DIS) */
| label? _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
}

/* altd sub l */
| label? _TK_ALTD _TK_SUB _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x95); 
}

/* altd sub N */
| label? _TK_ALTD _TK_SUB expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xD6); 
}

/* altd xor a */
| label? _TK_ALTD _TK_XOR _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAF); 
}

/* altd xor a,a */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAF); 
}

/* altd xor a,b */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA8); 
}

/* altd xor a,c */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA9); 
}

/* altd xor a,d */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAA); 
}

/* altd xor a,e */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAB); 
}

/* altd xor a,h */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAC); 
}

/* altd xor a,(hl) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAE); 
}

/* altd xor a,(ix) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
}

/* altd xor a,(ix+DIS) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
}

/* altd xor a,(iy) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
}

/* altd xor a,(iy+DIS) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
}

/* altd xor a,l */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAD); 
}

/* altd xor a,N */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xEE); 
}

/* altd xor b */
| label? _TK_ALTD _TK_XOR _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA8); 
}

/* altd xor c */
| label? _TK_ALTD _TK_XOR _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA9); 
}

/* altd xor d */
| label? _TK_ALTD _TK_XOR _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAA); 
}

/* altd xor e */
| label? _TK_ALTD _TK_XOR _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAB); 
}

/* altd xor h */
| label? _TK_ALTD _TK_XOR _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAC); 
}

/* altd xor (hl) */
| label? _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAE); 
}

/* altd xor (ix) */
| label? _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
}

/* altd xor (ix+DIS) */
| label? _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
}

/* altd xor (iy) */
| label? _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
}

/* altd xor (iy+DIS) */
| label? _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
}

/* altd xor l */
| label? _TK_ALTD _TK_XOR _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAD); 
}

/* altd xor N */
| label? _TK_ALTD _TK_XOR expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xEE); 
}

/* and a */
| label? _TK_AND _TK_A _TK_NEWLINE @{
  DO_stmt(0xA7); 
}

/* and a,a */
| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0xA7); 
}

/* and a,b */
| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0xA0); 
}

/* and a,c */
| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0xA1); 
}

/* and a,d */
| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0xA2); 
}

/* and a,e */
| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0xA3); 
}

/* and a,h */
| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0xA4); 
}

/* and a,(hl) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xA6); 
}

/* and a,(ix) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA600); 
  }
  else {
    DO_stmt(0xFDA600); 
  }
}

/* and a,(ix+DIS) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDA6); 
  }
  else {
    DO_stmt_idx(0xFDA6); 
  }
}

/* and a,(iy) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA600); 
  }
  else {
    DO_stmt(0xDDA600); 
  }
}

/* and a,(iy+DIS) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDA6); 
  }
  else {
    DO_stmt_idx(0xDDA6); 
  }
}

/* and a,ixh */
| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA4); 
  }
  else {
    DO_stmt(0xFDA4); 
  }
}

/* and a,ixl */
| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA5); 
  }
  else {
    DO_stmt(0xFDA5); 
  }
}

/* and a,iyh */
| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA4); 
  }
  else {
    DO_stmt(0xDDA4); 
  }
}

/* and a,iyl */
| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA5); 
  }
  else {
    DO_stmt(0xDDA5); 
  }
}

/* and a,l */
| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0xA5); 
}

/* and a,N */
| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xE6); 
}

/* and a',a */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA7); 
}

/* and a',b */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA0); 
}

/* and a',c */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA1); 
}

/* and a',d */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA2); 
}

/* and a',e */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA3); 
}

/* and a',h */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA4); 
}

/* and a',(hl) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA6); 
}

/* and a',(ix) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
}

/* and a',(ix+DIS) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
}

/* and a',(iy) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDA600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDA600); 
  }
}

/* and a',(iy+DIS) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDA6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDA6); 
  }
}

/* and a',l */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA5); 
}

/* and a',N */
| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xE6); 
}

/* and b */
| label? _TK_AND _TK_B _TK_NEWLINE @{
  DO_stmt(0xA0); 
}

/* and c */
| label? _TK_AND _TK_C _TK_NEWLINE @{
  DO_stmt(0xA1); 
}

/* and d */
| label? _TK_AND _TK_D _TK_NEWLINE @{
  DO_stmt(0xA2); 
}

/* and e */
| label? _TK_AND _TK_E _TK_NEWLINE @{
  DO_stmt(0xA3); 
}

/* and h */
| label? _TK_AND _TK_H _TK_NEWLINE @{
  DO_stmt(0xA4); 
}

/* and hl,de */
| label? _TK_AND _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDC); 
}

/* and hl',de */
| label? _TK_AND _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xDC); 
}

/* and (hl) */
| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xA6); 
}

/* and (ix) */
| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA600); 
  }
  else {
    DO_stmt(0xFDA600); 
  }
}

/* and (ix+DIS) */
| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDA6); 
  }
  else {
    DO_stmt_idx(0xFDA6); 
  }
}

/* and (iy) */
| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA600); 
  }
  else {
    DO_stmt(0xDDA600); 
  }
}

/* and (iy+DIS) */
| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDA6); 
  }
  else {
    DO_stmt_idx(0xDDA6); 
  }
}

/* and ix,de */
| label? _TK_AND _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDDC); 
  }
  else {
    DO_stmt(0xFDDC); 
  }
}

/* and ixh */
| label? _TK_AND _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA4); 
  }
  else {
    DO_stmt(0xFDA4); 
  }
}

/* and ixl */
| label? _TK_AND _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDA5); 
  }
  else {
    DO_stmt(0xFDA5); 
  }
}

/* and iy,de */
| label? _TK_AND _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDDC); 
  }
  else {
    DO_stmt(0xDDDC); 
  }
}

/* and iyh */
| label? _TK_AND _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA4); 
  }
  else {
    DO_stmt(0xDDA4); 
  }
}

/* and iyl */
| label? _TK_AND _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDA5); 
  }
  else {
    DO_stmt(0xDDA5); 
  }
}

/* and l */
| label? _TK_AND _TK_L _TK_NEWLINE @{
  DO_stmt(0xA5); 
}

/* and N */
| label? _TK_AND expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xE6); 
}

/* bit 0,a */
/* bit 1,a */
/* bit 2,a */
/* bit 3,a */
/* bit 4,a */
/* bit 5,a */
/* bit 6,a */
/* bit 7,a */
| label? _TK_BIT const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB47); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB57); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB67); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6F); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB77); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7F); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,b */
/* bit 1,b */
/* bit 2,b */
/* bit 3,b */
/* bit 4,b */
/* bit 5,b */
/* bit 6,b */
/* bit 7,b */
| label? _TK_BIT const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB40); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB48); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB50); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB58); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB60); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB68); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB70); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB78); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,c */
/* bit 1,c */
/* bit 2,c */
/* bit 3,c */
/* bit 4,c */
/* bit 5,c */
/* bit 6,c */
/* bit 7,c */
| label? _TK_BIT const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB41); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB49); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB51); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB59); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB61); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB69); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB71); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB79); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,d */
/* bit 1,d */
/* bit 2,d */
/* bit 3,d */
/* bit 4,d */
/* bit 5,d */
/* bit 6,d */
/* bit 7,d */
| label? _TK_BIT const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB42); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB52); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB62); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6A); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB72); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7A); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,e */
/* bit 1,e */
/* bit 2,e */
/* bit 3,e */
/* bit 4,e */
/* bit 5,e */
/* bit 6,e */
/* bit 7,e */
| label? _TK_BIT const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB43); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB53); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB63); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6B); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB73); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7B); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,h */
/* bit 1,h */
/* bit 2,h */
/* bit 3,h */
/* bit 4,h */
/* bit 5,h */
/* bit 6,h */
/* bit 7,h */
| label? _TK_BIT const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB44); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB54); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB64); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6C); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB74); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7C); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(hl) */
/* bit 1,(hl) */
/* bit 2,(hl) */
/* bit 3,(hl) */
/* bit 4,(hl) */
/* bit 5,(hl) */
/* bit 6,(hl) */
/* bit 7,(hl) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4E); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB56); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5E); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB66); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6E); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB76); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7E); 
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(ix) */
/* bit 1,(ix) */
/* bit 2,(ix) */
/* bit 3,(ix) */
/* bit 4,(ix) */
/* bit 5,(ix) */
/* bit 6,(ix) */
/* bit 7,(ix) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0046); 
  }
  else {
    DO_stmt(0xFDCB0046); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB004E); 
  }
  else {
    DO_stmt(0xFDCB004E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0056); 
  }
  else {
    DO_stmt(0xFDCB0056); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB005E); 
  }
  else {
    DO_stmt(0xFDCB005E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0066); 
  }
  else {
    DO_stmt(0xFDCB0066); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB006E); 
  }
  else {
    DO_stmt(0xFDCB006E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0076); 
  }
  else {
    DO_stmt(0xFDCB0076); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB007E); 
  }
  else {
    DO_stmt(0xFDCB007E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(ix+DIS) */
/* bit 1,(ix+DIS) */
/* bit 2,(ix+DIS) */
/* bit 3,(ix+DIS) */
/* bit 4,(ix+DIS) */
/* bit 5,(ix+DIS) */
/* bit 6,(ix+DIS) */
/* bit 7,(ix+DIS) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB46); 
  }
  else {
    DO_stmt_idx(0xFDCB46); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB4E); 
  }
  else {
    DO_stmt_idx(0xFDCB4E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB56); 
  }
  else {
    DO_stmt_idx(0xFDCB56); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB5E); 
  }
  else {
    DO_stmt_idx(0xFDCB5E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB66); 
  }
  else {
    DO_stmt_idx(0xFDCB66); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB6E); 
  }
  else {
    DO_stmt_idx(0xFDCB6E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB76); 
  }
  else {
    DO_stmt_idx(0xFDCB76); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB7E); 
  }
  else {
    DO_stmt_idx(0xFDCB7E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(iy) */
/* bit 1,(iy) */
/* bit 2,(iy) */
/* bit 3,(iy) */
/* bit 4,(iy) */
/* bit 5,(iy) */
/* bit 6,(iy) */
/* bit 7,(iy) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0046); 
  }
  else {
    DO_stmt(0xDDCB0046); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB004E); 
  }
  else {
    DO_stmt(0xDDCB004E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0056); 
  }
  else {
    DO_stmt(0xDDCB0056); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB005E); 
  }
  else {
    DO_stmt(0xDDCB005E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0066); 
  }
  else {
    DO_stmt(0xDDCB0066); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB006E); 
  }
  else {
    DO_stmt(0xDDCB006E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0076); 
  }
  else {
    DO_stmt(0xDDCB0076); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB007E); 
  }
  else {
    DO_stmt(0xDDCB007E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,(iy+DIS) */
/* bit 1,(iy+DIS) */
/* bit 2,(iy+DIS) */
/* bit 3,(iy+DIS) */
/* bit 4,(iy+DIS) */
/* bit 5,(iy+DIS) */
/* bit 6,(iy+DIS) */
/* bit 7,(iy+DIS) */
| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB46); 
  }
  else {
    DO_stmt_idx(0xDDCB46); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB4E); 
  }
  else {
    DO_stmt_idx(0xDDCB4E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB56); 
  }
  else {
    DO_stmt_idx(0xDDCB56); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB5E); 
  }
  else {
    DO_stmt_idx(0xDDCB5E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB66); 
  }
  else {
    DO_stmt_idx(0xDDCB66); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB6E); 
  }
  else {
    DO_stmt_idx(0xDDCB6E); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB76); 
  }
  else {
    DO_stmt_idx(0xDDCB76); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB7E); 
  }
  else {
    DO_stmt_idx(0xDDCB7E); 
  }
  }
  else
    error_int_range(expr_value);

}

/* bit 0,l */
/* bit 1,l */
/* bit 2,l */
/* bit 3,l */
/* bit 4,l */
/* bit 5,l */
/* bit 6,l */
/* bit 7,l */
| label? _TK_BIT const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB45); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB4D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB55); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB5D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCB65); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCB6D); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCB75); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCB7D); 
  }
  else
    error_int_range(expr_value);

}

/* bool hl */
| label? _TK_BOOL _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCC); 
}

/* bool hl' */
| label? _TK_BOOL _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xCC); 
}

/* bool ix */
| label? _TK_BOOL _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCC); 
  }
  else {
    DO_stmt(0xFDCC); 
  }
}

/* bool iy */
| label? _TK_BOOL _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCC); 
  }
  else {
    DO_stmt(0xDDCC); 
  }
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

/* ccf */
| label? _TK_CCF _TK_NEWLINE @{
  DO_stmt(0x3F); 
}

/* ccf f */
| label? _TK_CCF _TK_F _TK_NEWLINE @{
  DO_stmt(0x3F); 
}

/* ccf f' */
| label? _TK_CCF _TK_F1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3F); 
}

/* cp a */
| label? _TK_CP _TK_A _TK_NEWLINE @{
  DO_stmt(0xBF); 
}

/* cp a,a */
| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0xBF); 
}

/* cp a,b */
| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0xB8); 
}

/* cp a,c */
| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0xB9); 
}

/* cp a,d */
| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0xBA); 
}

/* cp a,e */
| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0xBB); 
}

/* cp a,h */
| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0xBC); 
}

/* cp a,(hl) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xBE); 
}

/* cp a,(ix) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBE00); 
  }
  else {
    DO_stmt(0xFDBE00); 
  }
}

/* cp a,(ix+DIS) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDBE); 
  }
  else {
    DO_stmt_idx(0xFDBE); 
  }
}

/* cp a,(iy) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBE00); 
  }
  else {
    DO_stmt(0xDDBE00); 
  }
}

/* cp a,(iy+DIS) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDBE); 
  }
  else {
    DO_stmt_idx(0xDDBE); 
  }
}

/* cp a,ixh */
| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBC); 
  }
  else {
    DO_stmt(0xFDBC); 
  }
}

/* cp a,ixl */
| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBD); 
  }
  else {
    DO_stmt(0xFDBD); 
  }
}

/* cp a,iyh */
| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBC); 
  }
  else {
    DO_stmt(0xDDBC); 
  }
}

/* cp a,iyl */
| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBD); 
  }
  else {
    DO_stmt(0xDDBD); 
  }
}

/* cp a,l */
| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0xBD); 
}

/* cp a,N */
| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xFE); 
}

/* cp a',a */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBF); 
}

/* cp a',b */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB8); 
}

/* cp a',c */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB9); 
}

/* cp a',d */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBA); 
}

/* cp a',e */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBB); 
}

/* cp a',h */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBC); 
}

/* cp a',(hl) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBE); 
}

/* cp a',(ix) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
}

/* cp a',(ix+DIS) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
}

/* cp a',(iy) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDBE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDBE00); 
  }
}

/* cp a',(iy+DIS) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDBE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDBE); 
  }
}

/* cp a',l */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xBD); 
}

/* cp a',N */
| label? _TK_CP _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xFE); 
}

/* cp b */
| label? _TK_CP _TK_B _TK_NEWLINE @{
  DO_stmt(0xB8); 
}

/* cp c */
| label? _TK_CP _TK_C _TK_NEWLINE @{
  DO_stmt(0xB9); 
}

/* cp d */
| label? _TK_CP _TK_D _TK_NEWLINE @{
  DO_stmt(0xBA); 
}

/* cp e */
| label? _TK_CP _TK_E _TK_NEWLINE @{
  DO_stmt(0xBB); 
}

/* cp h */
| label? _TK_CP _TK_H _TK_NEWLINE @{
  DO_stmt(0xBC); 
}

/* cp (hl) */
| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xBE); 
}

/* cp (ix) */
| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBE00); 
  }
  else {
    DO_stmt(0xFDBE00); 
  }
}

/* cp (ix+DIS) */
| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDBE); 
  }
  else {
    DO_stmt_idx(0xFDBE); 
  }
}

/* cp (iy) */
| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBE00); 
  }
  else {
    DO_stmt(0xDDBE00); 
  }
}

/* cp (iy+DIS) */
| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDBE); 
  }
  else {
    DO_stmt_idx(0xDDBE); 
  }
}

/* cp ixh */
| label? _TK_CP _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBC); 
  }
  else {
    DO_stmt(0xFDBC); 
  }
}

/* cp ixl */
| label? _TK_CP _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDBD); 
  }
  else {
    DO_stmt(0xFDBD); 
  }
}

/* cp iyh */
| label? _TK_CP _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBC); 
  }
  else {
    DO_stmt(0xDDBC); 
  }
}

/* cp iyl */
| label? _TK_CP _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDBD); 
  }
  else {
    DO_stmt(0xDDBD); 
  }
}

/* cp l */
| label? _TK_CP _TK_L _TK_NEWLINE @{
  DO_stmt(0xBD); 
}

/* cp N */
| label? _TK_CP expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xFE); 
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

/* cpl */
| label? _TK_CPL _TK_NEWLINE @{
  DO_stmt(0x2F); 
}

/* cpl a */
| label? _TK_CPL _TK_A _TK_NEWLINE @{
  DO_stmt(0x2F); 
}

/* cpl a' */
| label? _TK_CPL _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2F); 
}

/* daa */
| label? _TK_DAA _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x27); 
}

/* dec a */
| label? _TK_DEC _TK_A _TK_NEWLINE @{
  DO_stmt(0x3D); 
}

/* dec a' */
| label? _TK_DEC _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3D); 
}

/* dec b */
| label? _TK_DEC _TK_B _TK_NEWLINE @{
  DO_stmt(0x05); 
}

/* dec b' */
| label? _TK_DEC _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x05); 
}

/* dec bc */
| label? _TK_DEC _TK_BC _TK_NEWLINE @{
  DO_stmt(0x0B); 
}

/* dec bc' */
| label? _TK_DEC _TK_BC1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0B); 
}

/* dec c */
| label? _TK_DEC _TK_C _TK_NEWLINE @{
  DO_stmt(0x0D); 
}

/* dec c' */
| label? _TK_DEC _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0D); 
}

/* dec d */
| label? _TK_DEC _TK_D _TK_NEWLINE @{
  DO_stmt(0x15); 
}

/* dec d' */
| label? _TK_DEC _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x15); 
}

/* dec de */
| label? _TK_DEC _TK_DE _TK_NEWLINE @{
  DO_stmt(0x1B); 
}

/* dec de' */
| label? _TK_DEC _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1B); 
}

/* dec e */
| label? _TK_DEC _TK_E _TK_NEWLINE @{
  DO_stmt(0x1D); 
}

/* dec e' */
| label? _TK_DEC _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1D); 
}

/* dec h */
| label? _TK_DEC _TK_H _TK_NEWLINE @{
  DO_stmt(0x25); 
}

/* dec h' */
| label? _TK_DEC _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x25); 
}

/* dec hl */
| label? _TK_DEC _TK_HL _TK_NEWLINE @{
  DO_stmt(0x2B); 
}

/* dec hl' */
| label? _TK_DEC _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2B); 
}

/* dec (hl) */
| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x35); 
}

/* dec (ix) */
| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD3500); 
  }
  else {
    DO_stmt(0xFD3500); 
  }
}

/* dec (ix+DIS) */
| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD35); 
  }
  else {
    DO_stmt_idx(0xFD35); 
  }
}

/* dec (iy) */
| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD3500); 
  }
  else {
    DO_stmt(0xDD3500); 
  }
}

/* dec (iy+DIS) */
| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD35); 
  }
  else {
    DO_stmt_idx(0xDD35); 
  }
}

/* dec ix */
| label? _TK_DEC _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD2B); 
  }
  else {
    DO_stmt(0xFD2B); 
  }
}

/* dec ixh */
| label? _TK_DEC _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD25); 
  }
  else {
    DO_stmt(0xFD25); 
  }
}

/* dec ixl */
| label? _TK_DEC _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD2D); 
  }
  else {
    DO_stmt(0xFD2D); 
  }
}

/* dec iy */
| label? _TK_DEC _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD2B); 
  }
  else {
    DO_stmt(0xDD2B); 
  }
}

/* dec iyh */
| label? _TK_DEC _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD25); 
  }
  else {
    DO_stmt(0xDD25); 
  }
}

/* dec iyl */
| label? _TK_DEC _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD2D); 
  }
  else {
    DO_stmt(0xDD2D); 
  }
}

/* dec l */
| label? _TK_DEC _TK_L _TK_NEWLINE @{
  DO_stmt(0x2D); 
}

/* dec l' */
| label? _TK_DEC _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2D); 
}

/* dec sp */
| label? _TK_DEC _TK_SP _TK_NEWLINE @{
  DO_stmt(0x3B); 
}

/* di */
| label? _TK_DI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xF3); 
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

/* ei */
| label? _TK_EI _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFB); 
}

/* ex af,af */
| label? _TK_EX _TK_AF _TK_COMMA _TK_AF _TK_NEWLINE @{
  DO_stmt(0x08); 
}

/* ex af,af' */
| label? _TK_EX _TK_AF _TK_COMMA _TK_AF1 _TK_NEWLINE @{
  DO_stmt(0x08); 
}

/* ex de,hl */
| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
  DO_stmt(0xEB); 
}

/* ex de,hl' */
| label? _TK_EX _TK_DE _TK_COMMA _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xEB); 
}

/* ex de',hl */
| label? _TK_EX _TK_DE1 _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xE3); 
}

/* ex de',hl' */
| label? _TK_EX _TK_DE1 _TK_COMMA _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xE3); 
}

/* ex (sp),hl */
| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & CPU_ZILOG) != 0) {
    DO_stmt(0xE3); 
  }
  else {
    DO_stmt(0xED54); 
  }
}

/* ex (sp),hl' */
| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED54); 
}

/* ex (sp),ix */
| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDE3); 
  }
  else {
    DO_stmt(0xFDE3); 
  }
}

/* ex (sp),iy */
| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE3); 
  }
  else {
    DO_stmt(0xDDE3); 
  }
}

/* exx */
| label? _TK_EXX _TK_NEWLINE @{
  DO_stmt(0xD9); 
}

/* halt */
| label? _TK_HALT _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76); 
}

/* idet */
| label? _TK_IDET _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x5B); 
}

/* im 0 */
/* im 1 */
/* im 2 */
| label? _TK_IM const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xED56); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xED5E); 
  }
  else
    error_int_range(expr_value);

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

/* inc a */
| label? _TK_INC _TK_A _TK_NEWLINE @{
  DO_stmt(0x3C); 
}

/* inc a' */
| label? _TK_INC _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x3C); 
}

/* inc b */
| label? _TK_INC _TK_B _TK_NEWLINE @{
  DO_stmt(0x04); 
}

/* inc b' */
| label? _TK_INC _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x04); 
}

/* inc bc */
| label? _TK_INC _TK_BC _TK_NEWLINE @{
  DO_stmt(0x03); 
}

/* inc bc' */
| label? _TK_INC _TK_BC1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x03); 
}

/* inc c */
| label? _TK_INC _TK_C _TK_NEWLINE @{
  DO_stmt(0x0C); 
}

/* inc c' */
| label? _TK_INC _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0C); 
}

/* inc d */
| label? _TK_INC _TK_D _TK_NEWLINE @{
  DO_stmt(0x14); 
}

/* inc d' */
| label? _TK_INC _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x14); 
}

/* inc de */
| label? _TK_INC _TK_DE _TK_NEWLINE @{
  DO_stmt(0x13); 
}

/* inc de' */
| label? _TK_INC _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x13); 
}

/* inc e */
| label? _TK_INC _TK_E _TK_NEWLINE @{
  DO_stmt(0x1C); 
}

/* inc e' */
| label? _TK_INC _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1C); 
}

/* inc h */
| label? _TK_INC _TK_H _TK_NEWLINE @{
  DO_stmt(0x24); 
}

/* inc h' */
| label? _TK_INC _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x24); 
}

/* inc hl */
| label? _TK_INC _TK_HL _TK_NEWLINE @{
  DO_stmt(0x23); 
}

/* inc hl' */
| label? _TK_INC _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x23); 
}

/* inc (hl) */
| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x34); 
}

/* inc (ix) */
| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD3400); 
  }
  else {
    DO_stmt(0xFD3400); 
  }
}

/* inc (ix+DIS) */
| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD34); 
  }
  else {
    DO_stmt_idx(0xFD34); 
  }
}

/* inc (iy) */
| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD3400); 
  }
  else {
    DO_stmt(0xDD3400); 
  }
}

/* inc (iy+DIS) */
| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD34); 
  }
  else {
    DO_stmt_idx(0xDD34); 
  }
}

/* inc ix */
| label? _TK_INC _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD23); 
  }
  else {
    DO_stmt(0xFD23); 
  }
}

/* inc ixh */
| label? _TK_INC _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD24); 
  }
  else {
    DO_stmt(0xFD24); 
  }
}

/* inc ixl */
| label? _TK_INC _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD2C); 
  }
  else {
    DO_stmt(0xFD2C); 
  }
}

/* inc iy */
| label? _TK_INC _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD23); 
  }
  else {
    DO_stmt(0xDD23); 
  }
}

/* inc iyh */
| label? _TK_INC _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD24); 
  }
  else {
    DO_stmt(0xDD24); 
  }
}

/* inc iyl */
| label? _TK_INC _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD2C); 
  }
  else {
    DO_stmt(0xDD2C); 
  }
}

/* inc l */
| label? _TK_INC _TK_L _TK_NEWLINE @{
  DO_stmt(0x2C); 
}

/* inc l' */
| label? _TK_INC _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x2C); 
}

/* inc sp */
| label? _TK_INC _TK_SP _TK_NEWLINE @{
  DO_stmt(0x33); 
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

/* ioe ld a,(NN) */
| label? _TK_IOE _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xDB3A); 
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

/* ioi ld a,(NN) */
| label? _TK_IOI _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xD33A); 
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

/* ipres */
| label? _TK_IPRES _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5D); 
}

/* ipset 0 */
/* ipset 1 */
/* ipset 2 */
/* ipset 3 */
| label? _TK_IPSET const_expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xED46); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xED56); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xED4E); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xED5E); 
  }
  else
    error_int_range(expr_value);

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

/* ld a,a */
| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x7F); 
}

/* ld a,b */
| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x78); 
}

/* ld a,c */
| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x79); 
}

/* ld a,d */
| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x7A); 
}

/* ld a,e */
| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x7B); 
}

/* ld a,eir */
| label? _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED57); 
}

/* ld a,h */
| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x7C); 
}

/* ld a,i */
| label? _TK_LD _TK_A _TK_COMMA _TK_I _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED57); 
}

/* ld a,iir */
| label? _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5F); 
}

/* ld a,(bc) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x0A); 
}

/* ld a,(de) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x1A); 
}

/* ld a,(hl) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x7E); 
}

/* ld a,(ix) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7E00); 
  }
  else {
    DO_stmt(0xFD7E00); 
  }
}

/* ld a,(ix+DIS) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD7E); 
  }
  else {
    DO_stmt_idx(0xFD7E); 
  }
}

/* ld a,(iy) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7E00); 
  }
  else {
    DO_stmt(0xDD7E00); 
  }
}

/* ld a,(iy+DIS) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD7E); 
  }
  else {
    DO_stmt_idx(0xDD7E); 
  }
}

/* ld a,ixh */
| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7C); 
  }
  else {
    DO_stmt(0xFD7C); 
  }
}

/* ld a,ixl */
| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7D); 
  }
  else {
    DO_stmt(0xFD7D); 
  }
}

/* ld a,iyh */
| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7C); 
  }
  else {
    DO_stmt(0xDD7C); 
  }
}

/* ld a,iyl */
| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7D); 
  }
  else {
    DO_stmt(0xDD7D); 
  }
}

/* ld a,l */
| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x7D); 
}

/* ld a,r */
| label? _TK_LD _TK_A _TK_COMMA _TK_R _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5F); 
}

/* ld a,xpc */
| label? _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED77); 
}

/* ld a,(NN) */
/* ld a,N */
| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    DO_stmt_nn(0x3A); 
  }
  else {
    DO_stmt_n(0x3E); 
  }
}

/* ld a',a */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7F); 
}

/* ld a',b */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x78); 
}

/* ld a',c */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x79); 
}

/* ld a',d */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7A); 
}

/* ld a',e */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7B); 
}

/* ld a',eir */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_EIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED57); 
}

/* ld a',h */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7C); 
}

/* ld a',iir */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IIR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED5F); 
}

/* ld a',(bc) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x0A); 
}

/* ld a',(de) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x1A); 
}

/* ld a',(hl) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7E); 
}

/* ld a',(ix) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD7E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD7E00); 
  }
}

/* ld a',(ix+DIS) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD7E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD7E); 
  }
}

/* ld a',(iy) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD7E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD7E00); 
  }
}

/* ld a',(iy+DIS) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD7E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD7E); 
  }
}

/* ld a',l */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x7D); 
}

/* ld a',xpc */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_XPC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED77); 
}

/* ld a',(NN) */
/* ld a',N */
| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0x3A); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_n(0x3E); 
  }
}

/* ld b,a */
| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x47); 
}

/* ld b,b */
| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x40); 
}

/* ld b,c */
| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x41); 
}

/* ld b,d */
| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x42); 
}

/* ld b,e */
| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x43); 
}

/* ld b,h */
| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x44); 
}

/* ld b,(hl) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x46); 
}

/* ld b,(ix) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD4600); 
  }
  else {
    DO_stmt(0xFD4600); 
  }
}

/* ld b,(ix+DIS) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD46); 
  }
  else {
    DO_stmt_idx(0xFD46); 
  }
}

/* ld b,(iy) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD4600); 
  }
  else {
    DO_stmt(0xDD4600); 
  }
}

/* ld b,(iy+DIS) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD46); 
  }
  else {
    DO_stmt_idx(0xDD46); 
  }
}

/* ld b,ixh */
| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD44); 
  }
  else {
    DO_stmt(0xFD44); 
  }
}

/* ld b,ixl */
| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD45); 
  }
  else {
    DO_stmt(0xFD45); 
  }
}

/* ld b,iyh */
| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD44); 
  }
  else {
    DO_stmt(0xDD44); 
  }
}

/* ld b,iyl */
| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD45); 
  }
  else {
    DO_stmt(0xDD45); 
  }
}

/* ld b,l */
| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x45); 
}

/* ld b,N */
| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x06); 
}

/* ld b',a */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x47); 
}

/* ld b',b */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x40); 
}

/* ld b',c */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x41); 
}

/* ld b',d */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x42); 
}

/* ld b',e */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x43); 
}

/* ld b',h */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x44); 
}

/* ld b',(hl) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x46); 
}

/* ld b',(ix) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD4600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD4600); 
  }
}

/* ld b',(ix+DIS) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD46); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD46); 
  }
}

/* ld b',(iy) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD4600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD4600); 
  }
}

/* ld b',(iy+DIS) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD46); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD46); 
  }
}

/* ld b',l */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x45); 
}

/* ld b',N */
| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x06); 
}

/* ld bc,(NN) */
/* ld bc,NN */
| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    DO_stmt_nn(0xED4B); 
  }
  else {
    DO_stmt_nn(0x01); 
  }
}

/* ld bc',bc */
| label? _TK_LD _TK_BC1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED49); 
}

/* ld bc',de */
| label? _TK_LD _TK_BC1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED41); 
}

/* ld bc',(NN) */
/* ld bc',NN */
| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0xED4B); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x01); 
  }
}

/* ld c,a */
| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x4F); 
}

/* ld c,b */
| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x48); 
}

/* ld c,c */
| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x49); 
}

/* ld c,d */
| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x4A); 
}

/* ld c,e */
| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x4B); 
}

/* ld c,h */
| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x4C); 
}

/* ld c,(hl) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x4E); 
}

/* ld c,(ix) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD4E00); 
  }
  else {
    DO_stmt(0xFD4E00); 
  }
}

/* ld c,(ix+DIS) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD4E); 
  }
  else {
    DO_stmt_idx(0xFD4E); 
  }
}

/* ld c,(iy) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD4E00); 
  }
  else {
    DO_stmt(0xDD4E00); 
  }
}

/* ld c,(iy+DIS) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD4E); 
  }
  else {
    DO_stmt_idx(0xDD4E); 
  }
}

/* ld c,ixh */
| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD4C); 
  }
  else {
    DO_stmt(0xFD4C); 
  }
}

/* ld c,ixl */
| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD4D); 
  }
  else {
    DO_stmt(0xFD4D); 
  }
}

/* ld c,iyh */
| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD4C); 
  }
  else {
    DO_stmt(0xDD4C); 
  }
}

/* ld c,iyl */
| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD4D); 
  }
  else {
    DO_stmt(0xDD4D); 
  }
}

/* ld c,l */
| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x4D); 
}

/* ld c,N */
| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x0E); 
}

/* ld c',a */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4F); 
}

/* ld c',b */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x48); 
}

/* ld c',c */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x49); 
}

/* ld c',d */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4A); 
}

/* ld c',e */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4B); 
}

/* ld c',h */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4C); 
}

/* ld c',(hl) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4E); 
}

/* ld c',(ix) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD4E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD4E00); 
  }
}

/* ld c',(ix+DIS) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD4E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD4E); 
  }
}

/* ld c',(iy) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD4E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD4E00); 
  }
}

/* ld c',(iy+DIS) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD4E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD4E); 
  }
}

/* ld c',l */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x4D); 
}

/* ld c',N */
| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x0E); 
}

/* ld d,a */
| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x57); 
}

/* ld d,b */
| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x50); 
}

/* ld d,c */
| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x51); 
}

/* ld d,d */
| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x52); 
}

/* ld d,e */
| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x53); 
}

/* ld d,h */
| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x54); 
}

/* ld d,(hl) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x56); 
}

/* ld d,(ix) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD5600); 
  }
  else {
    DO_stmt(0xFD5600); 
  }
}

/* ld d,(ix+DIS) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD56); 
  }
  else {
    DO_stmt_idx(0xFD56); 
  }
}

/* ld d,(iy) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD5600); 
  }
  else {
    DO_stmt(0xDD5600); 
  }
}

/* ld d,(iy+DIS) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD56); 
  }
  else {
    DO_stmt_idx(0xDD56); 
  }
}

/* ld d,ixh */
| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD54); 
  }
  else {
    DO_stmt(0xFD54); 
  }
}

/* ld d,ixl */
| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD55); 
  }
  else {
    DO_stmt(0xFD55); 
  }
}

/* ld d,iyh */
| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD54); 
  }
  else {
    DO_stmt(0xDD54); 
  }
}

/* ld d,iyl */
| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD55); 
  }
  else {
    DO_stmt(0xDD55); 
  }
}

/* ld d,l */
| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x55); 
}

/* ld d,N */
| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x16); 
}

/* ld d',a */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x57); 
}

/* ld d',b */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x50); 
}

/* ld d',c */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x51); 
}

/* ld d',d */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x52); 
}

/* ld d',e */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x53); 
}

/* ld d',h */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x54); 
}

/* ld d',(hl) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x56); 
}

/* ld d',(ix) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD5600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD5600); 
  }
}

/* ld d',(ix+DIS) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD56); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD56); 
  }
}

/* ld d',(iy) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD5600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD5600); 
  }
}

/* ld d',(iy+DIS) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD56); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD56); 
  }
}

/* ld d',l */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x55); 
}

/* ld d',N */
| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x16); 
}

/* ld de,(NN) */
/* ld de,NN */
| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    DO_stmt_nn(0xED5B); 
  }
  else {
    DO_stmt_nn(0x11); 
  }
}

/* ld de',bc */
| label? _TK_LD _TK_DE1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED59); 
}

/* ld de',de */
| label? _TK_LD _TK_DE1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED51); 
}

/* ld de',(NN) */
/* ld de',NN */
| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0xED5B); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x11); 
  }
}

/* ld e,a */
| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x5F); 
}

/* ld e,b */
| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x58); 
}

/* ld e,c */
| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x59); 
}

/* ld e,d */
| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x5A); 
}

/* ld e,e */
| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x5B); 
}

/* ld e,h */
| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x5C); 
}

/* ld e,(hl) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x5E); 
}

/* ld e,(ix) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD5E00); 
  }
  else {
    DO_stmt(0xFD5E00); 
  }
}

/* ld e,(ix+DIS) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD5E); 
  }
  else {
    DO_stmt_idx(0xFD5E); 
  }
}

/* ld e,(iy) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD5E00); 
  }
  else {
    DO_stmt(0xDD5E00); 
  }
}

/* ld e,(iy+DIS) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD5E); 
  }
  else {
    DO_stmt_idx(0xDD5E); 
  }
}

/* ld e,ixh */
| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD5C); 
  }
  else {
    DO_stmt(0xFD5C); 
  }
}

/* ld e,ixl */
| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD5D); 
  }
  else {
    DO_stmt(0xFD5D); 
  }
}

/* ld e,iyh */
| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD5C); 
  }
  else {
    DO_stmt(0xDD5C); 
  }
}

/* ld e,iyl */
| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD5D); 
  }
  else {
    DO_stmt(0xDD5D); 
  }
}

/* ld e,l */
| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x5D); 
}

/* ld e,N */
| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x1E); 
}

/* ld e',a */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5F); 
}

/* ld e',b */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x58); 
}

/* ld e',c */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x59); 
}

/* ld e',d */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5A); 
}

/* ld e',e */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5B); 
}

/* ld e',h */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5C); 
}

/* ld e',(hl) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5E); 
}

/* ld e',(ix) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD5E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD5E00); 
  }
}

/* ld e',(ix+DIS) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD5E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD5E); 
  }
}

/* ld e',(iy) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD5E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD5E00); 
  }
}

/* ld e',(iy+DIS) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD5E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD5E); 
  }
}

/* ld e',l */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x5D); 
}

/* ld e',N */
| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x1E); 
}

/* ld eir,a */
| label? _TK_LD _TK_EIR _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED47); 
}

/* ld h,a */
| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x67); 
}

/* ld h,b */
| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x60); 
}

/* ld h,c */
| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x61); 
}

/* ld h,d */
| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x62); 
}

/* ld h,e */
| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x63); 
}

/* ld h,h */
| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x64); 
}

/* ld h,(hl) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x66); 
}

/* ld h,(ix) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6600); 
  }
  else {
    DO_stmt(0xFD6600); 
  }
}

/* ld h,(ix+DIS) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD66); 
  }
  else {
    DO_stmt_idx(0xFD66); 
  }
}

/* ld h,(iy) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6600); 
  }
  else {
    DO_stmt(0xDD6600); 
  }
}

/* ld h,(iy+DIS) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD66); 
  }
  else {
    DO_stmt_idx(0xDD66); 
  }
}

/* ld h,l */
| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x65); 
}

/* ld h,N */
| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x26); 
}

/* ld h',a */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x67); 
}

/* ld h',b */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x60); 
}

/* ld h',c */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x61); 
}

/* ld h',d */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x62); 
}

/* ld h',e */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x63); 
}

/* ld h',h */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x64); 
}

/* ld h',(hl) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x66); 
}

/* ld h',(ix) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD6600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD6600); 
  }
}

/* ld h',(ix+DIS) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD66); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD66); 
  }
}

/* ld h',(iy) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD6600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD6600); 
  }
}

/* ld h',(iy+DIS) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD66); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD66); 
  }
}

/* ld h',l */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x65); 
}

/* ld h',N */
| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x26); 
}

/* ld hl,(hl) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDDE400); 
}

/* ld hl,(hl+DIS) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt_idx(0xDDE4); 
}

/* ld hl,(ix) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xE400); 
  }
  else {
    DO_stmt(0xFDE400); 
  }
}

/* ld hl,(ix+DIS) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xE4); 
  }
  else {
    DO_stmt_idx(0xFDE4); 
  }
}

/* ld hl,(iy) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE400); 
  }
  else {
    DO_stmt(0xE400); 
  }
}

/* ld hl,(iy+DIS) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDE4); 
  }
  else {
    DO_stmt_idx(0xE4); 
  }
}

/* ld hl,(sp) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xC400); 
}

/* ld hl,(sp+N) */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xC4); 
}

/* ld hl,ix */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7C); 
  }
  else {
    DO_stmt(0xFD7C); 
  }
}

/* ld hl,iy */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7C); 
  }
  else {
    DO_stmt(0xDD7C); 
  }
}

/* ld hl,(NN) */
/* ld hl,NN */
| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    DO_stmt_nn(0x2A); 
  }
  else {
    DO_stmt_nn(0x21); 
  }
}

/* ld hl',bc */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED69); 
}

/* ld hl',de */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED61); 
}

/* ld hl',(hl) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xDDE400); 
}

/* ld hl',(hl+DIS) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt_idx(0xDDE4); 
}

/* ld hl',(ix) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xE400); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDE400); 
  }
}

/* ld hl',(ix+DIS) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xE4); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDE4); 
  }
}

/* ld hl',(iy) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDE400); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xE400); 
  }
}

/* ld hl',(iy+DIS) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDE4); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xE4); 
  }
}

/* ld hl',(sp) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xC400); 
}

/* ld hl',(sp+N) */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xC4); 
}

/* ld hl',ix */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD7C); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD7C); 
  }
}

/* ld hl',iy */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD7C); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD7C); 
  }
}

/* ld hl',(NN) */
/* ld hl',NN */
| label? _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) {
    DO_stmt(0x76);
      DO_stmt_nn(0x2A); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_nn(0x21); 
  }
}

/* ld i,a */
| label? _TK_LD _TK_I _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED47); 
}

/* ld iir,a */
| label? _TK_LD _TK_IIR _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED4F); 
}

/* ld (bc),a */
| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x02); 
}

/* ld (de),a */
| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x12); 
}

/* ld (hl),a */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x77); 
}

/* ld (hl),b */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x70); 
}

/* ld (hl),c */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x71); 
}

/* ld (hl),d */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x72); 
}

/* ld (hl),e */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x73); 
}

/* ld (hl),h */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x74); 
}

/* ld (hl),hl */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xDDF400); 
}

/* ld (hl),l */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x75); 
}

/* ld (hl),N */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x36); 
}

/* ld (hl+DIS),hl */
| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt_idx(0xDDF4); 
}

/* ld (ix),a */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7700); 
  }
  else {
    DO_stmt(0xFD7700); 
  }
}

/* ld (ix),b */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7000); 
  }
  else {
    DO_stmt(0xFD7000); 
  }
}

/* ld (ix),c */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7100); 
  }
  else {
    DO_stmt(0xFD7100); 
  }
}

/* ld (ix),d */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7200); 
  }
  else {
    DO_stmt(0xFD7200); 
  }
}

/* ld (ix),e */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7300); 
  }
  else {
    DO_stmt(0xFD7300); 
  }
}

/* ld (ix),h */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7400); 
  }
  else {
    DO_stmt(0xFD7400); 
  }
}

/* ld (ix),hl */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xF400); 
  }
  else {
    DO_stmt(0xFDF400); 
  }
}

/* ld (ix),l */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7500); 
  }
  else {
    DO_stmt(0xFD7500); 
  }
}

/* ld (ix),N */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xDD3600); 
  }
  else {
    DO_stmt_n(0xFD3600); 
  }
}

/* ld (ix+DIS),a */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD77); 
  }
  else {
    DO_stmt_idx(0xFD77); 
  }
}

/* ld (ix+DIS),b */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD70); 
  }
  else {
    DO_stmt_idx(0xFD70); 
  }
}

/* ld (ix+DIS),c */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD71); 
  }
  else {
    DO_stmt_idx(0xFD71); 
  }
}

/* ld (ix+DIS),d */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD72); 
  }
  else {
    DO_stmt_idx(0xFD72); 
  }
}

/* ld (ix+DIS),e */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD73); 
  }
  else {
    DO_stmt_idx(0xFD73); 
  }
}

/* ld (ix+DIS),h */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD74); 
  }
  else {
    DO_stmt_idx(0xFD74); 
  }
}

/* ld (ix+DIS),hl */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xF4); 
  }
  else {
    DO_stmt_idx(0xFDF4); 
  }
}

/* ld (ix+DIS),l */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD75); 
  }
  else {
    DO_stmt_idx(0xFD75); 
  }
}

/* ld (ix+DIS),N */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_idx_n(0xDD36); 
  }
  else {
    DO_stmt_idx_n(0xFD36); 
  }
}

/* ld (iy),a */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7700); 
  }
  else {
    DO_stmt(0xDD7700); 
  }
}

/* ld (iy),b */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7000); 
  }
  else {
    DO_stmt(0xDD7000); 
  }
}

/* ld (iy),c */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7100); 
  }
  else {
    DO_stmt(0xDD7100); 
  }
}

/* ld (iy),d */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7200); 
  }
  else {
    DO_stmt(0xDD7200); 
  }
}

/* ld (iy),e */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7300); 
  }
  else {
    DO_stmt(0xDD7300); 
  }
}

/* ld (iy),h */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7400); 
  }
  else {
    DO_stmt(0xDD7400); 
  }
}

/* ld (iy),hl */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDF400); 
  }
  else {
    DO_stmt(0xF400); 
  }
}

/* ld (iy),l */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7500); 
  }
  else {
    DO_stmt(0xDD7500); 
  }
}

/* ld (iy),N */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xFD3600); 
  }
  else {
    DO_stmt_n(0xDD3600); 
  }
}

/* ld (iy+DIS),a */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD77); 
  }
  else {
    DO_stmt_idx(0xDD77); 
  }
}

/* ld (iy+DIS),b */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD70); 
  }
  else {
    DO_stmt_idx(0xDD70); 
  }
}

/* ld (iy+DIS),c */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD71); 
  }
  else {
    DO_stmt_idx(0xDD71); 
  }
}

/* ld (iy+DIS),d */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD72); 
  }
  else {
    DO_stmt_idx(0xDD72); 
  }
}

/* ld (iy+DIS),e */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD73); 
  }
  else {
    DO_stmt_idx(0xDD73); 
  }
}

/* ld (iy+DIS),h */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD74); 
  }
  else {
    DO_stmt_idx(0xDD74); 
  }
}

/* ld (iy+DIS),hl */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDF4); 
  }
  else {
    DO_stmt_idx(0xF4); 
  }
}

/* ld (iy+DIS),l */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD75); 
  }
  else {
    DO_stmt_idx(0xDD75); 
  }
}

/* ld (iy+DIS),N */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_idx_n(0xFD36); 
  }
  else {
    DO_stmt_idx_n(0xDD36); 
  }
}

/* ld (sp),hl */
| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xD400); 
}

/* ld (sp),ix */
| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDD400); 
  }
  else {
    DO_stmt(0xFDD400); 
  }
}

/* ld (sp),iy */
| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDD400); 
  }
  else {
    DO_stmt(0xDDD400); 
  }
}

/* ld (sp+N),hl */
| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xD4); 
}

/* ld (sp+N),ix */
| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xDDD4); 
  }
  else {
    DO_stmt_n(0xFDD4); 
  }
}

/* ld (sp+N),iy */
| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xFDD4); 
  }
  else {
    DO_stmt_n(0xDDD4); 
  }
}

/* ld ix,hl */
| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD7D); 
  }
  else {
    DO_stmt(0xFD7D); 
  }
}

/* ld ix,(sp) */
| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDC400); 
  }
  else {
    DO_stmt(0xFDC400); 
  }
}

/* ld ix,(sp+N) */
| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xDDC4); 
  }
  else {
    DO_stmt_n(0xFDC4); 
  }
}

/* ld ix,(NN) */
/* ld ix,NN */
| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xDD2A); 
  }
  else {
    DO_stmt_nn(0xFD2A); 
  }
  }
  else {
    if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xDD21); 
  }
  else {
    DO_stmt_nn(0xFD21); 
  }
  }
}

/* ld ixh,a */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD67); 
  }
  else {
    DO_stmt(0xFD67); 
  }
}

/* ld ixh,b */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD60); 
  }
  else {
    DO_stmt(0xFD60); 
  }
}

/* ld ixh,c */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD61); 
  }
  else {
    DO_stmt(0xFD61); 
  }
}

/* ld ixh,d */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD62); 
  }
  else {
    DO_stmt(0xFD62); 
  }
}

/* ld ixh,e */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD63); 
  }
  else {
    DO_stmt(0xFD63); 
  }
}

/* ld ixh,ixh */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD64); 
  }
  else {
    DO_stmt(0xFD64); 
  }
}

/* ld ixh,ixl */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD65); 
  }
  else {
    DO_stmt(0xFD65); 
  }
}

/* ld ixh,N */
| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xDD26); 
  }
  else {
    DO_stmt_n(0xFD26); 
  }
}

/* ld ixl,a */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6F); 
  }
  else {
    DO_stmt(0xFD6F); 
  }
}

/* ld ixl,b */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD68); 
  }
  else {
    DO_stmt(0xFD68); 
  }
}

/* ld ixl,c */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD69); 
  }
  else {
    DO_stmt(0xFD69); 
  }
}

/* ld ixl,d */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6A); 
  }
  else {
    DO_stmt(0xFD6A); 
  }
}

/* ld ixl,e */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6B); 
  }
  else {
    DO_stmt(0xFD6B); 
  }
}

/* ld ixl,ixh */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6C); 
  }
  else {
    DO_stmt(0xFD6C); 
  }
}

/* ld ixl,ixl */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6D); 
  }
  else {
    DO_stmt(0xFD6D); 
  }
}

/* ld ixl,N */
| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xDD2E); 
  }
  else {
    DO_stmt_n(0xFD2E); 
  }
}

/* ld iy,hl */
| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD7D); 
  }
  else {
    DO_stmt(0xDD7D); 
  }
}

/* ld iy,(sp) */
| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDC400); 
  }
  else {
    DO_stmt(0xDDC400); 
  }
}

/* ld iy,(sp+N) */
| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xFDC4); 
  }
  else {
    DO_stmt_n(0xDDC4); 
  }
}

/* ld iy,(NN) */
/* ld iy,NN */
| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xFD2A); 
  }
  else {
    DO_stmt_nn(0xDD2A); 
  }
  }
  else {
    if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xFD21); 
  }
  else {
    DO_stmt_nn(0xDD21); 
  }
  }
}

/* ld iyh,a */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD67); 
  }
  else {
    DO_stmt(0xDD67); 
  }
}

/* ld iyh,b */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD60); 
  }
  else {
    DO_stmt(0xDD60); 
  }
}

/* ld iyh,c */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD61); 
  }
  else {
    DO_stmt(0xDD61); 
  }
}

/* ld iyh,d */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD62); 
  }
  else {
    DO_stmt(0xDD62); 
  }
}

/* ld iyh,e */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD63); 
  }
  else {
    DO_stmt(0xDD63); 
  }
}

/* ld iyh,iyh */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD64); 
  }
  else {
    DO_stmt(0xDD64); 
  }
}

/* ld iyh,iyl */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD65); 
  }
  else {
    DO_stmt(0xDD65); 
  }
}

/* ld iyh,N */
| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xFD26); 
  }
  else {
    DO_stmt_n(0xDD26); 
  }
}

/* ld iyl,a */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6F); 
  }
  else {
    DO_stmt(0xDD6F); 
  }
}

/* ld iyl,b */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD68); 
  }
  else {
    DO_stmt(0xDD68); 
  }
}

/* ld iyl,c */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD69); 
  }
  else {
    DO_stmt(0xDD69); 
  }
}

/* ld iyl,d */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6A); 
  }
  else {
    DO_stmt(0xDD6A); 
  }
}

/* ld iyl,e */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6B); 
  }
  else {
    DO_stmt(0xDD6B); 
  }
}

/* ld iyl,iyh */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6C); 
  }
  else {
    DO_stmt(0xDD6C); 
  }
}

/* ld iyl,iyl */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6D); 
  }
  else {
    DO_stmt(0xDD6D); 
  }
}

/* ld iyl,N */
| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  if (!opts.swap_ix_iy) {
    DO_stmt_n(0xFD2E); 
  }
  else {
    DO_stmt_n(0xDD2E); 
  }
}

/* ld l,a */
| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x6F); 
}

/* ld l,b */
| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x68); 
}

/* ld l,c */
| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x69); 
}

/* ld l,d */
| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x6A); 
}

/* ld l,e */
| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x6B); 
}

/* ld l,h */
| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x6C); 
}

/* ld l,(hl) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x6E); 
}

/* ld l,(ix) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6E00); 
  }
  else {
    DO_stmt(0xFD6E00); 
  }
}

/* ld l,(ix+DIS) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD6E); 
  }
  else {
    DO_stmt_idx(0xFD6E); 
  }
}

/* ld l,(iy) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6E00); 
  }
  else {
    DO_stmt(0xDD6E00); 
  }
}

/* ld l,(iy+DIS) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD6E); 
  }
  else {
    DO_stmt_idx(0xDD6E); 
  }
}

/* ld l,l */
| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x6D); 
}

/* ld l,N */
| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0x2E); 
}

/* ld l',a */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6F); 
}

/* ld l',b */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x68); 
}

/* ld l',c */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x69); 
}

/* ld l',d */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6A); 
}

/* ld l',e */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6B); 
}

/* ld l',h */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6C); 
}

/* ld l',(hl) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6E); 
}

/* ld l',(ix) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD6E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD6E00); 
  }
}

/* ld l',(ix+DIS) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD6E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD6E); 
  }
}

/* ld l',(iy) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD6E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD6E00); 
  }
}

/* ld l',(iy+DIS) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD6E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD6E); 
  }
}

/* ld l',l */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x6D); 
}

/* ld l',N */
| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0x2E); 
}

/* ld r,a */
| label? _TK_LD _TK_R _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED4F); 
}

/* ld sp,hl */
| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
  DO_stmt(0xF9); 
}

/* ld sp,ix */
| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDF9); 
  }
  else {
    DO_stmt(0xFDF9); 
  }
}

/* ld sp,iy */
| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDF9); 
  }
  else {
    DO_stmt(0xDDF9); 
  }
}

/* ld sp,(NN) */
/* ld sp,NN */
| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) {
    DO_stmt_nn(0xED7B); 
  }
  else {
    DO_stmt_nn(0x31); 
  }
}

/* ld xpc,a */
| label? _TK_LD _TK_XPC _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED67); 
}

/* ld (NN),a */
| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0x32); 
}

/* ld (NN),bc */
| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xED43); 
}

/* ld (NN),de */
| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xED53); 
}

/* ld (NN),hl */
| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0x22); 
}

/* ld (NN),ix */
| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xDD22); 
  }
  else {
    DO_stmt_nn(0xFD22); 
  }
}

/* ld (NN),iy */
| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xFD22); 
  }
  else {
    DO_stmt_nn(0xDD22); 
  }
}

/* ld (NN),sp */
| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xED73); 
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

/* ldp hl,(hl) */
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED6C); 
}

/* ldp hl,(ix) */
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD6C); 
  }
  else {
    DO_stmt(0xFD6C); 
  }
}

/* ldp hl,(iy) */
| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD6C); 
  }
  else {
    DO_stmt(0xDD6C); 
  }
}

/* ldp hl,(NN) */
| label? _TK_LDP _TK_HL _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xED6D); 
}

/* ldp (hl),hl */
| label? _TK_LDP _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED64); 
}

/* ldp (ix),hl */
| label? _TK_LDP _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD64); 
  }
  else {
    DO_stmt(0xFD64); 
  }
}

/* ldp (iy),hl */
| label? _TK_LDP _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD64); 
  }
  else {
    DO_stmt(0xDD64); 
  }
}

/* ldp ix,(NN) */
| label? _TK_LDP _TK_IX _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xDD6D); 
  }
  else {
    DO_stmt_nn(0xFD6D); 
  }
}

/* ldp iy,(NN) */
| label? _TK_LDP _TK_IY _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xFD6D); 
  }
  else {
    DO_stmt_nn(0xDD6D); 
  }
}

/* ldp (NN),hl */
| label? _TK_LDP expr _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  DO_stmt_nn(0xED65); 
}

/* ldp (NN),ix */
| label? _TK_LDP expr _TK_COMMA _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xDD65); 
  }
  else {
    DO_stmt_nn(0xFD65); 
  }
}

/* ldp (NN),iy */
| label? _TK_LDP expr _TK_COMMA _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!expr_in_parens) return FALSE;
  if (!opts.swap_ix_iy) {
    DO_stmt_nn(0xFD65); 
  }
  else {
    DO_stmt_nn(0xDD65); 
  }
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

/* mlt bc */
| label? _TK_MLT _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED4C); 
}

/* mlt de */
| label? _TK_MLT _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED5C); 
}

/* mlt hl */
| label? _TK_MLT _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED6C); 
}

/* mlt sp */
| label? _TK_MLT _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7C); 
}

/* mul */
| label? _TK_MUL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xF7); 
}

/* neg */
| label? _TK_NEG _TK_NEWLINE @{
  DO_stmt(0xED44); 
}

/* neg a */
| label? _TK_NEG _TK_A _TK_NEWLINE @{
  DO_stmt(0xED44); 
}

/* neg a' */
| label? _TK_NEG _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED44); 
}

/* nop */
| label? _TK_NOP _TK_NEWLINE @{
  DO_stmt(0x00); 
}

/* or a */
| label? _TK_OR _TK_A _TK_NEWLINE @{
  DO_stmt(0xB7); 
}

/* or a,a */
| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0xB7); 
}

/* or a,b */
| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0xB0); 
}

/* or a,c */
| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0xB1); 
}

/* or a,d */
| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0xB2); 
}

/* or a,e */
| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0xB3); 
}

/* or a,h */
| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0xB4); 
}

/* or a,(hl) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xB6); 
}

/* or a,(ix) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB600); 
  }
  else {
    DO_stmt(0xFDB600); 
  }
}

/* or a,(ix+DIS) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDB6); 
  }
  else {
    DO_stmt_idx(0xFDB6); 
  }
}

/* or a,(iy) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB600); 
  }
  else {
    DO_stmt(0xDDB600); 
  }
}

/* or a,(iy+DIS) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDB6); 
  }
  else {
    DO_stmt_idx(0xDDB6); 
  }
}

/* or a,ixh */
| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB4); 
  }
  else {
    DO_stmt(0xFDB4); 
  }
}

/* or a,ixl */
| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB5); 
  }
  else {
    DO_stmt(0xFDB5); 
  }
}

/* or a,iyh */
| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB4); 
  }
  else {
    DO_stmt(0xDDB4); 
  }
}

/* or a,iyl */
| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB5); 
  }
  else {
    DO_stmt(0xDDB5); 
  }
}

/* or a,l */
| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0xB5); 
}

/* or a,N */
| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xF6); 
}

/* or a',a */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB7); 
}

/* or a',b */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB0); 
}

/* or a',c */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB1); 
}

/* or a',d */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB2); 
}

/* or a',e */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB3); 
}

/* or a',h */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB4); 
}

/* or a',(hl) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB6); 
}

/* or a',(ix) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
}

/* or a',(ix+DIS) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
}

/* or a',(iy) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDB600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDB600); 
  }
}

/* or a',(iy+DIS) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDB6); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDB6); 
  }
}

/* or a',l */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xB5); 
}

/* or a',N */
| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xF6); 
}

/* or b */
| label? _TK_OR _TK_B _TK_NEWLINE @{
  DO_stmt(0xB0); 
}

/* or c */
| label? _TK_OR _TK_C _TK_NEWLINE @{
  DO_stmt(0xB1); 
}

/* or d */
| label? _TK_OR _TK_D _TK_NEWLINE @{
  DO_stmt(0xB2); 
}

/* or e */
| label? _TK_OR _TK_E _TK_NEWLINE @{
  DO_stmt(0xB3); 
}

/* or h */
| label? _TK_OR _TK_H _TK_NEWLINE @{
  DO_stmt(0xB4); 
}

/* or hl,de */
| label? _TK_OR _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEC); 
}

/* or hl',de */
| label? _TK_OR _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xEC); 
}

/* or (hl) */
| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xB6); 
}

/* or (ix) */
| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB600); 
  }
  else {
    DO_stmt(0xFDB600); 
  }
}

/* or (ix+DIS) */
| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDB6); 
  }
  else {
    DO_stmt_idx(0xFDB6); 
  }
}

/* or (iy) */
| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB600); 
  }
  else {
    DO_stmt(0xDDB600); 
  }
}

/* or (iy+DIS) */
| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDB6); 
  }
  else {
    DO_stmt_idx(0xDDB6); 
  }
}

/* or ix,de */
| label? _TK_OR _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDEC); 
  }
  else {
    DO_stmt(0xFDEC); 
  }
}

/* or ixh */
| label? _TK_OR _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB4); 
  }
  else {
    DO_stmt(0xFDB4); 
  }
}

/* or ixl */
| label? _TK_OR _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDB5); 
  }
  else {
    DO_stmt(0xFDB5); 
  }
}

/* or iy,de */
| label? _TK_OR _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDEC); 
  }
  else {
    DO_stmt(0xDDEC); 
  }
}

/* or iyh */
| label? _TK_OR _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB4); 
  }
  else {
    DO_stmt(0xDDB4); 
  }
}

/* or iyl */
| label? _TK_OR _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDB5); 
  }
  else {
    DO_stmt(0xDDB5); 
  }
}

/* or l */
| label? _TK_OR _TK_L _TK_NEWLINE @{
  DO_stmt(0xB5); 
}

/* or N */
| label? _TK_OR expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xF6); 
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

/* pop af */
| label? _TK_POP _TK_AF _TK_NEWLINE @{
  DO_stmt(0xF1); 
}

/* pop af' */
| label? _TK_POP _TK_AF1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF1); 
}

/* pop bc */
| label? _TK_POP _TK_BC _TK_NEWLINE @{
  DO_stmt(0xC1); 
}

/* pop bc' */
| label? _TK_POP _TK_BC1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xC1); 
}

/* pop de */
| label? _TK_POP _TK_DE _TK_NEWLINE @{
  DO_stmt(0xD1); 
}

/* pop de' */
| label? _TK_POP _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xD1); 
}

/* pop hl */
| label? _TK_POP _TK_HL _TK_NEWLINE @{
  DO_stmt(0xE1); 
}

/* pop hl' */
| label? _TK_POP _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xE1); 
}

/* pop ip */
| label? _TK_POP _TK_IP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7E); 
}

/* pop ix */
| label? _TK_POP _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDE1); 
  }
  else {
    DO_stmt(0xFDE1); 
  }
}

/* pop iy */
| label? _TK_POP _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE1); 
  }
  else {
    DO_stmt(0xDDE1); 
  }
}

/* pop su */
| label? _TK_POP _TK_SU _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED6E); 
}

/* push af */
| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
  DO_stmt(0xF5); 
}

/* push bc */
| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
  DO_stmt(0xC5); 
}

/* push de */
| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
  DO_stmt(0xD5); 
}

/* push hl */
| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
  DO_stmt(0xE5); 
}

/* push ip */
| label? _TK_PUSH _TK_IP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED76); 
}

/* push ix */
| label? _TK_PUSH _TK_IX _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDE5); 
  }
  else {
    DO_stmt(0xFDE5); 
  }
}

/* push iy */
| label? _TK_PUSH _TK_IY _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDE5); 
  }
  else {
    DO_stmt(0xDDE5); 
  }
}

/* push su */
| label? _TK_PUSH _TK_SU _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED66); 
}

/* rdmode */
| label? _TK_RDMODE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7F); 
}

/* res 0,a */
/* res 1,a */
/* res 2,a */
/* res 3,a */
/* res 4,a */
/* res 5,a */
/* res 6,a */
/* res 7,a */
| label? _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,a' */
/* res 1,a' */
/* res 2,a' */
/* res 3,a' */
/* res 4,a' */
/* res 5,a' */
/* res 6,a' */
/* res 7,a' */
| label? _TK_RES const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB87); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8F); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB97); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9F); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBF); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,b */
/* res 1,b */
/* res 2,b */
/* res 3,b */
/* res 4,b */
/* res 5,b */
/* res 6,b */
/* res 7,b */
| label? _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,b' */
/* res 1,b' */
/* res 2,b' */
/* res 3,b' */
/* res 4,b' */
/* res 5,b' */
/* res 6,b' */
/* res 7,b' */
| label? _TK_RES const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB80); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB88); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB90); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB98); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB8); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,c */
/* res 1,c */
/* res 2,c */
/* res 3,c */
/* res 4,c */
/* res 5,c */
/* res 6,c */
/* res 7,c */
| label? _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,c' */
/* res 1,c' */
/* res 2,c' */
/* res 3,c' */
/* res 4,c' */
/* res 5,c' */
/* res 6,c' */
/* res 7,c' */
| label? _TK_RES const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB81); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB89); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB91); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB99); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBA9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBB9); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,d */
/* res 1,d */
/* res 2,d */
/* res 3,d */
/* res 4,d */
/* res 5,d */
/* res 6,d */
/* res 7,d */
| label? _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,d' */
/* res 1,d' */
/* res 2,d' */
/* res 3,d' */
/* res 4,d' */
/* res 5,d' */
/* res 6,d' */
/* res 7,d' */
| label? _TK_RES const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB82); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8A); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB92); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9A); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBA); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,e */
/* res 1,e */
/* res 2,e */
/* res 3,e */
/* res 4,e */
/* res 5,e */
/* res 6,e */
/* res 7,e */
| label? _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,e' */
/* res 1,e' */
/* res 2,e' */
/* res 3,e' */
/* res 4,e' */
/* res 5,e' */
/* res 6,e' */
/* res 7,e' */
| label? _TK_RES const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB83); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8B); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB93); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9B); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBB); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,h */
/* res 1,h */
/* res 2,h */
/* res 3,h */
/* res 4,h */
/* res 5,h */
/* res 6,h */
/* res 7,h */
| label? _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,h' */
/* res 1,h' */
/* res 2,h' */
/* res 3,h' */
/* res 4,h' */
/* res 5,h' */
/* res 6,h' */
/* res 7,h' */
| label? _TK_RES const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB84); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8C); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB94); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9C); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBC); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,(hl) */
/* res 1,(hl) */
/* res 2,(hl) */
/* res 3,(hl) */
/* res 4,(hl) */
/* res 5,(hl) */
/* res 6,(hl) */
/* res 7,(hl) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB86); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8E); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB96); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9E); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA6); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAE); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB6); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBE); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,(ix) */
/* res 1,(ix) */
/* res 2,(ix) */
/* res 3,(ix) */
/* res 4,(ix) */
/* res 5,(ix) */
/* res 6,(ix) */
/* res 7,(ix) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0086); 
  }
  else {
    DO_stmt(0xFDCB0086); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB008E); 
  }
  else {
    DO_stmt(0xFDCB008E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0096); 
  }
  else {
    DO_stmt(0xFDCB0096); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB009E); 
  }
  else {
    DO_stmt(0xFDCB009E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00A6); 
  }
  else {
    DO_stmt(0xFDCB00A6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00AE); 
  }
  else {
    DO_stmt(0xFDCB00AE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00B6); 
  }
  else {
    DO_stmt(0xFDCB00B6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00BE); 
  }
  else {
    DO_stmt(0xFDCB00BE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(ix+DIS) */
/* res 1,(ix+DIS) */
/* res 2,(ix+DIS) */
/* res 3,(ix+DIS) */
/* res 4,(ix+DIS) */
/* res 5,(ix+DIS) */
/* res 6,(ix+DIS) */
/* res 7,(ix+DIS) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB86); 
  }
  else {
    DO_stmt_idx(0xFDCB86); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB8E); 
  }
  else {
    DO_stmt_idx(0xFDCB8E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB96); 
  }
  else {
    DO_stmt_idx(0xFDCB96); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB9E); 
  }
  else {
    DO_stmt_idx(0xFDCB9E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBA6); 
  }
  else {
    DO_stmt_idx(0xFDCBA6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBAE); 
  }
  else {
    DO_stmt_idx(0xFDCBAE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBB6); 
  }
  else {
    DO_stmt_idx(0xFDCBB6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBBE); 
  }
  else {
    DO_stmt_idx(0xFDCBBE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(iy) */
/* res 1,(iy) */
/* res 2,(iy) */
/* res 3,(iy) */
/* res 4,(iy) */
/* res 5,(iy) */
/* res 6,(iy) */
/* res 7,(iy) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0086); 
  }
  else {
    DO_stmt(0xDDCB0086); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB008E); 
  }
  else {
    DO_stmt(0xDDCB008E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0096); 
  }
  else {
    DO_stmt(0xDDCB0096); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB009E); 
  }
  else {
    DO_stmt(0xDDCB009E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00A6); 
  }
  else {
    DO_stmt(0xDDCB00A6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00AE); 
  }
  else {
    DO_stmt(0xDDCB00AE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00B6); 
  }
  else {
    DO_stmt(0xDDCB00B6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00BE); 
  }
  else {
    DO_stmt(0xDDCB00BE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,(iy+DIS) */
/* res 1,(iy+DIS) */
/* res 2,(iy+DIS) */
/* res 3,(iy+DIS) */
/* res 4,(iy+DIS) */
/* res 5,(iy+DIS) */
/* res 6,(iy+DIS) */
/* res 7,(iy+DIS) */
| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB86); 
  }
  else {
    DO_stmt_idx(0xDDCB86); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB8E); 
  }
  else {
    DO_stmt_idx(0xDDCB8E); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB96); 
  }
  else {
    DO_stmt_idx(0xDDCB96); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB9E); 
  }
  else {
    DO_stmt_idx(0xDDCB9E); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBA6); 
  }
  else {
    DO_stmt_idx(0xDDCBA6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBAE); 
  }
  else {
    DO_stmt_idx(0xDDCBAE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBB6); 
  }
  else {
    DO_stmt_idx(0xDDCBB6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBBE); 
  }
  else {
    DO_stmt_idx(0xDDCBBE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* res 0,l */
/* res 1,l */
/* res 2,l */
/* res 3,l */
/* res 4,l */
/* res 5,l */
/* res 6,l */
/* res 7,l */
| label? _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

}

/* res 0,l' */
/* res 1,l' */
/* res 2,l' */
/* res 3,l' */
/* res 4,l' */
/* res 5,l' */
/* res 6,l' */
/* res 7,l' */
| label? _TK_RES const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCB85); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCB8D); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCB95); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCB9D); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBA5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBAD); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBB5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBBD); 
  }
  else
    error_int_range(expr_value);

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

/* reti */
| label? _TK_RETI _TK_NEWLINE @{
  DO_stmt(0xED4D); 
}

/* retn */
| label? _TK_RETN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED45); 
}

/* rl a */
| label? _TK_RL _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB17); 
}

/* rl b */
| label? _TK_RL _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB10); 
}

/* rl c */
| label? _TK_RL _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB11); 
}

/* rl d */
| label? _TK_RL _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB12); 
}

/* rl de */
| label? _TK_RL _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xF3); 
}

/* rl de' */
| label? _TK_RL _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xF3); 
}

/* rl e */
| label? _TK_RL _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB13); 
}

/* rl h */
| label? _TK_RL _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB14); 
}

/* rl (hl) */
| label? _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB16); 
}

/* rl (ix) */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0016); 
  }
  else {
    DO_stmt(0xFDCB0016); 
  }
}

/* rl (ix),a */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0017); 
  }
  else {
    DO_stmt(0xFDCB0017); 
  }
}

/* rl (ix),b */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0010); 
  }
  else {
    DO_stmt(0xFDCB0010); 
  }
}

/* rl (ix),c */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0011); 
  }
  else {
    DO_stmt(0xFDCB0011); 
  }
}

/* rl (ix),d */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0012); 
  }
  else {
    DO_stmt(0xFDCB0012); 
  }
}

/* rl (ix),e */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0013); 
  }
  else {
    DO_stmt(0xFDCB0013); 
  }
}

/* rl (ix),h */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0014); 
  }
  else {
    DO_stmt(0xFDCB0014); 
  }
}

/* rl (ix),l */
| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0015); 
  }
  else {
    DO_stmt(0xFDCB0015); 
  }
}

/* rl (ix+DIS) */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB16); 
  }
  else {
    DO_stmt_idx(0xFDCB16); 
  }
}

/* rl (ix+DIS),a */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB17); 
  }
  else {
    DO_stmt_idx(0xFDCB17); 
  }
}

/* rl (ix+DIS),b */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB10); 
  }
  else {
    DO_stmt_idx(0xFDCB10); 
  }
}

/* rl (ix+DIS),c */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB11); 
  }
  else {
    DO_stmt_idx(0xFDCB11); 
  }
}

/* rl (ix+DIS),d */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB12); 
  }
  else {
    DO_stmt_idx(0xFDCB12); 
  }
}

/* rl (ix+DIS),e */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB13); 
  }
  else {
    DO_stmt_idx(0xFDCB13); 
  }
}

/* rl (ix+DIS),h */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB14); 
  }
  else {
    DO_stmt_idx(0xFDCB14); 
  }
}

/* rl (ix+DIS),l */
| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB15); 
  }
  else {
    DO_stmt_idx(0xFDCB15); 
  }
}

/* rl (iy) */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0016); 
  }
  else {
    DO_stmt(0xDDCB0016); 
  }
}

/* rl (iy),a */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0017); 
  }
  else {
    DO_stmt(0xDDCB0017); 
  }
}

/* rl (iy),b */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0010); 
  }
  else {
    DO_stmt(0xDDCB0010); 
  }
}

/* rl (iy),c */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0011); 
  }
  else {
    DO_stmt(0xDDCB0011); 
  }
}

/* rl (iy),d */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0012); 
  }
  else {
    DO_stmt(0xDDCB0012); 
  }
}

/* rl (iy),e */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0013); 
  }
  else {
    DO_stmt(0xDDCB0013); 
  }
}

/* rl (iy),h */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0014); 
  }
  else {
    DO_stmt(0xDDCB0014); 
  }
}

/* rl (iy),l */
| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0015); 
  }
  else {
    DO_stmt(0xDDCB0015); 
  }
}

/* rl (iy+DIS) */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB16); 
  }
  else {
    DO_stmt_idx(0xDDCB16); 
  }
}

/* rl (iy+DIS),a */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB17); 
  }
  else {
    DO_stmt_idx(0xDDCB17); 
  }
}

/* rl (iy+DIS),b */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB10); 
  }
  else {
    DO_stmt_idx(0xDDCB10); 
  }
}

/* rl (iy+DIS),c */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB11); 
  }
  else {
    DO_stmt_idx(0xDDCB11); 
  }
}

/* rl (iy+DIS),d */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB12); 
  }
  else {
    DO_stmt_idx(0xDDCB12); 
  }
}

/* rl (iy+DIS),e */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB13); 
  }
  else {
    DO_stmt_idx(0xDDCB13); 
  }
}

/* rl (iy+DIS),h */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB14); 
  }
  else {
    DO_stmt_idx(0xDDCB14); 
  }
}

/* rl (iy+DIS),l */
| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB15); 
  }
  else {
    DO_stmt_idx(0xDDCB15); 
  }
}

/* rl l */
| label? _TK_RL _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB15); 
}

/* rla */
| label? _TK_RLA _TK_NEWLINE @{
  DO_stmt(0x17); 
}

/* rlc a */
| label? _TK_RLC _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB07); 
}

/* rlc b */
| label? _TK_RLC _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB00); 
}

/* rlc c */
| label? _TK_RLC _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB01); 
}

/* rlc d */
| label? _TK_RLC _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB02); 
}

/* rlc e */
| label? _TK_RLC _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB03); 
}

/* rlc h */
| label? _TK_RLC _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB04); 
}

/* rlc (hl) */
| label? _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB06); 
}

/* rlc (ix) */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0006); 
  }
  else {
    DO_stmt(0xFDCB0006); 
  }
}

/* rlc (ix),a */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0007); 
  }
  else {
    DO_stmt(0xFDCB0007); 
  }
}

/* rlc (ix),b */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0000); 
  }
  else {
    DO_stmt(0xFDCB0000); 
  }
}

/* rlc (ix),c */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0001); 
  }
  else {
    DO_stmt(0xFDCB0001); 
  }
}

/* rlc (ix),d */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0002); 
  }
  else {
    DO_stmt(0xFDCB0002); 
  }
}

/* rlc (ix),e */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0003); 
  }
  else {
    DO_stmt(0xFDCB0003); 
  }
}

/* rlc (ix),h */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0004); 
  }
  else {
    DO_stmt(0xFDCB0004); 
  }
}

/* rlc (ix),l */
| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0005); 
  }
  else {
    DO_stmt(0xFDCB0005); 
  }
}

/* rlc (ix+DIS) */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB06); 
  }
  else {
    DO_stmt_idx(0xFDCB06); 
  }
}

/* rlc (ix+DIS),a */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB07); 
  }
  else {
    DO_stmt_idx(0xFDCB07); 
  }
}

/* rlc (ix+DIS),b */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB00); 
  }
  else {
    DO_stmt_idx(0xFDCB00); 
  }
}

/* rlc (ix+DIS),c */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB01); 
  }
  else {
    DO_stmt_idx(0xFDCB01); 
  }
}

/* rlc (ix+DIS),d */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB02); 
  }
  else {
    DO_stmt_idx(0xFDCB02); 
  }
}

/* rlc (ix+DIS),e */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB03); 
  }
  else {
    DO_stmt_idx(0xFDCB03); 
  }
}

/* rlc (ix+DIS),h */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB04); 
  }
  else {
    DO_stmt_idx(0xFDCB04); 
  }
}

/* rlc (ix+DIS),l */
| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB05); 
  }
  else {
    DO_stmt_idx(0xFDCB05); 
  }
}

/* rlc (iy) */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0006); 
  }
  else {
    DO_stmt(0xDDCB0006); 
  }
}

/* rlc (iy),a */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0007); 
  }
  else {
    DO_stmt(0xDDCB0007); 
  }
}

/* rlc (iy),b */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0000); 
  }
  else {
    DO_stmt(0xDDCB0000); 
  }
}

/* rlc (iy),c */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0001); 
  }
  else {
    DO_stmt(0xDDCB0001); 
  }
}

/* rlc (iy),d */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0002); 
  }
  else {
    DO_stmt(0xDDCB0002); 
  }
}

/* rlc (iy),e */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0003); 
  }
  else {
    DO_stmt(0xDDCB0003); 
  }
}

/* rlc (iy),h */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0004); 
  }
  else {
    DO_stmt(0xDDCB0004); 
  }
}

/* rlc (iy),l */
| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0005); 
  }
  else {
    DO_stmt(0xDDCB0005); 
  }
}

/* rlc (iy+DIS) */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB06); 
  }
  else {
    DO_stmt_idx(0xDDCB06); 
  }
}

/* rlc (iy+DIS),a */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB07); 
  }
  else {
    DO_stmt_idx(0xDDCB07); 
  }
}

/* rlc (iy+DIS),b */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB00); 
  }
  else {
    DO_stmt_idx(0xDDCB00); 
  }
}

/* rlc (iy+DIS),c */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB01); 
  }
  else {
    DO_stmt_idx(0xDDCB01); 
  }
}

/* rlc (iy+DIS),d */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB02); 
  }
  else {
    DO_stmt_idx(0xDDCB02); 
  }
}

/* rlc (iy+DIS),e */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB03); 
  }
  else {
    DO_stmt_idx(0xDDCB03); 
  }
}

/* rlc (iy+DIS),h */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB04); 
  }
  else {
    DO_stmt_idx(0xDDCB04); 
  }
}

/* rlc (iy+DIS),l */
| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB05); 
  }
  else {
    DO_stmt_idx(0xDDCB05); 
  }
}

/* rlc l */
| label? _TK_RLC _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB05); 
}

/* rlca */
| label? _TK_RLCA _TK_NEWLINE @{
  DO_stmt(0x07); 
}

/* rld */
| label? _TK_RLD _TK_NEWLINE @{
  DO_stmt_emul(0xED6F, rcmx_rld); 
}

/* rr a */
| label? _TK_RR _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB1F); 
}

/* rr b */
| label? _TK_RR _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB18); 
}

/* rr c */
| label? _TK_RR _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB19); 
}

/* rr d */
| label? _TK_RR _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB1A); 
}

/* rr de */
| label? _TK_RR _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFB); 
}

/* rr de' */
| label? _TK_RR _TK_DE1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFB); 
}

/* rr e */
| label? _TK_RR _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB1B); 
}

/* rr h */
| label? _TK_RR _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB1C); 
}

/* rr hl */
| label? _TK_RR _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xFC); 
}

/* rr hl' */
| label? _TK_RR _TK_HL1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xFC); 
}

/* rr (hl) */
| label? _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB1E); 
}

/* rr (ix) */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001E); 
  }
  else {
    DO_stmt(0xFDCB001E); 
  }
}

/* rr (ix),a */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001F); 
  }
  else {
    DO_stmt(0xFDCB001F); 
  }
}

/* rr (ix),b */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0018); 
  }
  else {
    DO_stmt(0xFDCB0018); 
  }
}

/* rr (ix),c */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0019); 
  }
  else {
    DO_stmt(0xFDCB0019); 
  }
}

/* rr (ix),d */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001A); 
  }
  else {
    DO_stmt(0xFDCB001A); 
  }
}

/* rr (ix),e */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001B); 
  }
  else {
    DO_stmt(0xFDCB001B); 
  }
}

/* rr (ix),h */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001C); 
  }
  else {
    DO_stmt(0xFDCB001C); 
  }
}

/* rr (ix),l */
| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB001D); 
  }
  else {
    DO_stmt(0xFDCB001D); 
  }
}

/* rr (ix+DIS) */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1E); 
  }
  else {
    DO_stmt_idx(0xFDCB1E); 
  }
}

/* rr (ix+DIS),a */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1F); 
  }
  else {
    DO_stmt_idx(0xFDCB1F); 
  }
}

/* rr (ix+DIS),b */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB18); 
  }
  else {
    DO_stmt_idx(0xFDCB18); 
  }
}

/* rr (ix+DIS),c */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB19); 
  }
  else {
    DO_stmt_idx(0xFDCB19); 
  }
}

/* rr (ix+DIS),d */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1A); 
  }
  else {
    DO_stmt_idx(0xFDCB1A); 
  }
}

/* rr (ix+DIS),e */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1B); 
  }
  else {
    DO_stmt_idx(0xFDCB1B); 
  }
}

/* rr (ix+DIS),h */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1C); 
  }
  else {
    DO_stmt_idx(0xFDCB1C); 
  }
}

/* rr (ix+DIS),l */
| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB1D); 
  }
  else {
    DO_stmt_idx(0xFDCB1D); 
  }
}

/* rr (iy) */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001E); 
  }
  else {
    DO_stmt(0xDDCB001E); 
  }
}

/* rr (iy),a */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001F); 
  }
  else {
    DO_stmt(0xDDCB001F); 
  }
}

/* rr (iy),b */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0018); 
  }
  else {
    DO_stmt(0xDDCB0018); 
  }
}

/* rr (iy),c */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0019); 
  }
  else {
    DO_stmt(0xDDCB0019); 
  }
}

/* rr (iy),d */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001A); 
  }
  else {
    DO_stmt(0xDDCB001A); 
  }
}

/* rr (iy),e */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001B); 
  }
  else {
    DO_stmt(0xDDCB001B); 
  }
}

/* rr (iy),h */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001C); 
  }
  else {
    DO_stmt(0xDDCB001C); 
  }
}

/* rr (iy),l */
| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB001D); 
  }
  else {
    DO_stmt(0xDDCB001D); 
  }
}

/* rr (iy+DIS) */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1E); 
  }
  else {
    DO_stmt_idx(0xDDCB1E); 
  }
}

/* rr (iy+DIS),a */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1F); 
  }
  else {
    DO_stmt_idx(0xDDCB1F); 
  }
}

/* rr (iy+DIS),b */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB18); 
  }
  else {
    DO_stmt_idx(0xDDCB18); 
  }
}

/* rr (iy+DIS),c */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB19); 
  }
  else {
    DO_stmt_idx(0xDDCB19); 
  }
}

/* rr (iy+DIS),d */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1A); 
  }
  else {
    DO_stmt_idx(0xDDCB1A); 
  }
}

/* rr (iy+DIS),e */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1B); 
  }
  else {
    DO_stmt_idx(0xDDCB1B); 
  }
}

/* rr (iy+DIS),h */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1C); 
  }
  else {
    DO_stmt_idx(0xDDCB1C); 
  }
}

/* rr (iy+DIS),l */
| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB1D); 
  }
  else {
    DO_stmt_idx(0xDDCB1D); 
  }
}

/* rr ix */
| label? _TK_RR _TK_IX _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDFC); 
  }
  else {
    DO_stmt(0xFDFC); 
  }
}

/* rr iy */
| label? _TK_RR _TK_IY _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDFC); 
  }
  else {
    DO_stmt(0xDDFC); 
  }
}

/* rr l */
| label? _TK_RR _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB1D); 
}

/* rra */
| label? _TK_RRA _TK_NEWLINE @{
  DO_stmt(0x1F); 
}

/* rrc a */
| label? _TK_RRC _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB0F); 
}

/* rrc b */
| label? _TK_RRC _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB08); 
}

/* rrc c */
| label? _TK_RRC _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB09); 
}

/* rrc d */
| label? _TK_RRC _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB0A); 
}

/* rrc e */
| label? _TK_RRC _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB0B); 
}

/* rrc h */
| label? _TK_RRC _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB0C); 
}

/* rrc (hl) */
| label? _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB0E); 
}

/* rrc (ix) */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000E); 
  }
  else {
    DO_stmt(0xFDCB000E); 
  }
}

/* rrc (ix),a */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000F); 
  }
  else {
    DO_stmt(0xFDCB000F); 
  }
}

/* rrc (ix),b */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0008); 
  }
  else {
    DO_stmt(0xFDCB0008); 
  }
}

/* rrc (ix),c */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0009); 
  }
  else {
    DO_stmt(0xFDCB0009); 
  }
}

/* rrc (ix),d */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000A); 
  }
  else {
    DO_stmt(0xFDCB000A); 
  }
}

/* rrc (ix),e */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000B); 
  }
  else {
    DO_stmt(0xFDCB000B); 
  }
}

/* rrc (ix),h */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000C); 
  }
  else {
    DO_stmt(0xFDCB000C); 
  }
}

/* rrc (ix),l */
| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB000D); 
  }
  else {
    DO_stmt(0xFDCB000D); 
  }
}

/* rrc (ix+DIS) */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0E); 
  }
  else {
    DO_stmt_idx(0xFDCB0E); 
  }
}

/* rrc (ix+DIS),a */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0F); 
  }
  else {
    DO_stmt_idx(0xFDCB0F); 
  }
}

/* rrc (ix+DIS),b */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB08); 
  }
  else {
    DO_stmt_idx(0xFDCB08); 
  }
}

/* rrc (ix+DIS),c */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB09); 
  }
  else {
    DO_stmt_idx(0xFDCB09); 
  }
}

/* rrc (ix+DIS),d */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0A); 
  }
  else {
    DO_stmt_idx(0xFDCB0A); 
  }
}

/* rrc (ix+DIS),e */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0B); 
  }
  else {
    DO_stmt_idx(0xFDCB0B); 
  }
}

/* rrc (ix+DIS),h */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0C); 
  }
  else {
    DO_stmt_idx(0xFDCB0C); 
  }
}

/* rrc (ix+DIS),l */
| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB0D); 
  }
  else {
    DO_stmt_idx(0xFDCB0D); 
  }
}

/* rrc (iy) */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000E); 
  }
  else {
    DO_stmt(0xDDCB000E); 
  }
}

/* rrc (iy),a */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000F); 
  }
  else {
    DO_stmt(0xDDCB000F); 
  }
}

/* rrc (iy),b */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0008); 
  }
  else {
    DO_stmt(0xDDCB0008); 
  }
}

/* rrc (iy),c */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0009); 
  }
  else {
    DO_stmt(0xDDCB0009); 
  }
}

/* rrc (iy),d */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000A); 
  }
  else {
    DO_stmt(0xDDCB000A); 
  }
}

/* rrc (iy),e */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000B); 
  }
  else {
    DO_stmt(0xDDCB000B); 
  }
}

/* rrc (iy),h */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000C); 
  }
  else {
    DO_stmt(0xDDCB000C); 
  }
}

/* rrc (iy),l */
| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB000D); 
  }
  else {
    DO_stmt(0xDDCB000D); 
  }
}

/* rrc (iy+DIS) */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0E); 
  }
  else {
    DO_stmt_idx(0xDDCB0E); 
  }
}

/* rrc (iy+DIS),a */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0F); 
  }
  else {
    DO_stmt_idx(0xDDCB0F); 
  }
}

/* rrc (iy+DIS),b */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB08); 
  }
  else {
    DO_stmt_idx(0xDDCB08); 
  }
}

/* rrc (iy+DIS),c */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB09); 
  }
  else {
    DO_stmt_idx(0xDDCB09); 
  }
}

/* rrc (iy+DIS),d */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0A); 
  }
  else {
    DO_stmt_idx(0xDDCB0A); 
  }
}

/* rrc (iy+DIS),e */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0B); 
  }
  else {
    DO_stmt_idx(0xDDCB0B); 
  }
}

/* rrc (iy+DIS),h */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0C); 
  }
  else {
    DO_stmt_idx(0xDDCB0C); 
  }
}

/* rrc (iy+DIS),l */
| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB0D); 
  }
  else {
    DO_stmt_idx(0xDDCB0D); 
  }
}

/* rrc l */
| label? _TK_RRC _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB0D); 
}

/* rrca */
| label? _TK_RRCA _TK_NEWLINE @{
  DO_stmt(0x0F); 
}

/* rrd */
| label? _TK_RRD _TK_NEWLINE @{
  DO_stmt_emul(0xED67, rcmx_rrd); 
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

/* sbc a */
| label? _TK_SBC _TK_A _TK_NEWLINE @{
  DO_stmt(0x9F); 
}

/* sbc a,a */
| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x9F); 
}

/* sbc a,b */
| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x98); 
}

/* sbc a,c */
| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x99); 
}

/* sbc a,d */
| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x9A); 
}

/* sbc a,e */
| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x9B); 
}

/* sbc a,h */
| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x9C); 
}

/* sbc a,(hl) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x9E); 
}

/* sbc a,(ix) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9E00); 
  }
  else {
    DO_stmt(0xFD9E00); 
  }
}

/* sbc a,(ix+DIS) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD9E); 
  }
  else {
    DO_stmt_idx(0xFD9E); 
  }
}

/* sbc a,(iy) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9E00); 
  }
  else {
    DO_stmt(0xDD9E00); 
  }
}

/* sbc a,(iy+DIS) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD9E); 
  }
  else {
    DO_stmt_idx(0xDD9E); 
  }
}

/* sbc a,ixh */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9C); 
  }
  else {
    DO_stmt(0xFD9C); 
  }
}

/* sbc a,ixl */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9D); 
  }
  else {
    DO_stmt(0xFD9D); 
  }
}

/* sbc a,iyh */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9C); 
  }
  else {
    DO_stmt(0xDD9C); 
  }
}

/* sbc a,iyl */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9D); 
  }
  else {
    DO_stmt(0xDD9D); 
  }
}

/* sbc a,l */
| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x9D); 
}

/* sbc a,N */
| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xDE); 
}

/* sbc a',a */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9F); 
}

/* sbc a',b */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x98); 
}

/* sbc a',c */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x99); 
}

/* sbc a',d */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9A); 
}

/* sbc a',e */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9B); 
}

/* sbc a',h */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9C); 
}

/* sbc a',(hl) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9E); 
}

/* sbc a',(ix) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
}

/* sbc a',(ix+DIS) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
}

/* sbc a',(iy) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9E00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9E00); 
  }
}

/* sbc a',(iy+DIS) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD9E); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD9E); 
  }
}

/* sbc a',l */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x9D); 
}

/* sbc a',N */
| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xDE); 
}

/* sbc b */
| label? _TK_SBC _TK_B _TK_NEWLINE @{
  DO_stmt(0x98); 
}

/* sbc c */
| label? _TK_SBC _TK_C _TK_NEWLINE @{
  DO_stmt(0x99); 
}

/* sbc d */
| label? _TK_SBC _TK_D _TK_NEWLINE @{
  DO_stmt(0x9A); 
}

/* sbc e */
| label? _TK_SBC _TK_E _TK_NEWLINE @{
  DO_stmt(0x9B); 
}

/* sbc h */
| label? _TK_SBC _TK_H _TK_NEWLINE @{
  DO_stmt(0x9C); 
}

/* sbc hl,bc */
| label? _TK_SBC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
  DO_stmt(0xED42); 
}

/* sbc hl,de */
| label? _TK_SBC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
  DO_stmt(0xED52); 
}

/* sbc hl,hl */
| label? _TK_SBC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
  DO_stmt(0xED62); 
}

/* sbc hl,sp */
| label? _TK_SBC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
  DO_stmt(0xED72); 
}

/* sbc hl',bc */
| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED42); 
}

/* sbc hl',de */
| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED52); 
}

/* sbc hl',hl */
| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED62); 
}

/* sbc hl',sp */
| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xED72); 
}

/* sbc (hl) */
| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x9E); 
}

/* sbc (ix) */
| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9E00); 
  }
  else {
    DO_stmt(0xFD9E00); 
  }
}

/* sbc (ix+DIS) */
| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD9E); 
  }
  else {
    DO_stmt_idx(0xFD9E); 
  }
}

/* sbc (iy) */
| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9E00); 
  }
  else {
    DO_stmt(0xDD9E00); 
  }
}

/* sbc (iy+DIS) */
| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD9E); 
  }
  else {
    DO_stmt_idx(0xDD9E); 
  }
}

/* sbc ixh */
| label? _TK_SBC _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9C); 
  }
  else {
    DO_stmt(0xFD9C); 
  }
}

/* sbc ixl */
| label? _TK_SBC _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9D); 
  }
  else {
    DO_stmt(0xFD9D); 
  }
}

/* sbc iyh */
| label? _TK_SBC _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9C); 
  }
  else {
    DO_stmt(0xDD9C); 
  }
}

/* sbc iyl */
| label? _TK_SBC _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9D); 
  }
  else {
    DO_stmt(0xDD9D); 
  }
}

/* sbc l */
| label? _TK_SBC _TK_L _TK_NEWLINE @{
  DO_stmt(0x9D); 
}

/* sbc N */
| label? _TK_SBC expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xDE); 
}

/* scf */
| label? _TK_SCF _TK_NEWLINE @{
  DO_stmt(0x37); 
}

/* scf f */
| label? _TK_SCF _TK_F _TK_NEWLINE @{
  DO_stmt(0x37); 
}

/* scf f' */
| label? _TK_SCF _TK_F1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x37); 
}

/* set 0,a */
/* set 1,a */
/* set 2,a */
/* set 3,a */
/* set 4,a */
/* set 5,a */
/* set 6,a */
/* set 7,a */
| label? _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,a' */
/* set 1,a' */
/* set 2,a' */
/* set 3,a' */
/* set 4,a' */
/* set 5,a' */
/* set 6,a' */
/* set 7,a' */
| label? _TK_SET const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC7); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCF); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD7); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDF); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE7); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEF); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF7); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFF); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,b */
/* set 1,b */
/* set 2,b */
/* set 3,b */
/* set 4,b */
/* set 5,b */
/* set 6,b */
/* set 7,b */
| label? _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,b' */
/* set 1,b' */
/* set 2,b' */
/* set 3,b' */
/* set 4,b' */
/* set 5,b' */
/* set 6,b' */
/* set 7,b' */
| label? _TK_SET const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC0); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC8); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD0); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD8); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE0); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE8); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF0); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF8); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,c */
/* set 1,c */
/* set 2,c */
/* set 3,c */
/* set 4,c */
/* set 5,c */
/* set 6,c */
/* set 7,c */
| label? _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,c' */
/* set 1,c' */
/* set 2,c' */
/* set 3,c' */
/* set 4,c' */
/* set 5,c' */
/* set 6,c' */
/* set 7,c' */
| label? _TK_SET const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC1); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBC9); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD1); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBD9); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE1); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBE9); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF1); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBF9); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,d */
/* set 1,d */
/* set 2,d */
/* set 3,d */
/* set 4,d */
/* set 5,d */
/* set 6,d */
/* set 7,d */
| label? _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,d' */
/* set 1,d' */
/* set 2,d' */
/* set 3,d' */
/* set 4,d' */
/* set 5,d' */
/* set 6,d' */
/* set 7,d' */
| label? _TK_SET const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC2); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCA); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD2); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDA); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE2); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEA); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF2); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFA); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,e */
/* set 1,e */
/* set 2,e */
/* set 3,e */
/* set 4,e */
/* set 5,e */
/* set 6,e */
/* set 7,e */
| label? _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,e' */
/* set 1,e' */
/* set 2,e' */
/* set 3,e' */
/* set 4,e' */
/* set 5,e' */
/* set 6,e' */
/* set 7,e' */
| label? _TK_SET const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC3); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCB); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD3); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDB); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE3); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEB); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF3); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFB); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,h */
/* set 1,h */
/* set 2,h */
/* set 3,h */
/* set 4,h */
/* set 5,h */
/* set 6,h */
/* set 7,h */
| label? _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,h' */
/* set 1,h' */
/* set 2,h' */
/* set 3,h' */
/* set 4,h' */
/* set 5,h' */
/* set 6,h' */
/* set 7,h' */
| label? _TK_SET const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC4); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCC); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD4); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDC); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE4); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBEC); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF4); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFC); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,(hl) */
/* set 1,(hl) */
/* set 2,(hl) */
/* set 3,(hl) */
/* set 4,(hl) */
/* set 5,(hl) */
/* set 6,(hl) */
/* set 7,(hl) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC6); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCE); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD6); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDE); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE6); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBEE); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF6); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFE); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,(ix) */
/* set 1,(ix) */
/* set 2,(ix) */
/* set 3,(ix) */
/* set 4,(ix) */
/* set 5,(ix) */
/* set 6,(ix) */
/* set 7,(ix) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00C6); 
  }
  else {
    DO_stmt(0xFDCB00C6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00CE); 
  }
  else {
    DO_stmt(0xFDCB00CE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00D6); 
  }
  else {
    DO_stmt(0xFDCB00D6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00DE); 
  }
  else {
    DO_stmt(0xFDCB00DE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00E6); 
  }
  else {
    DO_stmt(0xFDCB00E6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00EE); 
  }
  else {
    DO_stmt(0xFDCB00EE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00F6); 
  }
  else {
    DO_stmt(0xFDCB00F6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB00FE); 
  }
  else {
    DO_stmt(0xFDCB00FE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(ix+DIS) */
/* set 1,(ix+DIS) */
/* set 2,(ix+DIS) */
/* set 3,(ix+DIS) */
/* set 4,(ix+DIS) */
/* set 5,(ix+DIS) */
/* set 6,(ix+DIS) */
/* set 7,(ix+DIS) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBC6); 
  }
  else {
    DO_stmt_idx(0xFDCBC6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBCE); 
  }
  else {
    DO_stmt_idx(0xFDCBCE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBD6); 
  }
  else {
    DO_stmt_idx(0xFDCBD6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBDE); 
  }
  else {
    DO_stmt_idx(0xFDCBDE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBE6); 
  }
  else {
    DO_stmt_idx(0xFDCBE6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBEE); 
  }
  else {
    DO_stmt_idx(0xFDCBEE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBF6); 
  }
  else {
    DO_stmt_idx(0xFDCBF6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCBFE); 
  }
  else {
    DO_stmt_idx(0xFDCBFE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(iy) */
/* set 1,(iy) */
/* set 2,(iy) */
/* set 3,(iy) */
/* set 4,(iy) */
/* set 5,(iy) */
/* set 6,(iy) */
/* set 7,(iy) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00C6); 
  }
  else {
    DO_stmt(0xDDCB00C6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00CE); 
  }
  else {
    DO_stmt(0xDDCB00CE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00D6); 
  }
  else {
    DO_stmt(0xDDCB00D6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00DE); 
  }
  else {
    DO_stmt(0xDDCB00DE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00E6); 
  }
  else {
    DO_stmt(0xDDCB00E6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00EE); 
  }
  else {
    DO_stmt(0xDDCB00EE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00F6); 
  }
  else {
    DO_stmt(0xDDCB00F6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB00FE); 
  }
  else {
    DO_stmt(0xDDCB00FE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,(iy+DIS) */
/* set 1,(iy+DIS) */
/* set 2,(iy+DIS) */
/* set 3,(iy+DIS) */
/* set 4,(iy+DIS) */
/* set 5,(iy+DIS) */
/* set 6,(iy+DIS) */
/* set 7,(iy+DIS) */
| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBC6); 
  }
  else {
    DO_stmt_idx(0xDDCBC6); 
  }
  }
  else if (expr_value == 1) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBCE); 
  }
  else {
    DO_stmt_idx(0xDDCBCE); 
  }
  }
  else if (expr_value == 2) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBD6); 
  }
  else {
    DO_stmt_idx(0xDDCBD6); 
  }
  }
  else if (expr_value == 3) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBDE); 
  }
  else {
    DO_stmt_idx(0xDDCBDE); 
  }
  }
  else if (expr_value == 4) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBE6); 
  }
  else {
    DO_stmt_idx(0xDDCBE6); 
  }
  }
  else if (expr_value == 5) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBEE); 
  }
  else {
    DO_stmt_idx(0xDDCBEE); 
  }
  }
  else if (expr_value == 6) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBF6); 
  }
  else {
    DO_stmt_idx(0xDDCBF6); 
  }
  }
  else if (expr_value == 7) {
    if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCBFE); 
  }
  else {
    DO_stmt_idx(0xDDCBFE); 
  }
  }
  else
    error_int_range(expr_value);

}

/* set 0,l */
/* set 1,l */
/* set 2,l */
/* set 3,l */
/* set 4,l */
/* set 5,l */
/* set 6,l */
/* set 7,l */
| label? _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* set 0,l' */
/* set 1,l' */
/* set 2,l' */
/* set 3,l' */
/* set 4,l' */
/* set 5,l' */
/* set 6,l' */
/* set 7,l' */
| label? _TK_SET const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_error) return FALSE;
  if (expr_value == 0) {
    DO_stmt(0x76);
      DO_stmt(0xCBC5); 
  }
  else if (expr_value == 1) {
    DO_stmt(0x76);
      DO_stmt(0xCBCD); 
  }
  else if (expr_value == 2) {
    DO_stmt(0x76);
      DO_stmt(0xCBD5); 
  }
  else if (expr_value == 3) {
    DO_stmt(0x76);
      DO_stmt(0xCBDD); 
  }
  else if (expr_value == 4) {
    DO_stmt(0x76);
      DO_stmt(0xCBE5); 
  }
  else if (expr_value == 5) {
    DO_stmt(0x76);
      DO_stmt(0xCBED); 
  }
  else if (expr_value == 6) {
    DO_stmt(0x76);
      DO_stmt(0xCBF5); 
  }
  else if (expr_value == 7) {
    DO_stmt(0x76);
      DO_stmt(0xCBFD); 
  }
  else
    error_int_range(expr_value);

}

/* setusr */
| label? _TK_SETUSR _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED6F); 
}

/* sla a */
| label? _TK_SLA _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB27); 
}

/* sla b */
| label? _TK_SLA _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB20); 
}

/* sla c */
| label? _TK_SLA _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB21); 
}

/* sla d */
| label? _TK_SLA _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB22); 
}

/* sla e */
| label? _TK_SLA _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB23); 
}

/* sla h */
| label? _TK_SLA _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB24); 
}

/* sla (hl) */
| label? _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB26); 
}

/* sla (ix) */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0026); 
  }
  else {
    DO_stmt(0xFDCB0026); 
  }
}

/* sla (ix),a */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0027); 
  }
  else {
    DO_stmt(0xFDCB0027); 
  }
}

/* sla (ix),b */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0020); 
  }
  else {
    DO_stmt(0xFDCB0020); 
  }
}

/* sla (ix),c */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0021); 
  }
  else {
    DO_stmt(0xFDCB0021); 
  }
}

/* sla (ix),d */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0022); 
  }
  else {
    DO_stmt(0xFDCB0022); 
  }
}

/* sla (ix),e */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0023); 
  }
  else {
    DO_stmt(0xFDCB0023); 
  }
}

/* sla (ix),h */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0024); 
  }
  else {
    DO_stmt(0xFDCB0024); 
  }
}

/* sla (ix),l */
| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0025); 
  }
  else {
    DO_stmt(0xFDCB0025); 
  }
}

/* sla (ix+DIS) */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB26); 
  }
  else {
    DO_stmt_idx(0xFDCB26); 
  }
}

/* sla (ix+DIS),a */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB27); 
  }
  else {
    DO_stmt_idx(0xFDCB27); 
  }
}

/* sla (ix+DIS),b */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB20); 
  }
  else {
    DO_stmt_idx(0xFDCB20); 
  }
}

/* sla (ix+DIS),c */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB21); 
  }
  else {
    DO_stmt_idx(0xFDCB21); 
  }
}

/* sla (ix+DIS),d */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB22); 
  }
  else {
    DO_stmt_idx(0xFDCB22); 
  }
}

/* sla (ix+DIS),e */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB23); 
  }
  else {
    DO_stmt_idx(0xFDCB23); 
  }
}

/* sla (ix+DIS),h */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB24); 
  }
  else {
    DO_stmt_idx(0xFDCB24); 
  }
}

/* sla (ix+DIS),l */
| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB25); 
  }
  else {
    DO_stmt_idx(0xFDCB25); 
  }
}

/* sla (iy) */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0026); 
  }
  else {
    DO_stmt(0xDDCB0026); 
  }
}

/* sla (iy),a */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0027); 
  }
  else {
    DO_stmt(0xDDCB0027); 
  }
}

/* sla (iy),b */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0020); 
  }
  else {
    DO_stmt(0xDDCB0020); 
  }
}

/* sla (iy),c */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0021); 
  }
  else {
    DO_stmt(0xDDCB0021); 
  }
}

/* sla (iy),d */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0022); 
  }
  else {
    DO_stmt(0xDDCB0022); 
  }
}

/* sla (iy),e */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0023); 
  }
  else {
    DO_stmt(0xDDCB0023); 
  }
}

/* sla (iy),h */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0024); 
  }
  else {
    DO_stmt(0xDDCB0024); 
  }
}

/* sla (iy),l */
| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0025); 
  }
  else {
    DO_stmt(0xDDCB0025); 
  }
}

/* sla (iy+DIS) */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB26); 
  }
  else {
    DO_stmt_idx(0xDDCB26); 
  }
}

/* sla (iy+DIS),a */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB27); 
  }
  else {
    DO_stmt_idx(0xDDCB27); 
  }
}

/* sla (iy+DIS),b */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB20); 
  }
  else {
    DO_stmt_idx(0xDDCB20); 
  }
}

/* sla (iy+DIS),c */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB21); 
  }
  else {
    DO_stmt_idx(0xDDCB21); 
  }
}

/* sla (iy+DIS),d */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB22); 
  }
  else {
    DO_stmt_idx(0xDDCB22); 
  }
}

/* sla (iy+DIS),e */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB23); 
  }
  else {
    DO_stmt_idx(0xDDCB23); 
  }
}

/* sla (iy+DIS),h */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB24); 
  }
  else {
    DO_stmt_idx(0xDDCB24); 
  }
}

/* sla (iy+DIS),l */
| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB25); 
  }
  else {
    DO_stmt_idx(0xDDCB25); 
  }
}

/* sla l */
| label? _TK_SLA _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB25); 
}

/* sli a */
| label? _TK_SLI _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB37); 
}

/* sli b */
| label? _TK_SLI _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB30); 
}

/* sli c */
| label? _TK_SLI _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB31); 
}

/* sli d */
| label? _TK_SLI _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB32); 
}

/* sli e */
| label? _TK_SLI _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB33); 
}

/* sli h */
| label? _TK_SLI _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB34); 
}

/* sli (hl) */
| label? _TK_SLI _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB36); 
}

/* sli (ix) */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0036); 
  }
  else {
    DO_stmt(0xFDCB0036); 
  }
}

/* sli (ix),a */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0037); 
  }
  else {
    DO_stmt(0xFDCB0037); 
  }
}

/* sli (ix),b */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0030); 
  }
  else {
    DO_stmt(0xFDCB0030); 
  }
}

/* sli (ix),c */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0031); 
  }
  else {
    DO_stmt(0xFDCB0031); 
  }
}

/* sli (ix),d */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0032); 
  }
  else {
    DO_stmt(0xFDCB0032); 
  }
}

/* sli (ix),e */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0033); 
  }
  else {
    DO_stmt(0xFDCB0033); 
  }
}

/* sli (ix),h */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0034); 
  }
  else {
    DO_stmt(0xFDCB0034); 
  }
}

/* sli (ix),l */
| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0035); 
  }
  else {
    DO_stmt(0xFDCB0035); 
  }
}

/* sli (ix+DIS) */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB36); 
  }
  else {
    DO_stmt_idx(0xFDCB36); 
  }
}

/* sli (ix+DIS),a */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB37); 
  }
  else {
    DO_stmt_idx(0xFDCB37); 
  }
}

/* sli (ix+DIS),b */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB30); 
  }
  else {
    DO_stmt_idx(0xFDCB30); 
  }
}

/* sli (ix+DIS),c */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB31); 
  }
  else {
    DO_stmt_idx(0xFDCB31); 
  }
}

/* sli (ix+DIS),d */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB32); 
  }
  else {
    DO_stmt_idx(0xFDCB32); 
  }
}

/* sli (ix+DIS),e */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB33); 
  }
  else {
    DO_stmt_idx(0xFDCB33); 
  }
}

/* sli (ix+DIS),h */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB34); 
  }
  else {
    DO_stmt_idx(0xFDCB34); 
  }
}

/* sli (ix+DIS),l */
| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB35); 
  }
  else {
    DO_stmt_idx(0xFDCB35); 
  }
}

/* sli (iy) */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0036); 
  }
  else {
    DO_stmt(0xDDCB0036); 
  }
}

/* sli (iy),a */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0037); 
  }
  else {
    DO_stmt(0xDDCB0037); 
  }
}

/* sli (iy),b */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0030); 
  }
  else {
    DO_stmt(0xDDCB0030); 
  }
}

/* sli (iy),c */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0031); 
  }
  else {
    DO_stmt(0xDDCB0031); 
  }
}

/* sli (iy),d */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0032); 
  }
  else {
    DO_stmt(0xDDCB0032); 
  }
}

/* sli (iy),e */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0033); 
  }
  else {
    DO_stmt(0xDDCB0033); 
  }
}

/* sli (iy),h */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0034); 
  }
  else {
    DO_stmt(0xDDCB0034); 
  }
}

/* sli (iy),l */
| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0035); 
  }
  else {
    DO_stmt(0xDDCB0035); 
  }
}

/* sli (iy+DIS) */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB36); 
  }
  else {
    DO_stmt_idx(0xDDCB36); 
  }
}

/* sli (iy+DIS),a */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB37); 
  }
  else {
    DO_stmt_idx(0xDDCB37); 
  }
}

/* sli (iy+DIS),b */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB30); 
  }
  else {
    DO_stmt_idx(0xDDCB30); 
  }
}

/* sli (iy+DIS),c */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB31); 
  }
  else {
    DO_stmt_idx(0xDDCB31); 
  }
}

/* sli (iy+DIS),d */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB32); 
  }
  else {
    DO_stmt_idx(0xDDCB32); 
  }
}

/* sli (iy+DIS),e */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB33); 
  }
  else {
    DO_stmt_idx(0xDDCB33); 
  }
}

/* sli (iy+DIS),h */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB34); 
  }
  else {
    DO_stmt_idx(0xDDCB34); 
  }
}

/* sli (iy+DIS),l */
| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB35); 
  }
  else {
    DO_stmt_idx(0xDDCB35); 
  }
}

/* sli l */
| label? _TK_SLI _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB35); 
}

/* sll a */
| label? _TK_SLL _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB37); 
}

/* sll b */
| label? _TK_SLL _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB30); 
}

/* sll c */
| label? _TK_SLL _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB31); 
}

/* sll d */
| label? _TK_SLL _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB32); 
}

/* sll e */
| label? _TK_SLL _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB33); 
}

/* sll h */
| label? _TK_SLL _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB34); 
}

/* sll (hl) */
| label? _TK_SLL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB36); 
}

/* sll (ix) */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0036); 
  }
  else {
    DO_stmt(0xFDCB0036); 
  }
}

/* sll (ix),a */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0037); 
  }
  else {
    DO_stmt(0xFDCB0037); 
  }
}

/* sll (ix),b */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0030); 
  }
  else {
    DO_stmt(0xFDCB0030); 
  }
}

/* sll (ix),c */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0031); 
  }
  else {
    DO_stmt(0xFDCB0031); 
  }
}

/* sll (ix),d */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0032); 
  }
  else {
    DO_stmt(0xFDCB0032); 
  }
}

/* sll (ix),e */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0033); 
  }
  else {
    DO_stmt(0xFDCB0033); 
  }
}

/* sll (ix),h */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0034); 
  }
  else {
    DO_stmt(0xFDCB0034); 
  }
}

/* sll (ix),l */
| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0035); 
  }
  else {
    DO_stmt(0xFDCB0035); 
  }
}

/* sll (ix+DIS) */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB36); 
  }
  else {
    DO_stmt_idx(0xFDCB36); 
  }
}

/* sll (ix+DIS),a */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB37); 
  }
  else {
    DO_stmt_idx(0xFDCB37); 
  }
}

/* sll (ix+DIS),b */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB30); 
  }
  else {
    DO_stmt_idx(0xFDCB30); 
  }
}

/* sll (ix+DIS),c */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB31); 
  }
  else {
    DO_stmt_idx(0xFDCB31); 
  }
}

/* sll (ix+DIS),d */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB32); 
  }
  else {
    DO_stmt_idx(0xFDCB32); 
  }
}

/* sll (ix+DIS),e */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB33); 
  }
  else {
    DO_stmt_idx(0xFDCB33); 
  }
}

/* sll (ix+DIS),h */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB34); 
  }
  else {
    DO_stmt_idx(0xFDCB34); 
  }
}

/* sll (ix+DIS),l */
| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB35); 
  }
  else {
    DO_stmt_idx(0xFDCB35); 
  }
}

/* sll (iy) */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0036); 
  }
  else {
    DO_stmt(0xDDCB0036); 
  }
}

/* sll (iy),a */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0037); 
  }
  else {
    DO_stmt(0xDDCB0037); 
  }
}

/* sll (iy),b */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0030); 
  }
  else {
    DO_stmt(0xDDCB0030); 
  }
}

/* sll (iy),c */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0031); 
  }
  else {
    DO_stmt(0xDDCB0031); 
  }
}

/* sll (iy),d */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0032); 
  }
  else {
    DO_stmt(0xDDCB0032); 
  }
}

/* sll (iy),e */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0033); 
  }
  else {
    DO_stmt(0xDDCB0033); 
  }
}

/* sll (iy),h */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0034); 
  }
  else {
    DO_stmt(0xDDCB0034); 
  }
}

/* sll (iy),l */
| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0035); 
  }
  else {
    DO_stmt(0xDDCB0035); 
  }
}

/* sll (iy+DIS) */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB36); 
  }
  else {
    DO_stmt_idx(0xDDCB36); 
  }
}

/* sll (iy+DIS),a */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB37); 
  }
  else {
    DO_stmt_idx(0xDDCB37); 
  }
}

/* sll (iy+DIS),b */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB30); 
  }
  else {
    DO_stmt_idx(0xDDCB30); 
  }
}

/* sll (iy+DIS),c */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB31); 
  }
  else {
    DO_stmt_idx(0xDDCB31); 
  }
}

/* sll (iy+DIS),d */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB32); 
  }
  else {
    DO_stmt_idx(0xDDCB32); 
  }
}

/* sll (iy+DIS),e */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB33); 
  }
  else {
    DO_stmt_idx(0xDDCB33); 
  }
}

/* sll (iy+DIS),h */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB34); 
  }
  else {
    DO_stmt_idx(0xDDCB34); 
  }
}

/* sll (iy+DIS),l */
| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB35); 
  }
  else {
    DO_stmt_idx(0xDDCB35); 
  }
}

/* sll l */
| label? _TK_SLL _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xCB35); 
}

/* slp */
| label? _TK_SLP _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED76); 
}

/* sra a */
| label? _TK_SRA _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB2F); 
}

/* sra b */
| label? _TK_SRA _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB28); 
}

/* sra c */
| label? _TK_SRA _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB29); 
}

/* sra d */
| label? _TK_SRA _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB2A); 
}

/* sra e */
| label? _TK_SRA _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB2B); 
}

/* sra h */
| label? _TK_SRA _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB2C); 
}

/* sra (hl) */
| label? _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB2E); 
}

/* sra (ix) */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002E); 
  }
  else {
    DO_stmt(0xFDCB002E); 
  }
}

/* sra (ix),a */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002F); 
  }
  else {
    DO_stmt(0xFDCB002F); 
  }
}

/* sra (ix),b */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0028); 
  }
  else {
    DO_stmt(0xFDCB0028); 
  }
}

/* sra (ix),c */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0029); 
  }
  else {
    DO_stmt(0xFDCB0029); 
  }
}

/* sra (ix),d */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002A); 
  }
  else {
    DO_stmt(0xFDCB002A); 
  }
}

/* sra (ix),e */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002B); 
  }
  else {
    DO_stmt(0xFDCB002B); 
  }
}

/* sra (ix),h */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002C); 
  }
  else {
    DO_stmt(0xFDCB002C); 
  }
}

/* sra (ix),l */
| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB002D); 
  }
  else {
    DO_stmt(0xFDCB002D); 
  }
}

/* sra (ix+DIS) */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2E); 
  }
  else {
    DO_stmt_idx(0xFDCB2E); 
  }
}

/* sra (ix+DIS),a */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2F); 
  }
  else {
    DO_stmt_idx(0xFDCB2F); 
  }
}

/* sra (ix+DIS),b */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB28); 
  }
  else {
    DO_stmt_idx(0xFDCB28); 
  }
}

/* sra (ix+DIS),c */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB29); 
  }
  else {
    DO_stmt_idx(0xFDCB29); 
  }
}

/* sra (ix+DIS),d */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2A); 
  }
  else {
    DO_stmt_idx(0xFDCB2A); 
  }
}

/* sra (ix+DIS),e */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2B); 
  }
  else {
    DO_stmt_idx(0xFDCB2B); 
  }
}

/* sra (ix+DIS),h */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2C); 
  }
  else {
    DO_stmt_idx(0xFDCB2C); 
  }
}

/* sra (ix+DIS),l */
| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB2D); 
  }
  else {
    DO_stmt_idx(0xFDCB2D); 
  }
}

/* sra (iy) */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002E); 
  }
  else {
    DO_stmt(0xDDCB002E); 
  }
}

/* sra (iy),a */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002F); 
  }
  else {
    DO_stmt(0xDDCB002F); 
  }
}

/* sra (iy),b */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0028); 
  }
  else {
    DO_stmt(0xDDCB0028); 
  }
}

/* sra (iy),c */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0029); 
  }
  else {
    DO_stmt(0xDDCB0029); 
  }
}

/* sra (iy),d */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002A); 
  }
  else {
    DO_stmt(0xDDCB002A); 
  }
}

/* sra (iy),e */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002B); 
  }
  else {
    DO_stmt(0xDDCB002B); 
  }
}

/* sra (iy),h */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002C); 
  }
  else {
    DO_stmt(0xDDCB002C); 
  }
}

/* sra (iy),l */
| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB002D); 
  }
  else {
    DO_stmt(0xDDCB002D); 
  }
}

/* sra (iy+DIS) */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2E); 
  }
  else {
    DO_stmt_idx(0xDDCB2E); 
  }
}

/* sra (iy+DIS),a */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2F); 
  }
  else {
    DO_stmt_idx(0xDDCB2F); 
  }
}

/* sra (iy+DIS),b */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB28); 
  }
  else {
    DO_stmt_idx(0xDDCB28); 
  }
}

/* sra (iy+DIS),c */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB29); 
  }
  else {
    DO_stmt_idx(0xDDCB29); 
  }
}

/* sra (iy+DIS),d */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2A); 
  }
  else {
    DO_stmt_idx(0xDDCB2A); 
  }
}

/* sra (iy+DIS),e */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2B); 
  }
  else {
    DO_stmt_idx(0xDDCB2B); 
  }
}

/* sra (iy+DIS),h */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2C); 
  }
  else {
    DO_stmt_idx(0xDDCB2C); 
  }
}

/* sra (iy+DIS),l */
| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB2D); 
  }
  else {
    DO_stmt_idx(0xDDCB2D); 
  }
}

/* sra l */
| label? _TK_SRA _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB2D); 
}

/* srl a */
| label? _TK_SRL _TK_A _TK_NEWLINE @{
  DO_stmt(0xCB3F); 
}

/* srl b */
| label? _TK_SRL _TK_B _TK_NEWLINE @{
  DO_stmt(0xCB38); 
}

/* srl c */
| label? _TK_SRL _TK_C _TK_NEWLINE @{
  DO_stmt(0xCB39); 
}

/* srl d */
| label? _TK_SRL _TK_D _TK_NEWLINE @{
  DO_stmt(0xCB3A); 
}

/* srl e */
| label? _TK_SRL _TK_E _TK_NEWLINE @{
  DO_stmt(0xCB3B); 
}

/* srl h */
| label? _TK_SRL _TK_H _TK_NEWLINE @{
  DO_stmt(0xCB3C); 
}

/* srl (hl) */
| label? _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xCB3E); 
}

/* srl (ix) */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003E); 
  }
  else {
    DO_stmt(0xFDCB003E); 
  }
}

/* srl (ix),a */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003F); 
  }
  else {
    DO_stmt(0xFDCB003F); 
  }
}

/* srl (ix),b */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0038); 
  }
  else {
    DO_stmt(0xFDCB0038); 
  }
}

/* srl (ix),c */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB0039); 
  }
  else {
    DO_stmt(0xFDCB0039); 
  }
}

/* srl (ix),d */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003A); 
  }
  else {
    DO_stmt(0xFDCB003A); 
  }
}

/* srl (ix),e */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003B); 
  }
  else {
    DO_stmt(0xFDCB003B); 
  }
}

/* srl (ix),h */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003C); 
  }
  else {
    DO_stmt(0xFDCB003C); 
  }
}

/* srl (ix),l */
| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDCB003D); 
  }
  else {
    DO_stmt(0xFDCB003D); 
  }
}

/* srl (ix+DIS) */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3E); 
  }
  else {
    DO_stmt_idx(0xFDCB3E); 
  }
}

/* srl (ix+DIS),a */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3F); 
  }
  else {
    DO_stmt_idx(0xFDCB3F); 
  }
}

/* srl (ix+DIS),b */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB38); 
  }
  else {
    DO_stmt_idx(0xFDCB38); 
  }
}

/* srl (ix+DIS),c */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB39); 
  }
  else {
    DO_stmt_idx(0xFDCB39); 
  }
}

/* srl (ix+DIS),d */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3A); 
  }
  else {
    DO_stmt_idx(0xFDCB3A); 
  }
}

/* srl (ix+DIS),e */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3B); 
  }
  else {
    DO_stmt_idx(0xFDCB3B); 
  }
}

/* srl (ix+DIS),h */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3C); 
  }
  else {
    DO_stmt_idx(0xFDCB3C); 
  }
}

/* srl (ix+DIS),l */
| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDCB3D); 
  }
  else {
    DO_stmt_idx(0xFDCB3D); 
  }
}

/* srl (iy) */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003E); 
  }
  else {
    DO_stmt(0xDDCB003E); 
  }
}

/* srl (iy),a */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003F); 
  }
  else {
    DO_stmt(0xDDCB003F); 
  }
}

/* srl (iy),b */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0038); 
  }
  else {
    DO_stmt(0xDDCB0038); 
  }
}

/* srl (iy),c */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB0039); 
  }
  else {
    DO_stmt(0xDDCB0039); 
  }
}

/* srl (iy),d */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003A); 
  }
  else {
    DO_stmt(0xDDCB003A); 
  }
}

/* srl (iy),e */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003B); 
  }
  else {
    DO_stmt(0xDDCB003B); 
  }
}

/* srl (iy),h */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003C); 
  }
  else {
    DO_stmt(0xDDCB003C); 
  }
}

/* srl (iy),l */
| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDCB003D); 
  }
  else {
    DO_stmt(0xDDCB003D); 
  }
}

/* srl (iy+DIS) */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3E); 
  }
  else {
    DO_stmt_idx(0xDDCB3E); 
  }
}

/* srl (iy+DIS),a */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3F); 
  }
  else {
    DO_stmt_idx(0xDDCB3F); 
  }
}

/* srl (iy+DIS),b */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB38); 
  }
  else {
    DO_stmt_idx(0xDDCB38); 
  }
}

/* srl (iy+DIS),c */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB39); 
  }
  else {
    DO_stmt_idx(0xDDCB39); 
  }
}

/* srl (iy+DIS),d */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3A); 
  }
  else {
    DO_stmt_idx(0xDDCB3A); 
  }
}

/* srl (iy+DIS),e */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3B); 
  }
  else {
    DO_stmt_idx(0xDDCB3B); 
  }
}

/* srl (iy+DIS),h */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3C); 
  }
  else {
    DO_stmt_idx(0xDDCB3C); 
  }
}

/* srl (iy+DIS),l */
| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDCB3D); 
  }
  else {
    DO_stmt_idx(0xDDCB3D); 
  }
}

/* srl l */
| label? _TK_SRL _TK_L _TK_NEWLINE @{
  DO_stmt(0xCB3D); 
}

/* sub a */
| label? _TK_SUB _TK_A _TK_NEWLINE @{
  DO_stmt(0x97); 
}

/* sub a,a */
| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0x97); 
}

/* sub a,b */
| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0x90); 
}

/* sub a,c */
| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0x91); 
}

/* sub a,d */
| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0x92); 
}

/* sub a,e */
| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0x93); 
}

/* sub a,h */
| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x94); 
}

/* sub a,(hl) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x96); 
}

/* sub a,(ix) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9600); 
  }
  else {
    DO_stmt(0xFD9600); 
  }
}

/* sub a,(ix+DIS) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD96); 
  }
  else {
    DO_stmt_idx(0xFD96); 
  }
}

/* sub a,(iy) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9600); 
  }
  else {
    DO_stmt(0xDD9600); 
  }
}

/* sub a,(iy+DIS) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD96); 
  }
  else {
    DO_stmt_idx(0xDD96); 
  }
}

/* sub a,ixh */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD94); 
  }
  else {
    DO_stmt(0xFD94); 
  }
}

/* sub a,ixl */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD95); 
  }
  else {
    DO_stmt(0xFD95); 
  }
}

/* sub a,iyh */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD94); 
  }
  else {
    DO_stmt(0xDD94); 
  }
}

/* sub a,iyl */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD95); 
  }
  else {
    DO_stmt(0xDD95); 
  }
}

/* sub a,l */
| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0x95); 
}

/* sub a,N */
| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xD6); 
}

/* sub a',a */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x97); 
}

/* sub a',b */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x90); 
}

/* sub a',c */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x91); 
}

/* sub a',d */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x92); 
}

/* sub a',e */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x93); 
}

/* sub a',h */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x94); 
}

/* sub a',(hl) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x96); 
}

/* sub a',(ix) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
}

/* sub a',(ix+DIS) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
}

/* sub a',(iy) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFD9600); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDD9600); 
  }
}

/* sub a',(iy+DIS) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFD96); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDD96); 
  }
}

/* sub a',l */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0x95); 
}

/* sub a',N */
| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xD6); 
}

/* sub b */
| label? _TK_SUB _TK_B _TK_NEWLINE @{
  DO_stmt(0x90); 
}

/* sub c */
| label? _TK_SUB _TK_C _TK_NEWLINE @{
  DO_stmt(0x91); 
}

/* sub d */
| label? _TK_SUB _TK_D _TK_NEWLINE @{
  DO_stmt(0x92); 
}

/* sub e */
| label? _TK_SUB _TK_E _TK_NEWLINE @{
  DO_stmt(0x93); 
}

/* sub h */
| label? _TK_SUB _TK_H _TK_NEWLINE @{
  DO_stmt(0x94); 
}

/* sub (hl) */
| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0x96); 
}

/* sub (ix) */
| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD9600); 
  }
  else {
    DO_stmt(0xFD9600); 
  }
}

/* sub (ix+DIS) */
| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDD96); 
  }
  else {
    DO_stmt_idx(0xFD96); 
  }
}

/* sub (iy) */
| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD9600); 
  }
  else {
    DO_stmt(0xDD9600); 
  }
}

/* sub (iy+DIS) */
| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFD96); 
  }
  else {
    DO_stmt_idx(0xDD96); 
  }
}

/* sub ixh */
| label? _TK_SUB _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD94); 
  }
  else {
    DO_stmt(0xFD94); 
  }
}

/* sub ixl */
| label? _TK_SUB _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDD95); 
  }
  else {
    DO_stmt(0xFD95); 
  }
}

/* sub iyh */
| label? _TK_SUB _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD94); 
  }
  else {
    DO_stmt(0xDD94); 
  }
}

/* sub iyl */
| label? _TK_SUB _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFD95); 
  }
  else {
    DO_stmt(0xDD95); 
  }
}

/* sub l */
| label? _TK_SUB _TK_L _TK_NEWLINE @{
  DO_stmt(0x95); 
}

/* sub N */
| label? _TK_SUB expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xD6); 
}

/* sures */
| label? _TK_SURES _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED7D); 
}

/* syscall */
| label? _TK_SYSCALL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED75); 
}

/* tst a */
| label? _TK_TST _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED3C); 
}

/* tst a,a */
| label? _TK_TST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED3C); 
}

/* tst a,b */
| label? _TK_TST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED04); 
}

/* tst a,c */
| label? _TK_TST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED0C); 
}

/* tst a,d */
| label? _TK_TST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED14); 
}

/* tst a,e */
| label? _TK_TST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED1C); 
}

/* tst a,h */
| label? _TK_TST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED24); 
}

/* tst a,(hl) */
| label? _TK_TST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED34); 
}

/* tst a,l */
| label? _TK_TST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED2C); 
}

/* tst a,N */
| label? _TK_TST _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED64); 
}

/* tst b */
| label? _TK_TST _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED04); 
}

/* tst c */
| label? _TK_TST _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED0C); 
}

/* tst d */
| label? _TK_TST _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED14); 
}

/* tst e */
| label? _TK_TST _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED1C); 
}

/* tst h */
| label? _TK_TST _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED24); 
}

/* tst (hl) */
| label? _TK_TST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED34); 
}

/* tst l */
| label? _TK_TST _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xED2C); 
}

/* tst N */
| label? _TK_TST expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_NOT_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED64); 
}

/* tstio N */
| label? _TK_TSTIO expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z180)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xED74); 
}

/* uma */
| label? _TK_UMA _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDC0); 
}

/* ums */
| label? _TK_UMS _TK_NEWLINE @{
  if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0xEDC8); 
}

/* xor a */
| label? _TK_XOR _TK_A _TK_NEWLINE @{
  DO_stmt(0xAF); 
}

/* xor a,a */
| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
  DO_stmt(0xAF); 
}

/* xor a,b */
| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
  DO_stmt(0xA8); 
}

/* xor a,c */
| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
  DO_stmt(0xA9); 
}

/* xor a,d */
| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
  DO_stmt(0xAA); 
}

/* xor a,e */
| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
  DO_stmt(0xAB); 
}

/* xor a,h */
| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0xAC); 
}

/* xor a,(hl) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xAE); 
}

/* xor a,(ix) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAE00); 
  }
  else {
    DO_stmt(0xFDAE00); 
  }
}

/* xor a,(ix+DIS) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDAE); 
  }
  else {
    DO_stmt_idx(0xFDAE); 
  }
}

/* xor a,(iy) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAE00); 
  }
  else {
    DO_stmt(0xDDAE00); 
  }
}

/* xor a,(iy+DIS) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDAE); 
  }
  else {
    DO_stmt_idx(0xDDAE); 
  }
}

/* xor a,ixh */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAC); 
  }
  else {
    DO_stmt(0xFDAC); 
  }
}

/* xor a,ixl */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAD); 
  }
  else {
    DO_stmt(0xFDAD); 
  }
}

/* xor a,iyh */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAC); 
  }
  else {
    DO_stmt(0xDDAC); 
  }
}

/* xor a,iyl */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAD); 
  }
  else {
    DO_stmt(0xDDAD); 
  }
}

/* xor a,l */
| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
  DO_stmt(0xAD); 
}

/* xor a,N */
| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xEE); 
}

/* xor a',a */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAF); 
}

/* xor a',b */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA8); 
}

/* xor a',c */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xA9); 
}

/* xor a',d */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAA); 
}

/* xor a',e */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAB); 
}

/* xor a',h */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAC); 
}

/* xor a',(hl) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAE); 
}

/* xor a',(ix) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
}

/* xor a',(ix+DIS) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
}

/* xor a',(iy) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt(0xFDAE00); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt(0xDDAE00); 
  }
}

/* xor a',(iy+DIS) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0x76);
      DO_stmt_idx(0xFDAE); 
  }
  else {
    DO_stmt(0x76);
      DO_stmt_idx(0xDDAE); 
  }
}

/* xor a',l */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
    DO_stmt(0xAD); 
}

/* xor a',N */
| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt(0x76);
    DO_stmt_n(0xEE); 
}

/* xor b */
| label? _TK_XOR _TK_B _TK_NEWLINE @{
  DO_stmt(0xA8); 
}

/* xor c */
| label? _TK_XOR _TK_C _TK_NEWLINE @{
  DO_stmt(0xA9); 
}

/* xor d */
| label? _TK_XOR _TK_D _TK_NEWLINE @{
  DO_stmt(0xAA); 
}

/* xor e */
| label? _TK_XOR _TK_E _TK_NEWLINE @{
  DO_stmt(0xAB); 
}

/* xor h */
| label? _TK_XOR _TK_H _TK_NEWLINE @{
  DO_stmt(0xAC); 
}

/* xor (hl) */
| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
  DO_stmt(0xAE); 
}

/* xor (ix) */
| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAE00); 
  }
  else {
    DO_stmt(0xFDAE00); 
  }
}

/* xor (ix+DIS) */
| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xDDAE); 
  }
  else {
    DO_stmt_idx(0xFDAE); 
  }
}

/* xor (iy) */
| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAE00); 
  }
  else {
    DO_stmt(0xDDAE00); 
  }
}

/* xor (iy+DIS) */
| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
  if (!opts.swap_ix_iy) {
    DO_stmt_idx(0xFDAE); 
  }
  else {
    DO_stmt_idx(0xDDAE); 
  }
}

/* xor ixh */
| label? _TK_XOR _TK_IXH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAC); 
  }
  else {
    DO_stmt(0xFDAC); 
  }
}

/* xor ixl */
| label? _TK_XOR _TK_IXL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xDDAD); 
  }
  else {
    DO_stmt(0xFDAD); 
  }
}

/* xor iyh */
| label? _TK_XOR _TK_IYH _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAC); 
  }
  else {
    DO_stmt(0xDDAC); 
  }
}

/* xor iyl */
| label? _TK_XOR _TK_IYL _TK_NEWLINE @{
  if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; }
  if (!opts.swap_ix_iy) {
    DO_stmt(0xFDAD); 
  }
  else {
    DO_stmt(0xDDAD); 
  }
}

/* xor l */
| label? _TK_XOR _TK_L _TK_NEWLINE @{
  DO_stmt(0xAD); 
}

/* xor N */
| label? _TK_XOR expr _TK_NEWLINE @{
  if (expr_in_parens) warn_expr_in_parens();
  DO_stmt_n(0xEE); 
}

