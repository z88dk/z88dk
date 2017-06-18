/* ld b, b */
| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x40); 
}

/* altd ld b, b */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x40); 
}

/* ld b', b */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x40); 
}

/* ld b, c */
| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x41); 
}

/* altd ld b, c */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x41); 
}

/* ld b', c */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x41); 
}

/* ld b, d */
| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x42); 
}

/* altd ld b, d */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x42); 
}

/* ld b', d */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x42); 
}

/* ld b, e */
| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x43); 
}

/* altd ld b, e */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x43); 
}

/* ld b', e */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x43); 
}

/* ld b, h */
| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x44); 
}

/* altd ld b, h */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x44); 
}

/* ld b', h */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x44); 
}

/* ld b, ixh */
| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x44); 
}

/* ld b, iyh */
| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x44); 
}

/* ld b, l */
| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x45); 
}

/* altd ld b, l */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x45); 
}

/* ld b', l */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x45); 
}

/* ld b, ixl */
| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x45); 
}

/* ld b, iyl */
| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x45); 
}

/* ld b, a */
| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x47); 
}

/* altd ld b, a */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x47); 
}

/* ld b', a */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x47); 
}

/* ld b,  42  */
/* ld b, (42) */
| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x06); 
}

/* altd ld b,  42  */
/* altd ld b, (42) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x06); 
}

/* ld b',  42  */
/* ld b', (42) */
| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x06); 
}

/* ld b, (hl) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x46); 
}

/* altd ld b, (hl) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x46); 
}

/* ld b', (hl) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x46); 
}

/* ld b, (ix) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46) << 8); 
}

/* altd ld b, (ix) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46) << 8); 
}

/* ld b', (ix) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46) << 8); 
}

/* ld b, (ix + 127) */
/* ld b, (ix - 128) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46); 
}

/* altd ld b, (ix + 127) */
/* altd ld b, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46); 
}

/* ld b', (ix + 127) */
/* ld b', (ix - 128) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x46); 
}

/* ld b, (iy) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46) << 8); 
}

/* altd ld b, (iy) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46) << 8); 
}

/* ld b', (iy) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46) << 8); 
}

/* ld b, (iy + 127) */
/* ld b, (iy - 128) */
| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46); 
}

/* altd ld b, (iy + 127) */
/* altd ld b, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46); 
}

/* ld b', (iy + 127) */
/* ld b', (iy - 128) */
| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x46); 
}

/* ld (hl), b */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x70); 
}

/* ld (ix), b */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x70) << 8); 
}

/* ld (ix + 127), b */
/* ld (ix - 128), b */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x70); 
}

/* ld (iy), b */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x70) << 8); 
}

/* ld (iy + 127), b */
/* ld (iy - 128), b */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x70); 
}

/* ld c, b */
| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x48); 
}

/* altd ld c, b */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x48); 
}

/* ld c', b */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x48); 
}

/* ld c, c */
| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x49); 
}

/* altd ld c, c */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x49); 
}

/* ld c', c */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x49); 
}

/* ld c, d */
| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x4A); 
}

/* altd ld c, d */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4A); 
}

/* ld c', d */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4A); 
}

/* ld c, e */
| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x4B); 
}

/* altd ld c, e */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4B); 
}

/* ld c', e */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4B); 
}

/* ld c, h */
| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x4C); 
}

/* altd ld c, h */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4C); 
}

/* ld c', h */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4C); 
}

/* ld c, ixh */
| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4C); 
}

/* ld c, iyh */
| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4C); 
}

/* ld c, l */
| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x4D); 
}

/* altd ld c, l */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4D); 
}

/* ld c', l */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4D); 
}

/* ld c, ixl */
| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4D); 
}

/* ld c, iyl */
| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4D); 
}

/* ld c, a */
| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x4F); 
}

/* altd ld c, a */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4F); 
}

/* ld c', a */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4F); 
}

/* ld c,  42  */
/* ld c, (42) */
| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x0E); 
}

/* altd ld c,  42  */
/* altd ld c, (42) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x0E); 
}

/* ld c',  42  */
/* ld c', (42) */
| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x0E); 
}

/* ld c, (hl) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x4E); 
}

/* altd ld c, (hl) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4E); 
}

/* ld c', (hl) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x4E); 
}

/* ld c, (ix) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E) << 8); 
}

/* altd ld c, (ix) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E) << 8); 
}

/* ld c', (ix) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E) << 8); 
}

/* ld c, (ix + 127) */
/* ld c, (ix - 128) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E); 
}

/* altd ld c, (ix + 127) */
/* altd ld c, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E); 
}

/* ld c', (ix + 127) */
/* ld c', (ix - 128) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x4E); 
}

/* ld c, (iy) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E) << 8); 
}

/* altd ld c, (iy) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E) << 8); 
}

/* ld c', (iy) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E) << 8); 
}

/* ld c, (iy + 127) */
/* ld c, (iy - 128) */
| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E); 
}

/* altd ld c, (iy + 127) */
/* altd ld c, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E); 
}

/* ld c', (iy + 127) */
/* ld c', (iy - 128) */
| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x4E); 
}

/* ld (hl), c */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x71); 
}

/* ld (ix), c */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x71) << 8); 
}

/* ld (ix + 127), c */
/* ld (ix - 128), c */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x71); 
}

/* ld (iy), c */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x71) << 8); 
}

/* ld (iy + 127), c */
/* ld (iy - 128), c */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x71); 
}

/* ld d, b */
| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x50); 
}

/* altd ld d, b */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x50); 
}

/* ld d', b */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x50); 
}

/* ld d, c */
| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x51); 
}

/* altd ld d, c */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x51); 
}

/* ld d', c */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x51); 
}

/* ld d, d */
| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x52); 
}

/* altd ld d, d */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x52); 
}

/* ld d', d */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x52); 
}

/* ld d, e */
| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x53); 
}

/* altd ld d, e */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x53); 
}

/* ld d', e */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x53); 
}

/* ld d, h */
| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x54); 
}

/* altd ld d, h */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x54); 
}

/* ld d', h */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x54); 
}

/* ld d, ixh */
| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x54); 
}

/* ld d, iyh */
| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x54); 
}

/* ld d, l */
| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x55); 
}

/* altd ld d, l */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x55); 
}

/* ld d', l */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x55); 
}

/* ld d, ixl */
| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x55); 
}

/* ld d, iyl */
| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x55); 
}

/* ld d, a */
| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x57); 
}

/* altd ld d, a */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x57); 
}

/* ld d', a */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x57); 
}

/* ld d,  42  */
/* ld d, (42) */
| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x16); 
}

/* altd ld d,  42  */
/* altd ld d, (42) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x16); 
}

/* ld d',  42  */
/* ld d', (42) */
| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x16); 
}

/* ld d, (hl) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x56); 
}

/* altd ld d, (hl) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x56); 
}

/* ld d', (hl) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x56); 
}

/* ld d, (ix) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56) << 8); 
}

/* altd ld d, (ix) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56) << 8); 
}

/* ld d', (ix) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56) << 8); 
}

/* ld d, (ix + 127) */
/* ld d, (ix - 128) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56); 
}

/* altd ld d, (ix + 127) */
/* altd ld d, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56); 
}

/* ld d', (ix + 127) */
/* ld d', (ix - 128) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x56); 
}

/* ld d, (iy) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56) << 8); 
}

/* altd ld d, (iy) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56) << 8); 
}

/* ld d', (iy) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56) << 8); 
}

/* ld d, (iy + 127) */
/* ld d, (iy - 128) */
| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56); 
}

/* altd ld d, (iy + 127) */
/* altd ld d, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56); 
}

/* ld d', (iy + 127) */
/* ld d', (iy - 128) */
| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x56); 
}

/* ld (hl), d */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x72); 
}

/* ld (ix), d */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x72) << 8); 
}

/* ld (ix + 127), d */
/* ld (ix - 128), d */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x72); 
}

/* ld (iy), d */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x72) << 8); 
}

/* ld (iy + 127), d */
/* ld (iy - 128), d */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x72); 
}

/* ld e, b */
| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x58); 
}

/* altd ld e, b */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x58); 
}

/* ld e', b */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x58); 
}

/* ld e, c */
| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x59); 
}

/* altd ld e, c */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x59); 
}

/* ld e', c */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x59); 
}

/* ld e, d */
| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x5A); 
}

/* altd ld e, d */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5A); 
}

/* ld e', d */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5A); 
}

/* ld e, e */
| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x5B); 
}

/* altd ld e, e */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5B); 
}

/* ld e', e */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5B); 
}

/* ld e, h */
| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x5C); 
}

/* altd ld e, h */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5C); 
}

/* ld e', h */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5C); 
}

/* ld e, ixh */
| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5C); 
}

/* ld e, iyh */
| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5C); 
}

/* ld e, l */
| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x5D); 
}

/* altd ld e, l */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5D); 
}

/* ld e', l */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5D); 
}

/* ld e, ixl */
| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5D); 
}

/* ld e, iyl */
| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5D); 
}

/* ld e, a */
| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x5F); 
}

/* altd ld e, a */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5F); 
}

/* ld e', a */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5F); 
}

/* ld e,  42  */
/* ld e, (42) */
| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x1E); 
}

/* altd ld e,  42  */
/* altd ld e, (42) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x1E); 
}

/* ld e',  42  */
/* ld e', (42) */
| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x1E); 
}

