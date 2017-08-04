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

