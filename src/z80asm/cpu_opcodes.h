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