/* ld e, (hl) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x5E); 
}

/* altd ld e, (hl) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5E); 
}

/* ld e', (hl) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x5E); 
}

/* ld e, (ix) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E) << 8); 
}

/* altd ld e, (ix) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E) << 8); 
}

/* ld e', (ix) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E) << 8); 
}

/* ld e, (ix + 127) */
/* ld e, (ix - 128) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E); 
}

/* altd ld e, (ix + 127) */
/* altd ld e, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E); 
}

/* ld e', (ix + 127) */
/* ld e', (ix - 128) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x5E); 
}

/* ld e, (iy) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E) << 8); 
}

/* altd ld e, (iy) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E) << 8); 
}

/* ld e', (iy) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E) << 8); 
}

/* ld e, (iy + 127) */
/* ld e, (iy - 128) */
| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E); 
}

/* altd ld e, (iy + 127) */
/* altd ld e, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E); 
}

/* ld e', (iy + 127) */
/* ld e', (iy - 128) */
| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x5E); 
}

/* ld (hl), e */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x73); 
}

/* ld (ix), e */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x73) << 8); 
}

/* ld (ix + 127), e */
/* ld (ix - 128), e */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x73); 
}

/* ld (iy), e */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x73) << 8); 
}

/* ld (iy + 127), e */
/* ld (iy - 128), e */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x73); 
}

/* ld h, b */
| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x60); 
}

/* altd ld h, b */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x60); 
}

/* ld h', b */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x60); 
}

/* ld ixh, b */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x60); 
}

/* ld iyh, b */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x60); 
}

/* ld h, c */
| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x61); 
}

/* altd ld h, c */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x61); 
}

/* ld h', c */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x61); 
}

/* ld ixh, c */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x61); 
}

/* ld iyh, c */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x61); 
}

/* ld h, d */
| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x62); 
}

/* altd ld h, d */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x62); 
}

/* ld h', d */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x62); 
}

/* ld ixh, d */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x62); 
}

/* ld iyh, d */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x62); 
}

/* ld h, e */
| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x63); 
}

/* altd ld h, e */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x63); 
}

/* ld h', e */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x63); 
}

/* ld ixh, e */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x63); 
}

/* ld iyh, e */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x63); 
}

/* ld h, h */
| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x64); 
}

/* altd ld h, h */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x64); 
}

/* ld h', h */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x64); 
}

/* ld ixh, ixh */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x64); 
}

/* ld iyh, iyh */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x64); 
}

/* ld h, l */
| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x65); 
}

/* altd ld h, l */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x65); 
}

/* ld h', l */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x65); 
}

/* ld ixh, ixl */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x65); 
}

/* ld iyh, iyl */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x65); 
}

/* ld h, a */
| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x67); 
}

/* altd ld h, a */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x67); 
}

/* ld h', a */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x67); 
}

/* ld ixh, a */
| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x67); 
}

/* ld iyh, a */
| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x67); 
}

/* ld h,  42  */
/* ld h, (42) */
| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x26); 
}

/* altd ld h,  42  */
/* altd ld h, (42) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x26); 
}

/* ld h',  42  */
/* ld h', (42) */
| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x26); 
}

/* ld ixh,  42  */
/* ld ixh, (42) */
| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x26); 
}

/* ld iyh,  42  */
/* ld iyh, (42) */
| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x26); 
}

/* ld h, (hl) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x66); 
}

/* altd ld h, (hl) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x66); 
}

/* ld h', (hl) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x66); 
}

/* ld h, (ix) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66) << 8); 
}

/* altd ld h, (ix) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66) << 8); 
}

/* ld h', (ix) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66) << 8); 
}

/* ld h, (ix + 127) */
/* ld h, (ix - 128) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66); 
}

/* altd ld h, (ix + 127) */
/* altd ld h, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66); 
}

/* ld h', (ix + 127) */
/* ld h', (ix - 128) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x66); 
}

/* ld h, (iy) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66) << 8); 
}

/* altd ld h, (iy) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66) << 8); 
}

/* ld h', (iy) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66) << 8); 
}

/* ld h, (iy + 127) */
/* ld h, (iy - 128) */
| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66); 
}

/* altd ld h, (iy + 127) */
/* altd ld h, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66); 
}

/* ld h', (iy + 127) */
/* ld h', (iy - 128) */
| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x66); 
}

/* ld (hl), h */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x74); 
}

/* ld (ix), h */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x74) << 8); 
}

/* ld (ix + 127), h */
/* ld (ix - 128), h */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x74); 
}

/* ld (iy), h */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x74) << 8); 
}

/* ld (iy + 127), h */
/* ld (iy - 128), h */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x74); 
}

/* ld l, b */
| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x68); 
}

/* altd ld l, b */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x68); 
}

/* ld l', b */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x68); 
}

/* ld ixl, b */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x68); 
}

/* ld iyl, b */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x68); 
}

/* ld l, c */
| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x69); 
}

/* altd ld l, c */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x69); 
}

/* ld l', c */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x69); 
}

/* ld ixl, c */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x69); 
}

/* ld iyl, c */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x69); 
}

/* ld l, d */
| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x6A); 
}

/* altd ld l, d */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6A); 
}

/* ld l', d */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6A); 
}

/* ld ixl, d */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6A); 
}

/* ld iyl, d */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6A); 
}

/* ld l, e */
| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x6B); 
}

/* altd ld l, e */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6B); 
}

/* ld l', e */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6B); 
}

/* ld ixl, e */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6B); 
}

/* ld iyl, e */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6B); 
}

/* ld l, h */
| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x6C); 
}

/* altd ld l, h */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6C); 
}

/* ld l', h */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6C); 
}

/* ld ixl, ixh */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6C); 
}

/* ld iyl, iyh */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6C); 
}

/* ld l, l */
| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x6D); 
}

/* altd ld l, l */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6D); 
}

/* ld l', l */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6D); 
}

/* ld ixl, ixl */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6D); 
}

/* ld iyl, iyl */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6D); 
}

/* ld l, a */
| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x6F); 
}

/* altd ld l, a */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6F); 
}

/* ld l', a */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6F); 
}

/* ld ixl, a */
| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6F); 
}

/* ld iyl, a */
| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6F); 
}

/* ld l,  42  */
/* ld l, (42) */
| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x2E); 
}

/* altd ld l,  42  */
/* altd ld l, (42) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x2E); 
}

/* ld l',  42  */
/* ld l', (42) */
| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt(0x76); 
DO_stmt_n(0x2E); 
}

/* ld ixl,  42  */
/* ld ixl, (42) */
| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x2E); 
}

/* ld iyl,  42  */
/* ld iyl, (42) */
| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x2E); 
}

/* ld l, (hl) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x6E); 
}

/* altd ld l, (hl) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6E); 
}

/* ld l', (hl) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x6E); 
}

/* ld l, (ix) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E) << 8); 
}

/* altd ld l, (ix) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E) << 8); 
}

/* ld l', (ix) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E) << 8); 
}

/* ld l, (ix + 127) */
/* ld l, (ix - 128) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E); 
}

/* altd ld l, (ix + 127) */
/* altd ld l, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E); 
}

/* ld l', (ix + 127) */
/* ld l', (ix - 128) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x6E); 
}

/* ld l, (iy) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E) << 8); 
}

/* altd ld l, (iy) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E) << 8); 
}

/* ld l', (iy) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E) << 8); 
}

/* ld l, (iy + 127) */
/* ld l, (iy - 128) */
| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E); 
}

/* altd ld l, (iy + 127) */
/* altd ld l, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E); 
}

/* ld l', (iy + 127) */
/* ld l', (iy - 128) */
| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x6E); 
}

/* ld (hl), l */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x75); 
}

/* ld (ix), l */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x75) << 8); 
}

/* ld (ix + 127), l */
/* ld (ix - 128), l */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x75); 
}

/* ld (iy), l */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x75) << 8); 
}

/* ld (iy + 127), l */
/* ld (iy - 128), l */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x75); 
}

/* ld a, b */
| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x78); 
}

/* altd ld a, b */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x78); 
}

/* ld a', b */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x78); 
}

/* ld a, c */
| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x79); 
}

/* altd ld a, c */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x79); 
}

/* ld a', c */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x79); 
}

/* ld a, d */
| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x7A); 
}

/* altd ld a, d */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7A); 
}

/* ld a', d */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7A); 
}

/* ld a, e */
| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x7B); 
}

/* altd ld a, e */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7B); 
}

/* ld a', e */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7B); 
}

/* ld a, h */
| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x7C); 
}

/* altd ld a, h */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7C); 
}

/* ld a', h */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7C); 
}

/* ld a, ixh */
| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7C); 
}

/* ld a, iyh */
| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7C); 
}

/* ld a, l */
| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x7D); 
}

/* altd ld a, l */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7D); 
}

/* ld a', l */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7D); 
}

/* ld a, ixl */
| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7D); 
}

/* ld a, iyl */
| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7D); 
}

/* ld a, a */
| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x7F); 
}

/* altd ld a, a */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7F); 
}

/* ld a', a */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7F); 
}

/* ld a, 42 */
/* ld a, (256) */
| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn(0x3A); 
} else { 
DO_stmt_n(0x3E); 
} 
}

/* altd ld a, 42 */
/* altd ld a, (256) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
if (expr_in_parens) { 
DO_stmt_nn(0x3A); 
} else { 
DO_stmt_n(0x3E); 
} 
}

/* ld a', 42 */
/* ld a', (256) */
| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
if (expr_in_parens) { 
DO_stmt_nn(0x3A); 
} else { 
DO_stmt_n(0x3E); 
} 
}

