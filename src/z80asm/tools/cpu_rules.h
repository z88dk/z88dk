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

/* altd ld a,h */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
  DO_stmt(0x7C); 
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

/* ld a,h */
| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
  DO_stmt(0x7C); 
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

/* ld a',h */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
  if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; }
  DO_stmt(0x76);
  DO_stmt(0x7C); 
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