/* ld a, (hl) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x7E); 
}

/* altd ld a, (hl) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7E); 
}

/* ld a', (hl) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x7E); 
}

/* ld a, (ix) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E) << 8); 
}

/* altd ld a, (ix) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E) << 8); 
}

/* ld a', (ix) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E) << 8); 
}

/* ld a, (ix + 127) */
/* ld a, (ix - 128) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E); 
}

/* altd ld a, (ix + 127) */
/* altd ld a, (ix - 128) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E); 
}

/* ld a', (ix + 127) */
/* ld a', (ix - 128) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7E); 
}

/* ld a, (iy) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E) << 8); 
}

/* altd ld a, (iy) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E) << 8); 
}

/* ld a', (iy) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E) << 8); 
}

/* ld a, (iy + 127) */
/* ld a, (iy - 128) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E); 
}

/* altd ld a, (iy + 127) */
/* altd ld a, (iy - 128) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E); 
}

/* ld a', (iy + 127) */
/* ld a', (iy - 128) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7E); 
}

/* ld (hl), a */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x77); 
}

/* ld (ix), a */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x77) << 8); 
}

/* ld (ix + 127), a */
/* ld (ix - 128), a */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x77); 
}

/* ld (iy), a */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x77) << 8); 
}

/* ld (iy + 127), a */
/* ld (iy - 128), a */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x77); 
}

/* ld (hl), 42 */
| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(0x36); 
}

/* ld (ix), 42 */
| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x36) << 8); 
}

/* ld (ix + 127), 42 */
/* ld (ix - 128), 42 */
| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_idx_n((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x36); 
}

/* ld (iy), 42 */
| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_n(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x36) << 8); 
}

/* ld (iy + 127), 42 */
/* ld (iy - 128), 42 */
| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) warn_expr_in_parens(); 
DO_stmt_idx_n((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x36); 
}

/* ld (bc), a */
| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x02); 
}

/* ld a, (bc) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x0A); 
}

/* altd ld a, (bc) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x0A); 
}

/* ld a', (bc) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x0A); 
}

/* ld (de), a */
| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x12); 
}

/* ld a, (de) */
| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x1A); 
}

/* altd ld a, (de) */
| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x1A); 
}

/* ld a', (de) */
| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x1A); 
}

/* ld (256), a */
| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn(0x32); 
}

/* add a, b */
| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x80); 
}

/* add b */
| label? _TK_ADD _TK_B _TK_NEWLINE @{  
DO_stmt(0x80); 
}

/* altd add a, b */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x80); 
}

/* altd add b */
| label? _TK_ALTD _TK_ADD _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x80); 
}

/* add a', b */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x80); 
}

/* add a, c */
| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x81); 
}

/* add c */
| label? _TK_ADD _TK_C _TK_NEWLINE @{  
DO_stmt(0x81); 
}

/* altd add a, c */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x81); 
}

/* altd add c */
| label? _TK_ALTD _TK_ADD _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x81); 
}

/* add a', c */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x81); 
}

/* add a, d */
| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x82); 
}

/* add d */
| label? _TK_ADD _TK_D _TK_NEWLINE @{  
DO_stmt(0x82); 
}

/* altd add a, d */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x82); 
}

/* altd add d */
| label? _TK_ALTD _TK_ADD _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x82); 
}

/* add a', d */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x82); 
}

/* add a, e */
| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x83); 
}

/* add e */
| label? _TK_ADD _TK_E _TK_NEWLINE @{  
DO_stmt(0x83); 
}

/* altd add a, e */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x83); 
}

/* altd add e */
| label? _TK_ALTD _TK_ADD _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x83); 
}

/* add a', e */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x83); 
}

/* add a, h */
| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x84); 
}

/* add h */
| label? _TK_ADD _TK_H _TK_NEWLINE @{  
DO_stmt(0x84); 
}

/* altd add a, h */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x84); 
}

/* altd add h */
| label? _TK_ALTD _TK_ADD _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x84); 
}

/* add a', h */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x84); 
}

/* add a, ixh */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x84); 
}

/* add ixh */
| label? _TK_ADD _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x84); 
}

/* add a, iyh */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x84); 
}

/* add iyh */
| label? _TK_ADD _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x84); 
}

/* add a, l */
| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x85); 
}

/* add l */
| label? _TK_ADD _TK_L _TK_NEWLINE @{  
DO_stmt(0x85); 
}

/* altd add a, l */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x85); 
}

/* altd add l */
| label? _TK_ALTD _TK_ADD _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x85); 
}

/* add a', l */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x85); 
}

/* add a, ixl */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x85); 
}

/* add ixl */
| label? _TK_ADD _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x85); 
}

/* add a, iyl */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x85); 
}

/* add iyl */
| label? _TK_ADD _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x85); 
}

/* add a, a */
| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x87); 
}

/* add a */
| label? _TK_ADD _TK_A _TK_NEWLINE @{  
DO_stmt(0x87); 
}

/* altd add a, a */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x87); 
}

/* altd add a */
| label? _TK_ALTD _TK_ADD _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x87); 
}

/* add a', a */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x87); 
}

/* add a, (hl) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x86); 
}

/* add (hl) */
| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x86); 
}

/* altd add a, (hl) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x86); 
}

/* altd add (hl) */
| label? _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x86); 
}

/* add a', (hl) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x86); 
}

/* add a, (ix) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86) << 8); 
}

/* add a, (ix + 127) */
/* add a, (ix - 128) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86); 
}

/* add (ix) */
| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86) << 8); 
}

/* add (ix + 127) */
/* add (ix - 128) */
| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86); 
}

/* altd add a, (ix) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86) << 8); 
}

/* altd add a, (ix + 127) */
/* altd add a, (ix - 128) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86); 
}

/* altd add (ix) */
| label? _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86) << 8); 
}

/* altd add (ix + 127) */
/* altd add (ix - 128) */
| label? _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86); 
}

/* add a', (ix) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86) << 8); 
}

/* add a', (ix + 127) */
/* add a', (ix - 128) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x86); 
}

/* add a, (iy) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86) << 8); 
}

/* add a, (iy + 127) */
/* add a, (iy - 128) */
| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86); 
}

/* add (iy) */
| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86) << 8); 
}

/* add (iy + 127) */
/* add (iy - 128) */
| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86); 
}

/* altd add a, (iy) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86) << 8); 
}

/* altd add a, (iy + 127) */
/* altd add a, (iy - 128) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86); 
}

/* altd add (iy) */
| label? _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86) << 8); 
}

/* altd add (iy + 127) */
/* altd add (iy - 128) */
| label? _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86); 
}

/* add a', (iy) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86) << 8); 
}

/* add a', (iy + 127) */
/* add a', (iy - 128) */
| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x86); 
}

/* add a,  42  */
/* add a, (42) */
| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xC6); 
}

/* add  42  */
/* add (42) */
| label? _TK_ADD expr _TK_NEWLINE @{  
DO_stmt_n(0xC6); 
}

/* altd add a,  42  */
/* altd add a, (42) */
| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xC6); 
}

/* altd add  42  */
/* altd add (42) */
| label? _TK_ALTD _TK_ADD expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xC6); 
}

/* add a',  42  */
/* add a', (42) */
| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xC6); 
}

/* adc a, b */
| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x88); 
}

/* adc b */
| label? _TK_ADC _TK_B _TK_NEWLINE @{  
DO_stmt(0x88); 
}

/* altd adc a, b */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x88); 
}

/* altd adc b */
| label? _TK_ALTD _TK_ADC _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x88); 
}

/* adc a', b */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x88); 
}

/* adc a, c */
| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x89); 
}

/* adc c */
| label? _TK_ADC _TK_C _TK_NEWLINE @{  
DO_stmt(0x89); 
}

/* altd adc a, c */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x89); 
}

/* altd adc c */
| label? _TK_ALTD _TK_ADC _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x89); 
}

/* adc a', c */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x89); 
}

/* adc a, d */
| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x8A); 
}

/* adc d */
| label? _TK_ADC _TK_D _TK_NEWLINE @{  
DO_stmt(0x8A); 
}

/* altd adc a, d */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8A); 
}

/* altd adc d */
| label? _TK_ALTD _TK_ADC _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8A); 
}

/* adc a', d */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8A); 
}

/* adc a, e */
| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x8B); 
}

/* adc e */
| label? _TK_ADC _TK_E _TK_NEWLINE @{  
DO_stmt(0x8B); 
}

/* altd adc a, e */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8B); 
}

/* altd adc e */
| label? _TK_ALTD _TK_ADC _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8B); 
}

/* adc a', e */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8B); 
}

/* adc a, h */
| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x8C); 
}

/* adc h */
| label? _TK_ADC _TK_H _TK_NEWLINE @{  
DO_stmt(0x8C); 
}

/* altd adc a, h */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8C); 
}

/* altd adc h */
| label? _TK_ALTD _TK_ADC _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8C); 
}

/* adc a', h */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8C); 
}

/* adc a, ixh */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8C); 
}

/* adc ixh */
| label? _TK_ADC _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8C); 
}

/* adc a, iyh */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8C); 
}

/* adc iyh */
| label? _TK_ADC _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8C); 
}

/* adc a, l */
| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x8D); 
}

/* adc l */
| label? _TK_ADC _TK_L _TK_NEWLINE @{  
DO_stmt(0x8D); 
}

/* altd adc a, l */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8D); 
}

/* altd adc l */
| label? _TK_ALTD _TK_ADC _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8D); 
}

/* adc a', l */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8D); 
}

/* adc a, ixl */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8D); 
}

/* adc ixl */
| label? _TK_ADC _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8D); 
}

/* adc a, iyl */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8D); 
}

/* adc iyl */
| label? _TK_ADC _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8D); 
}

/* adc a, a */
| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x8F); 
}

/* adc a */
| label? _TK_ADC _TK_A _TK_NEWLINE @{  
DO_stmt(0x8F); 
}

/* altd adc a, a */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8F); 
}

/* altd adc a */
| label? _TK_ALTD _TK_ADC _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8F); 
}

/* adc a', a */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8F); 
}

/* adc a, (hl) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x8E); 
}

/* adc (hl) */
| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x8E); 
}

/* altd adc a, (hl) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8E); 
}

/* altd adc (hl) */
| label? _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8E); 
}

/* adc a', (hl) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x8E); 
}

/* adc a, (ix) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E) << 8); 
}

/* adc a, (ix + 127) */
/* adc a, (ix - 128) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E); 
}

/* adc (ix) */
| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E) << 8); 
}

/* adc (ix + 127) */
/* adc (ix - 128) */
| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E); 
}

/* altd adc a, (ix) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E) << 8); 
}

/* altd adc a, (ix + 127) */
/* altd adc a, (ix - 128) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E); 
}

/* altd adc (ix) */
| label? _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E) << 8); 
}

/* altd adc (ix + 127) */
/* altd adc (ix - 128) */
| label? _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E); 
}

/* adc a', (ix) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E) << 8); 
}

/* adc a', (ix + 127) */
/* adc a', (ix - 128) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x8E); 
}

/* adc a, (iy) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E) << 8); 
}

/* adc a, (iy + 127) */
/* adc a, (iy - 128) */
| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E); 
}

/* adc (iy) */
| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E) << 8); 
}

/* adc (iy + 127) */
/* adc (iy - 128) */
| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E); 
}

/* altd adc a, (iy) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E) << 8); 
}

/* altd adc a, (iy + 127) */
/* altd adc a, (iy - 128) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E); 
}

/* altd adc (iy) */
| label? _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E) << 8); 
}

/* altd adc (iy + 127) */
/* altd adc (iy - 128) */
| label? _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E); 
}

/* adc a', (iy) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E) << 8); 
}

/* adc a', (iy + 127) */
/* adc a', (iy - 128) */
| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x8E); 
}

/* adc a,  42  */
/* adc a, (42) */
| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xCE); 
}

/* adc  42  */
/* adc (42) */
| label? _TK_ADC expr _TK_NEWLINE @{  
DO_stmt_n(0xCE); 
}

/* altd adc a,  42  */
/* altd adc a, (42) */
| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xCE); 
}

/* altd adc  42  */
/* altd adc (42) */
| label? _TK_ALTD _TK_ADC expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xCE); 
}

/* adc a',  42  */
/* adc a', (42) */
| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xCE); 
}

/* sub a, b */
| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x90); 
}

/* sub b */
| label? _TK_SUB _TK_B _TK_NEWLINE @{  
DO_stmt(0x90); 
}

/* altd sub a, b */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x90); 
}

/* altd sub b */
| label? _TK_ALTD _TK_SUB _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x90); 
}

/* sub a', b */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x90); 
}

/* sub a, c */
| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x91); 
}

/* sub c */
| label? _TK_SUB _TK_C _TK_NEWLINE @{  
DO_stmt(0x91); 
}

/* altd sub a, c */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x91); 
}

/* altd sub c */
| label? _TK_ALTD _TK_SUB _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x91); 
}

/* sub a', c */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x91); 
}

/* sub a, d */
| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x92); 
}

/* sub d */
| label? _TK_SUB _TK_D _TK_NEWLINE @{  
DO_stmt(0x92); 
}

/* altd sub a, d */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x92); 
}

/* altd sub d */
| label? _TK_ALTD _TK_SUB _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x92); 
}

/* sub a', d */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x92); 
}

/* sub a, e */
| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x93); 
}

/* sub e */
| label? _TK_SUB _TK_E _TK_NEWLINE @{  
DO_stmt(0x93); 
}

/* altd sub a, e */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x93); 
}

/* altd sub e */
| label? _TK_ALTD _TK_SUB _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x93); 
}

/* sub a', e */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x93); 
}

/* sub a, h */
| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x94); 
}

/* sub h */
| label? _TK_SUB _TK_H _TK_NEWLINE @{  
DO_stmt(0x94); 
}

/* altd sub a, h */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x94); 
}

/* altd sub h */
| label? _TK_ALTD _TK_SUB _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x94); 
}

/* sub a', h */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x94); 
}

/* sub a, ixh */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x94); 
}

/* sub ixh */
| label? _TK_SUB _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x94); 
}

/* sub a, iyh */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x94); 
}

/* sub iyh */
| label? _TK_SUB _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x94); 
}

/* sub a, l */
| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x95); 
}

/* sub l */
| label? _TK_SUB _TK_L _TK_NEWLINE @{  
DO_stmt(0x95); 
}

/* altd sub a, l */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x95); 
}

/* altd sub l */
| label? _TK_ALTD _TK_SUB _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x95); 
}

/* sub a', l */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x95); 
}

/* sub a, ixl */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x95); 
}

/* sub ixl */
| label? _TK_SUB _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x95); 
}

/* sub a, iyl */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x95); 
}

/* sub iyl */
| label? _TK_SUB _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x95); 
}

/* sub a, a */
| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x97); 
}

/* sub a */
| label? _TK_SUB _TK_A _TK_NEWLINE @{  
DO_stmt(0x97); 
}

/* altd sub a, a */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x97); 
}

/* altd sub a */
| label? _TK_ALTD _TK_SUB _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x97); 
}

/* sub a', a */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x97); 
}

/* sub a, (hl) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x96); 
}

/* sub (hl) */
| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x96); 
}

/* altd sub a, (hl) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x96); 
}

/* altd sub (hl) */
| label? _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x96); 
}

/* sub a', (hl) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x96); 
}

/* sub a, (ix) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96) << 8); 
}

/* sub a, (ix + 127) */
/* sub a, (ix - 128) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96); 
}

/* sub (ix) */
| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96) << 8); 
}

/* sub (ix + 127) */
/* sub (ix - 128) */
| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96); 
}

/* altd sub a, (ix) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96) << 8); 
}

/* altd sub a, (ix + 127) */
/* altd sub a, (ix - 128) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96); 
}

/* altd sub (ix) */
| label? _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96) << 8); 
}

/* altd sub (ix + 127) */
/* altd sub (ix - 128) */
| label? _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96); 
}

/* sub a', (ix) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96) << 8); 
}

/* sub a', (ix + 127) */
/* sub a', (ix - 128) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x96); 
}

/* sub a, (iy) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96) << 8); 
}

/* sub a, (iy + 127) */
/* sub a, (iy - 128) */
| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96); 
}

/* sub (iy) */
| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96) << 8); 
}

/* sub (iy + 127) */
/* sub (iy - 128) */
| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96); 
}

/* altd sub a, (iy) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96) << 8); 
}

/* altd sub a, (iy + 127) */
/* altd sub a, (iy - 128) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96); 
}

/* altd sub (iy) */
| label? _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96) << 8); 
}

/* altd sub (iy + 127) */
/* altd sub (iy - 128) */
| label? _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96); 
}

/* sub a', (iy) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96) << 8); 
}

/* sub a', (iy + 127) */
/* sub a', (iy - 128) */
| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x96); 
}

/* sub a,  42  */
/* sub a, (42) */
| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xD6); 
}

/* sub  42  */
/* sub (42) */
| label? _TK_SUB expr _TK_NEWLINE @{  
DO_stmt_n(0xD6); 
}

/* altd sub a,  42  */
/* altd sub a, (42) */
| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xD6); 
}

/* altd sub  42  */
/* altd sub (42) */
| label? _TK_ALTD _TK_SUB expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xD6); 
}

/* sub a',  42  */
/* sub a', (42) */
| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xD6); 
}

/* sbc a, b */
| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0x98); 
}

/* sbc b */
| label? _TK_SBC _TK_B _TK_NEWLINE @{  
DO_stmt(0x98); 
}

/* altd sbc a, b */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x98); 
}

/* altd sbc b */
| label? _TK_ALTD _TK_SBC _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x98); 
}

/* sbc a', b */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x98); 
}

/* sbc a, c */
| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0x99); 
}

/* sbc c */
| label? _TK_SBC _TK_C _TK_NEWLINE @{  
DO_stmt(0x99); 
}

/* altd sbc a, c */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x99); 
}

/* altd sbc c */
| label? _TK_ALTD _TK_SBC _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x99); 
}

/* sbc a', c */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x99); 
}

/* sbc a, d */
| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0x9A); 
}

/* sbc d */
| label? _TK_SBC _TK_D _TK_NEWLINE @{  
DO_stmt(0x9A); 
}

/* altd sbc a, d */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9A); 
}

/* altd sbc d */
| label? _TK_ALTD _TK_SBC _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9A); 
}

/* sbc a', d */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9A); 
}

/* sbc a, e */
| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0x9B); 
}

/* sbc e */
| label? _TK_SBC _TK_E _TK_NEWLINE @{  
DO_stmt(0x9B); 
}

/* altd sbc a, e */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9B); 
}

/* altd sbc e */
| label? _TK_ALTD _TK_SBC _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9B); 
}

/* sbc a', e */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9B); 
}

/* sbc a, h */
| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0x9C); 
}

/* sbc h */
| label? _TK_SBC _TK_H _TK_NEWLINE @{  
DO_stmt(0x9C); 
}

/* altd sbc a, h */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9C); 
}

/* altd sbc h */
| label? _TK_ALTD _TK_SBC _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9C); 
}

/* sbc a', h */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9C); 
}

/* sbc a, ixh */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9C); 
}

/* sbc ixh */
| label? _TK_SBC _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9C); 
}

/* sbc a, iyh */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9C); 
}

/* sbc iyh */
| label? _TK_SBC _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9C); 
}

/* sbc a, l */
| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0x9D); 
}

/* sbc l */
| label? _TK_SBC _TK_L _TK_NEWLINE @{  
DO_stmt(0x9D); 
}

/* altd sbc a, l */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9D); 
}

/* altd sbc l */
| label? _TK_ALTD _TK_SBC _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9D); 
}

/* sbc a', l */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9D); 
}

/* sbc a, ixl */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9D); 
}

/* sbc ixl */
| label? _TK_SBC _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9D); 
}

/* sbc a, iyl */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9D); 
}

/* sbc iyl */
| label? _TK_SBC _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9D); 
}

/* sbc a, a */
| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0x9F); 
}

/* sbc a */
| label? _TK_SBC _TK_A _TK_NEWLINE @{  
DO_stmt(0x9F); 
}

/* altd sbc a, a */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9F); 
}

/* altd sbc a */
| label? _TK_ALTD _TK_SBC _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9F); 
}

/* sbc a', a */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9F); 
}

/* sbc a, (hl) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x9E); 
}

/* sbc (hl) */
| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x9E); 
}

/* altd sbc a, (hl) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9E); 
}

/* altd sbc (hl) */
| label? _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9E); 
}

/* sbc a', (hl) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x9E); 
}

/* sbc a, (ix) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E) << 8); 
}

/* sbc a, (ix + 127) */
/* sbc a, (ix - 128) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E); 
}

/* sbc (ix) */
| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E) << 8); 
}

/* sbc (ix + 127) */
/* sbc (ix - 128) */
| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E); 
}

/* altd sbc a, (ix) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E) << 8); 
}

/* altd sbc a, (ix + 127) */
/* altd sbc a, (ix - 128) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E); 
}

/* altd sbc (ix) */
| label? _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E) << 8); 
}

/* altd sbc (ix + 127) */
/* altd sbc (ix - 128) */
| label? _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E); 
}

/* sbc a', (ix) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E) << 8); 
}

/* sbc a', (ix + 127) */
/* sbc a', (ix - 128) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x9E); 
}

/* sbc a, (iy) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E) << 8); 
}

/* sbc a, (iy + 127) */
/* sbc a, (iy - 128) */
| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E); 
}

/* sbc (iy) */
| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E) << 8); 
}

/* sbc (iy + 127) */
/* sbc (iy - 128) */
| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E); 
}

/* altd sbc a, (iy) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E) << 8); 
}

/* altd sbc a, (iy + 127) */
/* altd sbc a, (iy - 128) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E); 
}

/* altd sbc (iy) */
| label? _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E) << 8); 
}

/* altd sbc (iy + 127) */
/* altd sbc (iy - 128) */
| label? _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E); 
}

/* sbc a', (iy) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E) << 8); 
}

/* sbc a', (iy + 127) */
/* sbc a', (iy - 128) */
| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x9E); 
}

/* sbc a,  42  */
/* sbc a, (42) */
| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xDE); 
}

/* sbc  42  */
/* sbc (42) */
| label? _TK_SBC expr _TK_NEWLINE @{  
DO_stmt_n(0xDE); 
}

/* altd sbc a,  42  */
/* altd sbc a, (42) */
| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xDE); 
}

/* altd sbc  42  */
/* altd sbc (42) */
| label? _TK_ALTD _TK_SBC expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xDE); 
}

/* sbc a',  42  */
/* sbc a', (42) */
| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xDE); 
}

/* and a, b */
| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0xA0); 
}

/* and b */
| label? _TK_AND _TK_B _TK_NEWLINE @{  
DO_stmt(0xA0); 
}

/* altd and a, b */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA0); 
}

/* altd and b */
| label? _TK_ALTD _TK_AND _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA0); 
}

/* and a', b */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA0); 
}

/* and a, c */
| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0xA1); 
}

/* and c */
| label? _TK_AND _TK_C _TK_NEWLINE @{  
DO_stmt(0xA1); 
}

/* altd and a, c */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA1); 
}

/* altd and c */
| label? _TK_ALTD _TK_AND _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA1); 
}

/* and a', c */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA1); 
}

/* and a, d */
| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0xA2); 
}

/* and d */
| label? _TK_AND _TK_D _TK_NEWLINE @{  
DO_stmt(0xA2); 
}

/* altd and a, d */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA2); 
}

/* altd and d */
| label? _TK_ALTD _TK_AND _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA2); 
}

/* and a', d */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA2); 
}

/* and a, e */
| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0xA3); 
}

/* and e */
| label? _TK_AND _TK_E _TK_NEWLINE @{  
DO_stmt(0xA3); 
}

/* altd and a, e */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA3); 
}

/* altd and e */
| label? _TK_ALTD _TK_AND _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA3); 
}

/* and a', e */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA3); 
}

/* and a, h */
| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0xA4); 
}

/* and h */
| label? _TK_AND _TK_H _TK_NEWLINE @{  
DO_stmt(0xA4); 
}

/* altd and a, h */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA4); 
}

/* altd and h */
| label? _TK_ALTD _TK_AND _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA4); 
}

/* and a', h */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA4); 
}

/* and a, ixh */
| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA4); 
}

/* and ixh */
| label? _TK_AND _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA4); 
}

/* and a, iyh */
| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA4); 
}

/* and iyh */
| label? _TK_AND _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA4); 
}

/* and a, l */
| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0xA5); 
}

/* and l */
| label? _TK_AND _TK_L _TK_NEWLINE @{  
DO_stmt(0xA5); 
}

/* altd and a, l */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA5); 
}

/* altd and l */
| label? _TK_ALTD _TK_AND _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA5); 
}

/* and a', l */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA5); 
}

/* and a, ixl */
| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA5); 
}

/* and ixl */
| label? _TK_AND _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA5); 
}

/* and a, iyl */
| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA5); 
}

/* and iyl */
| label? _TK_AND _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA5); 
}

/* and a, a */
| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0xA7); 
}

/* and a */
| label? _TK_AND _TK_A _TK_NEWLINE @{  
DO_stmt(0xA7); 
}

/* altd and a, a */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA7); 
}

/* altd and a */
| label? _TK_ALTD _TK_AND _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA7); 
}

/* and a', a */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA7); 
}

/* and a, (hl) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xA6); 
}

/* and (hl) */
| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xA6); 
}

/* altd and a, (hl) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA6); 
}

/* altd and (hl) */
| label? _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA6); 
}

/* and a', (hl) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA6); 
}

/* and a, (ix) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6) << 8); 
}

/* and a, (ix + 127) */
/* and a, (ix - 128) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6); 
}

/* and (ix) */
| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6) << 8); 
}

/* and (ix + 127) */
/* and (ix - 128) */
| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6); 
}

/* altd and a, (ix) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6) << 8); 
}

/* altd and a, (ix + 127) */
/* altd and a, (ix - 128) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6); 
}

/* altd and (ix) */
| label? _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6) << 8); 
}

/* altd and (ix + 127) */
/* altd and (ix - 128) */
| label? _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6); 
}

/* and a', (ix) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6) << 8); 
}

/* and a', (ix + 127) */
/* and a', (ix - 128) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xA6); 
}

/* and a, (iy) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6) << 8); 
}

/* and a, (iy + 127) */
/* and a, (iy - 128) */
| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6); 
}

/* and (iy) */
| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6) << 8); 
}

/* and (iy + 127) */
/* and (iy - 128) */
| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6); 
}

/* altd and a, (iy) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6) << 8); 
}

/* altd and a, (iy + 127) */
/* altd and a, (iy - 128) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6); 
}

/* altd and (iy) */
| label? _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6) << 8); 
}

/* altd and (iy + 127) */
/* altd and (iy - 128) */
| label? _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6); 
}

/* and a', (iy) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6) << 8); 
}

/* and a', (iy + 127) */
/* and a', (iy - 128) */
| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xA6); 
}

/* and a,  42  */
/* and a, (42) */
| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xE6); 
}

/* and  42  */
/* and (42) */
| label? _TK_AND expr _TK_NEWLINE @{  
DO_stmt_n(0xE6); 
}

/* altd and a,  42  */
/* altd and a, (42) */
| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xE6); 
}

/* altd and  42  */
/* altd and (42) */
| label? _TK_ALTD _TK_AND expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xE6); 
}

/* and a',  42  */
/* and a', (42) */
| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xE6); 
}

/* xor a, b */
| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0xA8); 
}

/* xor b */
| label? _TK_XOR _TK_B _TK_NEWLINE @{  
DO_stmt(0xA8); 
}

/* altd xor a, b */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA8); 
}

/* altd xor b */
| label? _TK_ALTD _TK_XOR _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA8); 
}

/* xor a', b */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA8); 
}

/* xor a, c */
| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0xA9); 
}

/* xor c */
| label? _TK_XOR _TK_C _TK_NEWLINE @{  
DO_stmt(0xA9); 
}

/* altd xor a, c */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA9); 
}

/* altd xor c */
| label? _TK_ALTD _TK_XOR _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA9); 
}

/* xor a', c */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xA9); 
}

/* xor a, d */
| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0xAA); 
}

/* xor d */
| label? _TK_XOR _TK_D _TK_NEWLINE @{  
DO_stmt(0xAA); 
}

/* altd xor a, d */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAA); 
}

/* altd xor d */
| label? _TK_ALTD _TK_XOR _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAA); 
}

/* xor a', d */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAA); 
}

/* xor a, e */
| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0xAB); 
}

/* xor e */
| label? _TK_XOR _TK_E _TK_NEWLINE @{  
DO_stmt(0xAB); 
}

/* altd xor a, e */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAB); 
}

/* altd xor e */
| label? _TK_ALTD _TK_XOR _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAB); 
}

/* xor a', e */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAB); 
}

/* xor a, h */
| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0xAC); 
}

/* xor h */
| label? _TK_XOR _TK_H _TK_NEWLINE @{  
DO_stmt(0xAC); 
}

/* altd xor a, h */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAC); 
}

/* altd xor h */
| label? _TK_ALTD _TK_XOR _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAC); 
}

/* xor a', h */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAC); 
}

/* xor a, ixh */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAC); 
}

/* xor ixh */
| label? _TK_XOR _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAC); 
}

/* xor a, iyh */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAC); 
}

/* xor iyh */
| label? _TK_XOR _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAC); 
}

/* xor a, l */
| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0xAD); 
}

/* xor l */
| label? _TK_XOR _TK_L _TK_NEWLINE @{  
DO_stmt(0xAD); 
}

/* altd xor a, l */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAD); 
}

/* altd xor l */
| label? _TK_ALTD _TK_XOR _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAD); 
}

/* xor a', l */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAD); 
}

/* xor a, ixl */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAD); 
}

/* xor ixl */
| label? _TK_XOR _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAD); 
}

/* xor a, iyl */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAD); 
}

/* xor iyl */
| label? _TK_XOR _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAD); 
}

/* xor a, a */
| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0xAF); 
}

/* xor a */
| label? _TK_XOR _TK_A _TK_NEWLINE @{  
DO_stmt(0xAF); 
}

/* altd xor a, a */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAF); 
}

/* altd xor a */
| label? _TK_ALTD _TK_XOR _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAF); 
}

/* xor a', a */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAF); 
}

/* xor a, (hl) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xAE); 
}

/* xor (hl) */
| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xAE); 
}

/* altd xor a, (hl) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAE); 
}

/* altd xor (hl) */
| label? _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAE); 
}

/* xor a', (hl) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xAE); 
}

/* xor a, (ix) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE) << 8); 
}

/* xor a, (ix + 127) */
/* xor a, (ix - 128) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE); 
}

/* xor (ix) */
| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE) << 8); 
}

/* xor (ix + 127) */
/* xor (ix - 128) */
| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE); 
}

/* altd xor a, (ix) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE) << 8); 
}

/* altd xor a, (ix + 127) */
/* altd xor a, (ix - 128) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE); 
}

/* altd xor (ix) */
| label? _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE) << 8); 
}

/* altd xor (ix + 127) */
/* altd xor (ix - 128) */
| label? _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE); 
}

/* xor a', (ix) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE) << 8); 
}

/* xor a', (ix + 127) */
/* xor a', (ix - 128) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xAE); 
}

/* xor a, (iy) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE) << 8); 
}

/* xor a, (iy + 127) */
/* xor a, (iy - 128) */
| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE); 
}

/* xor (iy) */
| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE) << 8); 
}

/* xor (iy + 127) */
/* xor (iy - 128) */
| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE); 
}

/* altd xor a, (iy) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE) << 8); 
}

/* altd xor a, (iy + 127) */
/* altd xor a, (iy - 128) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE); 
}

/* altd xor (iy) */
| label? _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE) << 8); 
}

/* altd xor (iy + 127) */
/* altd xor (iy - 128) */
| label? _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE); 
}

/* xor a', (iy) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE) << 8); 
}

/* xor a', (iy + 127) */
/* xor a', (iy - 128) */
| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xAE); 
}

/* xor a,  42  */
/* xor a, (42) */
| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xEE); 
}

/* xor  42  */
/* xor (42) */
| label? _TK_XOR expr _TK_NEWLINE @{  
DO_stmt_n(0xEE); 
}

/* altd xor a,  42  */
/* altd xor a, (42) */
| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xEE); 
}

/* altd xor  42  */
/* altd xor (42) */
| label? _TK_ALTD _TK_XOR expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xEE); 
}

/* xor a',  42  */
/* xor a', (42) */
| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xEE); 
}

/* or a, b */
| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0xB0); 
}

/* or b */
| label? _TK_OR _TK_B _TK_NEWLINE @{  
DO_stmt(0xB0); 
}

/* altd or a, b */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB0); 
}

/* altd or b */
| label? _TK_ALTD _TK_OR _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB0); 
}

/* or a', b */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB0); 
}

/* or a, c */
| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0xB1); 
}

/* or c */
| label? _TK_OR _TK_C _TK_NEWLINE @{  
DO_stmt(0xB1); 
}

/* altd or a, c */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB1); 
}

/* altd or c */
| label? _TK_ALTD _TK_OR _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB1); 
}

/* or a', c */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB1); 
}

/* or a, d */
| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0xB2); 
}

/* or d */
| label? _TK_OR _TK_D _TK_NEWLINE @{  
DO_stmt(0xB2); 
}

/* altd or a, d */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB2); 
}

/* altd or d */
| label? _TK_ALTD _TK_OR _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB2); 
}

/* or a', d */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB2); 
}

/* or a, e */
| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0xB3); 
}

/* or e */
| label? _TK_OR _TK_E _TK_NEWLINE @{  
DO_stmt(0xB3); 
}

/* altd or a, e */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB3); 
}

/* altd or e */
| label? _TK_ALTD _TK_OR _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB3); 
}

/* or a', e */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB3); 
}

/* or a, h */
| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0xB4); 
}

/* or h */
| label? _TK_OR _TK_H _TK_NEWLINE @{  
DO_stmt(0xB4); 
}

/* altd or a, h */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB4); 
}

/* altd or h */
| label? _TK_ALTD _TK_OR _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB4); 
}

/* or a', h */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB4); 
}

/* or a, ixh */
| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB4); 
}

/* or ixh */
| label? _TK_OR _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB4); 
}

/* or a, iyh */
| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB4); 
}

/* or iyh */
| label? _TK_OR _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB4); 
}

/* or a, l */
| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0xB5); 
}

/* or l */
| label? _TK_OR _TK_L _TK_NEWLINE @{  
DO_stmt(0xB5); 
}

/* altd or a, l */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB5); 
}

/* altd or l */
| label? _TK_ALTD _TK_OR _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB5); 
}

/* or a', l */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB5); 
}

/* or a, ixl */
| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB5); 
}

/* or ixl */
| label? _TK_OR _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB5); 
}

/* or a, iyl */
| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB5); 
}

/* or iyl */
| label? _TK_OR _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB5); 
}

/* or a, a */
| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0xB7); 
}

/* or a */
| label? _TK_OR _TK_A _TK_NEWLINE @{  
DO_stmt(0xB7); 
}

/* altd or a, a */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB7); 
}

/* altd or a */
| label? _TK_ALTD _TK_OR _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB7); 
}

/* or a', a */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB7); 
}

/* or a, (hl) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xB6); 
}

/* or (hl) */
| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xB6); 
}

/* altd or a, (hl) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB6); 
}

/* altd or (hl) */
| label? _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB6); 
}

/* or a', (hl) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB6); 
}

/* or a, (ix) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6) << 8); 
}

/* or a, (ix + 127) */
/* or a, (ix - 128) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6); 
}

/* or (ix) */
| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6) << 8); 
}

/* or (ix + 127) */
/* or (ix - 128) */
| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6); 
}

/* altd or a, (ix) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6) << 8); 
}

/* altd or a, (ix + 127) */
/* altd or a, (ix - 128) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6); 
}

/* altd or (ix) */
| label? _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6) << 8); 
}

/* altd or (ix + 127) */
/* altd or (ix - 128) */
| label? _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6); 
}

/* or a', (ix) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6) << 8); 
}

/* or a', (ix + 127) */
/* or a', (ix - 128) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xB6); 
}

/* or a, (iy) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6) << 8); 
}

/* or a, (iy + 127) */
/* or a, (iy - 128) */
| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6); 
}

/* or (iy) */
| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6) << 8); 
}

/* or (iy + 127) */
/* or (iy - 128) */
| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6); 
}

/* altd or a, (iy) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6) << 8); 
}

/* altd or a, (iy + 127) */
/* altd or a, (iy - 128) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6); 
}

/* altd or (iy) */
| label? _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6) << 8); 
}

/* altd or (iy + 127) */
/* altd or (iy - 128) */
| label? _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6); 
}

/* or a', (iy) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6) << 8); 
}

/* or a', (iy + 127) */
/* or a', (iy - 128) */
| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xB6); 
}

/* or a,  42  */
/* or a, (42) */
| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xF6); 
}

/* or  42  */
/* or (42) */
| label? _TK_OR expr _TK_NEWLINE @{  
DO_stmt_n(0xF6); 
}

/* altd or a,  42  */
/* altd or a, (42) */
| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xF6); 
}

/* altd or  42  */
/* altd or (42) */
| label? _TK_ALTD _TK_OR expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xF6); 
}

/* or a',  42  */
/* or a', (42) */
| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xF6); 
}

/* cp a, b */
| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{  
DO_stmt(0xB8); 
}

/* cp b */
| label? _TK_CP _TK_B _TK_NEWLINE @{  
DO_stmt(0xB8); 
}

/* altd cp a, b */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB8); 
}

/* altd cp b */
| label? _TK_ALTD _TK_CP _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB8); 
}

/* cp a', b */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB8); 
}

/* cp a, c */
| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{  
DO_stmt(0xB9); 
}

/* cp c */
| label? _TK_CP _TK_C _TK_NEWLINE @{  
DO_stmt(0xB9); 
}

/* altd cp a, c */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB9); 
}

/* altd cp c */
| label? _TK_ALTD _TK_CP _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB9); 
}

/* cp a', c */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xB9); 
}

/* cp a, d */
| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{  
DO_stmt(0xBA); 
}

/* cp d */
| label? _TK_CP _TK_D _TK_NEWLINE @{  
DO_stmt(0xBA); 
}

/* altd cp a, d */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBA); 
}

/* altd cp d */
| label? _TK_ALTD _TK_CP _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBA); 
}

/* cp a', d */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBA); 
}

/* cp a, e */
| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{  
DO_stmt(0xBB); 
}

/* cp e */
| label? _TK_CP _TK_E _TK_NEWLINE @{  
DO_stmt(0xBB); 
}

/* altd cp a, e */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBB); 
}

/* altd cp e */
| label? _TK_ALTD _TK_CP _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBB); 
}

/* cp a', e */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBB); 
}

/* cp a, h */
| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{  
DO_stmt(0xBC); 
}

/* cp h */
| label? _TK_CP _TK_H _TK_NEWLINE @{  
DO_stmt(0xBC); 
}

/* altd cp a, h */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBC); 
}

/* altd cp h */
| label? _TK_ALTD _TK_CP _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBC); 
}

/* cp a', h */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBC); 
}

/* cp a, ixh */
| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBC); 
}

/* cp ixh */
| label? _TK_CP _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBC); 
}

/* cp a, iyh */
| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBC); 
}

/* cp iyh */
| label? _TK_CP _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBC); 
}

/* cp a, l */
| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{  
DO_stmt(0xBD); 
}

/* cp l */
| label? _TK_CP _TK_L _TK_NEWLINE @{  
DO_stmt(0xBD); 
}

/* altd cp a, l */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBD); 
}

/* altd cp l */
| label? _TK_ALTD _TK_CP _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBD); 
}

/* cp a', l */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBD); 
}

/* cp a, ixl */
| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBD); 
}

/* cp ixl */
| label? _TK_CP _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBD); 
}

/* cp a, iyl */
| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBD); 
}

/* cp iyl */
| label? _TK_CP _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBD); 
}

/* cp a, a */
| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{  
DO_stmt(0xBF); 
}

/* cp a */
| label? _TK_CP _TK_A _TK_NEWLINE @{  
DO_stmt(0xBF); 
}

/* altd cp a, a */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBF); 
}

/* altd cp a */
| label? _TK_ALTD _TK_CP _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBF); 
}

/* cp a', a */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBF); 
}

/* cp a, (hl) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xBE); 
}

/* cp (hl) */
| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0xBE); 
}

/* altd cp a, (hl) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBE); 
}

/* altd cp (hl) */
| label? _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBE); 
}

/* cp a', (hl) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xBE); 
}

/* cp a, (ix) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE) << 8); 
}

/* cp a, (ix + 127) */
/* cp a, (ix - 128) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE); 
}

/* cp (ix) */
| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE) << 8); 
}

/* cp (ix + 127) */
/* cp (ix - 128) */
| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE); 
}

/* altd cp a, (ix) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE) << 8); 
}

/* altd cp a, (ix + 127) */
/* altd cp a, (ix - 128) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE); 
}

/* altd cp (ix) */
| label? _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE) << 8); 
}

/* altd cp (ix + 127) */
/* altd cp (ix - 128) */
| label? _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE); 
}

/* cp a', (ix) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE) << 8); 
}

/* cp a', (ix + 127) */
/* cp a', (ix - 128) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xBE); 
}

/* cp a, (iy) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE) << 8); 
}

/* cp a, (iy + 127) */
/* cp a, (iy - 128) */
| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE); 
}

/* cp (iy) */
| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE) << 8); 
}

/* cp (iy + 127) */
/* cp (iy - 128) */
| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE); 
}

/* altd cp a, (iy) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE) << 8); 
}

/* altd cp a, (iy + 127) */
/* altd cp a, (iy - 128) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE); 
}

/* altd cp (iy) */
| label? _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE) << 8); 
}

/* altd cp (iy + 127) */
/* altd cp (iy - 128) */
| label? _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE); 
}

/* cp a', (iy) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE) << 8); 
}

/* cp a', (iy + 127) */
/* cp a', (iy - 128) */
| label? _TK_CP _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xBE); 
}

/* cp a,  42  */
/* cp a, (42) */
| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{  
DO_stmt_n(0xFE); 
}

/* cp  42  */
/* cp (42) */
| label? _TK_CP expr _TK_NEWLINE @{  
DO_stmt_n(0xFE); 
}

/* altd cp a,  42  */
/* altd cp a, (42) */
| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xFE); 
}

/* altd cp  42  */
/* altd cp (42) */
| label? _TK_ALTD _TK_CP expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xFE); 
}

/* cp a',  42  */
/* cp a', (42) */
| label? _TK_CP _TK_A1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt_n(0xFE); 
}

/* inc b */
| label? _TK_INC _TK_B _TK_NEWLINE @{  
DO_stmt(0x04); 
}

/* altd inc b */
| label? _TK_ALTD _TK_INC _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x04); 
}

/* inc b' */
| label? _TK_INC _TK_B1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x04); 
}

/* inc c */
| label? _TK_INC _TK_C _TK_NEWLINE @{  
DO_stmt(0x0C); 
}

/* altd inc c */
| label? _TK_ALTD _TK_INC _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd inc d */
| label? _TK_ALTD _TK_INC _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x14); 
}

/* inc d' */
| label? _TK_INC _TK_D1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x14); 
}

/* inc e */
| label? _TK_INC _TK_E _TK_NEWLINE @{  
DO_stmt(0x1C); 
}

/* altd inc e */
| label? _TK_ALTD _TK_INC _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd inc h */
| label? _TK_ALTD _TK_INC _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x24); 
}

/* inc h' */
| label? _TK_INC _TK_H1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x24); 
}

/* inc ixh */
| label? _TK_INC _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x24); 
}

/* inc iyh */
| label? _TK_INC _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x24); 
}

/* inc l */
| label? _TK_INC _TK_L _TK_NEWLINE @{  
DO_stmt(0x2C); 
}

/* altd inc l */
| label? _TK_ALTD _TK_INC _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2C); 
}

/* inc l' */
| label? _TK_INC _TK_L1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2C); 
}

/* inc ixl */
| label? _TK_INC _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x2C); 
}

/* inc iyl */
| label? _TK_INC _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x2C); 
}

/* inc a */
| label? _TK_INC _TK_A _TK_NEWLINE @{  
DO_stmt(0x3C); 
}

/* altd inc a */
| label? _TK_ALTD _TK_INC _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3C); 
}

/* inc a' */
| label? _TK_INC _TK_A1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3C); 
}

/* inc (hl) */
| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x34); 
}

/* inc (ix) */
| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x34) << 8); 
}

/* inc (ix + 127) */
/* inc (ix - 128) */
| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x34); 
}

/* inc (iy) */
| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x34) << 8); 
}

/* inc (iy + 127) */
/* inc (iy - 128) */
| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x34); 
}

/* dec b */
| label? _TK_DEC _TK_B _TK_NEWLINE @{  
DO_stmt(0x05); 
}

/* altd dec b */
| label? _TK_ALTD _TK_DEC _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x05); 
}

/* dec b' */
| label? _TK_DEC _TK_B1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x05); 
}

/* dec c */
| label? _TK_DEC _TK_C _TK_NEWLINE @{  
DO_stmt(0x0D); 
}

/* altd dec c */
| label? _TK_ALTD _TK_DEC _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd dec d */
| label? _TK_ALTD _TK_DEC _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x15); 
}

/* dec d' */
| label? _TK_DEC _TK_D1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x15); 
}

/* dec e */
| label? _TK_DEC _TK_E _TK_NEWLINE @{  
DO_stmt(0x1D); 
}

/* altd dec e */
| label? _TK_ALTD _TK_DEC _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd dec h */
| label? _TK_ALTD _TK_DEC _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x25); 
}

/* dec h' */
| label? _TK_DEC _TK_H1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x25); 
}

/* dec ixh */
| label? _TK_DEC _TK_IXH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x25); 
}

/* dec iyh */
| label? _TK_DEC _TK_IYH _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x25); 
}

/* dec l */
| label? _TK_DEC _TK_L _TK_NEWLINE @{  
DO_stmt(0x2D); 
}

/* altd dec l */
| label? _TK_ALTD _TK_DEC _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2D); 
}

/* dec l' */
| label? _TK_DEC _TK_L1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2D); 
}

/* dec ixl */
| label? _TK_DEC _TK_IXL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x2D); 
}

/* dec iyl */
| label? _TK_DEC _TK_IYL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x2D); 
}

/* dec a */
| label? _TK_DEC _TK_A _TK_NEWLINE @{  
DO_stmt(0x3D); 
}

/* altd dec a */
| label? _TK_ALTD _TK_DEC _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3D); 
}

/* dec a' */
| label? _TK_DEC _TK_A1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3D); 
}

/* dec (hl) */
| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(0x35); 
}

/* dec (ix) */
| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x35) << 8); 
}

/* dec (ix + 127) */
/* dec (ix - 128) */
| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x35); 
}

/* dec (iy) */
| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{  
DO_stmt(((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x35) << 8); 
}

/* dec (iy + 127) */
/* dec (iy - 128) */
| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{  
DO_stmt_idx((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x35); 
}

/* tst a, b */
| label? _TK_TST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED04); 
}

/* tst b */
| label? _TK_TST _TK_B _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED04); 
}

/* tst a, c */
| label? _TK_TST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED0C); 
}

/* tst c */
| label? _TK_TST _TK_C _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED0C); 
}

/* tst a, d */
| label? _TK_TST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED14); 
}

/* tst d */
| label? _TK_TST _TK_D _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED14); 
}

/* tst a, e */
| label? _TK_TST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED1C); 
}

/* tst e */
| label? _TK_TST _TK_E _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED1C); 
}

/* tst a, h */
| label? _TK_TST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED24); 
}

/* tst h */
| label? _TK_TST _TK_H _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED24); 
}

/* tst a, l */
| label? _TK_TST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED2C); 
}

/* tst l */
| label? _TK_TST _TK_L _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED2C); 
}

/* tst a, a */
| label? _TK_TST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED3C); 
}

/* tst a */
| label? _TK_TST _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED3C); 
}

/* tst a, (hl) */
| label? _TK_TST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED34); 
}

/* tst (hl) */
| label? _TK_TST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED34); 
}

/* tst a,  42  */
/* tst a, (42) */
| label? _TK_TST _TK_A _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt_n(0xED64); 
}

/* tst  42  */
/* tst (42) */
| label? _TK_TST expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_Z80)) != 0) { error_illegal_ident(); return FALSE; } 
DO_stmt_n(0xED64); 
}

/* daa */
| label? _TK_DAA _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_ZILOG)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x27); 
}

/* rrd */
| label? _TK_RRD _TK_NEWLINE @{  
DO_stmt_emul(0xED67, rcmx_rrd); 
}

/* rld */
| label? _TK_RLD _TK_NEWLINE @{  
DO_stmt_emul(0xED6F, rcmx_rld); 
}

/* cpl */
| label? _TK_CPL _TK_NEWLINE @{  
DO_stmt(0x2F); 
}

/* cpl a */
| label? _TK_CPL _TK_A _TK_NEWLINE @{  
DO_stmt(0x2F); 
}

/* altd cpl a */
| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2F); 
}

/* altd cpl */
| label? _TK_ALTD _TK_CPL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2F); 
}

/* cpl a' */
| label? _TK_CPL _TK_A1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x2F); 
}

/* neg */
| label? _TK_NEG _TK_NEWLINE @{  
DO_stmt(0xED44); 
}

/* neg a */
| label? _TK_NEG _TK_A _TK_NEWLINE @{  
DO_stmt(0xED44); 
}

/* altd neg a */
| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xED44); 
}

/* altd neg */
| label? _TK_ALTD _TK_NEG _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xED44); 
}

/* neg a' */
| label? _TK_NEG _TK_A1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xED44); 
}

/* ccf */
| label? _TK_CCF _TK_NEWLINE @{  
DO_stmt(0x3F); 
}

/* ccf f */
| label? _TK_CCF _TK_F _TK_NEWLINE @{  
DO_stmt(0x3F); 
}

/* altd ccf f */
| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3F); 
}

/* altd ccf */
| label? _TK_ALTD _TK_CCF _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3F); 
}

/* ccf f' */
| label? _TK_CCF _TK_F1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x3F); 
}

/* scf */
| label? _TK_SCF _TK_NEWLINE @{  
DO_stmt(0x37); 
}

/* scf f */
| label? _TK_SCF _TK_F _TK_NEWLINE @{  
DO_stmt(0x37); 
}

/* altd scf f */
| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x37); 
}

/* altd scf */
| label? _TK_ALTD _TK_SCF _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x37); 
}

/* scf f' */
| label? _TK_SCF _TK_F1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0x37); 
}

/* ld hl,  256 */
/* ld hl, (256) */
| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn(0x2A); 
} else { 
DO_stmt_nn(0x21); 
} 
}

/* altd ld hl,  256 */
/* altd ld hl, (256) */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0x2A); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x21); 
} 
}

/* ld hl',  256 */
/* ld hl', (256) */
| label? _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0x2A); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x21); 
} 
}

/* ld ix,  256 */
/* ld ix, (256) */
| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x2A); 
} else { 
DO_stmt_nn((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x21); 
} 
}

/* ld iy,  256 */
/* ld iy, (256) */
| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x2A); 
} else { 
DO_stmt_nn((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x21); 
} 
}

/* ld bc,  256 */
/* ld bc, (256) */
| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn(0xED4B); 
} else { 
DO_stmt_nn(0x01); 
} 
}

/* altd ld bc,  256 */
/* altd ld bc, (256) */
| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0xED4B); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x01); 
} 
}

/* ld bc',  256 */
/* ld bc', (256) */
| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0xED4B); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x01); 
} 
}

/* ld de,  256 */
/* ld de, (256) */
| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn(0xED5B); 
} else { 
DO_stmt_nn(0x11); 
} 
}

/* altd ld de,  256 */
/* altd ld de, (256) */
| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0xED5B); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x11); 
} 
}

/* ld de',  256 */
/* ld de', (256) */
| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
if (expr_in_parens) { 
DO_stmt(0x76); 
DO_stmt_nn(0xED5B); 
} else { 
DO_stmt(0x76); 
DO_stmt_nn(0x11); 
} 
}

/* ld sp,  256 */
/* ld sp, (256) */
| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{  
if (expr_in_parens) { 
DO_stmt_nn(0xED7B); 
} else { 
DO_stmt_nn(0x31); 
} 
}

/* ld (256), hl */
| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn(0x22); 
}

/* ld (256), ix */
| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x22); 
}

/* ld (256), iy */
| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x22); 
}

/* ld (256), bc */
| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn(0xED43); 
}

/* ld (256), de */
| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn(0xED53); 
}

/* ld (256), sp */
| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{  
if (!expr_in_parens) return FALSE; 
DO_stmt_nn(0xED73); 
}

/* ld sp, hl */
| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{  
DO_stmt(0xF9); 
}

/* ld sp, ix */
| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xF9); 
}

/* ld sp, iy */
| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xF9); 
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

/* push af */
| label? _TK_PUSH _TK_AF _TK_NEWLINE @{  
DO_stmt(0xF5); 
}

/* push ix */
| label? _TK_PUSH _TK_IX _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xE5); 
}

/* push iy */
| label? _TK_PUSH _TK_IY _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xE5); 
}

/* pop bc */
| label? _TK_POP _TK_BC _TK_NEWLINE @{  
DO_stmt(0xC1); 
}

/* altd pop bc */
| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd pop de */
| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
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

/* altd pop hl */
| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xE1); 
}

/* pop hl' */
| label? _TK_POP _TK_HL1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xE1); 
}

/* pop af */
| label? _TK_POP _TK_AF _TK_NEWLINE @{  
DO_stmt(0xF1); 
}

/* altd pop af */
| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xF1); 
}

/* pop af' */
| label? _TK_POP _TK_AF1 _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt(0xF1); 
}

/* pop ix */
| label? _TK_POP _TK_IX _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0xE1); 
}

/* pop iy */
| label? _TK_POP _TK_IY _TK_NEWLINE @{  
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0xE1); 
}

/* push ip */
| label? _TK_PUSH _TK_IP _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED76); 
}

/* pop ip */
| label? _TK_POP _TK_IP _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED7E); 
}

/* push su */
| label? _TK_PUSH _TK_SU _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED66); 
}

/* pop su */
| label? _TK_POP _TK_SU _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_R3K)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0xED6E); 
}

/* ld hl, ix */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7C); 
}

/* altd ld hl, ix */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7C); 
}

/* ld hl', ix */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IX _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7C); 
}

/* ld ix, hl */
| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xFD00 : 0xDD00) + 0x7D); 
}

/* ld hl, iy */
| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7C); 
}

/* altd ld hl, iy */
| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7C); 
}

/* ld hl', iy */
| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IY _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt(0x76); 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7C); 
}

/* ld iy, hl */
| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{ 
if ((opts.cpu & (CPU_RABBIT)) == 0) { error_illegal_ident(); return FALSE; } 
DO_stmt((opts.swap_ix_iy ? 0xDD00 : 0xFD00) + 0x7D); 
}

