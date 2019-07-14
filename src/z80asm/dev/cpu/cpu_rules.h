| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x8F);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x88);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x89);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x8A);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x8B);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x8C);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x8E);
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8C); } else { DO_stmt(0xFD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8D); } else { DO_stmt(0xFD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8C); } else { DO_stmt(0xDD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8D); } else { DO_stmt(0xDD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x8D);
}

| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
}

| label? _TK_ADC _TK_A _TK_NEWLINE @{
DO_stmt(0x8F);
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_B _TK_NEWLINE @{
DO_stmt(0x88);
}

| label? _TK_ADC _TK_C _TK_NEWLINE @{
DO_stmt(0x89);
}

| label? _TK_ADC _TK_D _TK_NEWLINE @{
DO_stmt(0x8A);
}

| label? _TK_ADC _TK_E _TK_NEWLINE @{
DO_stmt(0x8B);
}

| label? _TK_ADC _TK_H _TK_NEWLINE @{
DO_stmt(0x8C);
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
DO_stmt(0xED4A);
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
DO_stmt(0xED5A);
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0xED6A);
}

| label? _TK_ADC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
DO_stmt(0xED7A);
}

| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x8E);
}

| label? _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8E00); } else { DO_stmt(0xFD8E00); }
}

| label? _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD8E); } else { DO_stmt_idx(0xFD8E); }
}

| label? _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8E00); } else { DO_stmt(0xDD8E00); }
}

| label? _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD8E); } else { DO_stmt_idx(0xDD8E); }
}

| label? _TK_ADC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8C); } else { DO_stmt(0xFD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD8D); } else { DO_stmt(0xFD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8C); } else { DO_stmt(0xDD8C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD8D); } else { DO_stmt(0xDD8D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_L _TK_NEWLINE @{
DO_stmt(0x8D);
}

| label? _TK_ADC expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x87);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x80);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x81);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x82);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x83);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x84);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x86);
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD84); } else { DO_stmt(0xFD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD85); } else { DO_stmt(0xFD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD84); } else { DO_stmt(0xDD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD85); } else { DO_stmt(0xDD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x85);
}

| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
}

| label? _TK_ADD _TK_A _TK_NEWLINE @{
DO_stmt(0x87);
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_B _TK_NEWLINE @{
DO_stmt(0x80);
}

| label? _TK_ADD _TK_BC _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED33);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xED36);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_C _TK_NEWLINE @{
DO_stmt(0x81);
}

| label? _TK_ADD _TK_D _TK_NEWLINE @{
DO_stmt(0x82);
}

| label? _TK_ADD _TK_DE _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED32);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xED35);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_E _TK_NEWLINE @{
DO_stmt(0x83);
}

| label? _TK_ADD _TK_H _TK_NEWLINE @{
DO_stmt(0x84);
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED31);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
DO_stmt(0x09);
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
DO_stmt(0x19);
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0x29);
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
DO_stmt(0x39);
}

| label? _TK_ADD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x86);
}

| label? _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD8600); } else { DO_stmt(0xFD8600); }
}

| label? _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD86); } else { DO_stmt_idx(0xFD86); }
}

| label? _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD8600); } else { DO_stmt(0xDD8600); }
}

| label? _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD86); } else { DO_stmt_idx(0xDD86); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_BC _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD09); } else { DO_stmt(0xFD09); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD19); } else { DO_stmt(0xFD19); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD29); } else { DO_stmt(0xFD29); }
}

| label? _TK_ADD _TK_IX _TK_COMMA _TK_SP _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD39); } else { DO_stmt(0xFD39); }
}

| label? _TK_ADD _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD84); } else { DO_stmt(0xFD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD85); } else { DO_stmt(0xFD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_BC _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD09); } else { DO_stmt(0xDD09); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD19); } else { DO_stmt(0xDD19); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD29); } else { DO_stmt(0xDD29); }
}

| label? _TK_ADD _TK_IY _TK_COMMA _TK_SP _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD39); } else { DO_stmt(0xDD39); }
}

| label? _TK_ADD _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD84); } else { DO_stmt(0xDD84); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD85); } else { DO_stmt(0xDD85); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_L _TK_NEWLINE @{
DO_stmt(0x85);
}

| label? _TK_ADD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_d(0x27);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_ADD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDDC); } else { 
DO_stmt(0xFDDC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDDC); } else { 
DO_stmt(0xDDDC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_AND expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB47+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB40+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB41+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB42+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB43+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB44+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB45+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BOOL _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BOOL _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCC); } else { 
DO_stmt(0xFDCC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_BOOL _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCC); } else { 
DO_stmt(0xDDCC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CCF _TK_F _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_CPL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DEC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DJNZ _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_jr(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_DJNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_jr(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_EX _TK_DE1 _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED54);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_INC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOE _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_IOI _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED77);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0x3A); } else { 
DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0xED4B); } else { 
DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0xED5B); } else { 
DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7C); } else { 
DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7C); } else { 
DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0x2A); } else { 
DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_NEG _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_NEG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDEC); } else { 
DO_stmt(0xFDEC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDEC); } else { 
DO_stmt(0xDDEC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_OR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_POP _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB87+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB80+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB81+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB82+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB83+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB84+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB85+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB17);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB10);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB11);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB13);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB14);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB15);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB07);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB00);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB01);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB02);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB03);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB04);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB05);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RLCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB18);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB19);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDFC); } else { 
DO_stmt(0xFDFC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDFC); } else { 
DO_stmt(0xDDFC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB08);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB09);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_RRCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED42);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED52);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED62);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED72);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SBC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SCF _TK_F _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC7+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC0+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC1+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC2+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC3+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC4+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC5+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB27);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB20);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB21);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB22);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB23);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB24);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SLA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB25);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB28);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB29);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB38);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB39);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SRL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_SUB expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_ALTD _TK_XOR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xA7);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xA0);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xA1);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xA2);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xA3);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xA4);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xA6);
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA4); } else { DO_stmt(0xFDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA5); } else { DO_stmt(0xFDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA4); } else { DO_stmt(0xDDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA5); } else { DO_stmt(0xDDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xA5);
}

| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
}

| label? _TK_AND _TK_A _TK_NEWLINE @{
DO_stmt(0xA7);
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_B _TK_NEWLINE @{
DO_stmt(0xA0);
}

| label? _TK_AND _TK_C _TK_NEWLINE @{
DO_stmt(0xA1);
}

| label? _TK_AND _TK_D _TK_NEWLINE @{
DO_stmt(0xA2);
}

| label? _TK_AND _TK_E _TK_NEWLINE @{
DO_stmt(0xA3);
}

| label? _TK_AND _TK_H _TK_NEWLINE @{
DO_stmt(0xA4);
}

| label? _TK_AND _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xA6);
}

| label? _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDA600); } else { DO_stmt(0xFDA600); }
}

| label? _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDA6); } else { DO_stmt_idx(0xFDA6); }
}

| label? _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDA600); } else { DO_stmt(0xDDA600); }
}

| label? _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDA6); } else { DO_stmt_idx(0xDDA6); }
}

| label? _TK_AND _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDDC); } else { DO_stmt(0xFDDC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA4); } else { DO_stmt(0xFDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDA5); } else { DO_stmt(0xFDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDDC); } else { DO_stmt(0xDDDC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA4); } else { DO_stmt(0xDDA4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDA5); } else { DO_stmt(0xDDA5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_L _TK_NEWLINE @{
DO_stmt(0xA5);
}

| label? _TK_AND expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
}

| label? _TK_BIT const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB47+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB40+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB41+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB42+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB43+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB44+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB44+((8*expr_value))); } else { 
DO_stmt(0xFDCB44+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB45+((8*expr_value))); } else { 
DO_stmt(0xFDCB45+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB44+((8*expr_value))); } else { 
DO_stmt(0xDDCB44+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB45+((8*expr_value))); } else { 
DO_stmt(0xDDCB45+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BIT const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB45+((8*expr_value)));
}

| label? _TK_BOOL _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_BOOL _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_BOOL _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCC); } else { DO_stmt(0xFDCC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BOOL _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCC); } else { DO_stmt(0xDDCC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_BRLC _TK_DE _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_BSLA _TK_DE _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED28);
break;
default: error_illegal_ident(); }
}

| label? _TK_BSRA _TK_DE _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED29);
break;
default: error_illegal_ident(); }
}

| label? _TK_BSRF _TK_DE _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_BSRL _TK_DE _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x3003CD);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_LO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xE2, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xEA, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xF2, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x3803CD);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NV _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xEA, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x2803CD);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_P _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xFA, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xE2, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xEA, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_V _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
Expr *target_expr = pop_expr(ctx);
const char *end_label = autolabel();
Expr *end_label_expr = parse_expr(end_label);
add_opcode_nn(0xE2, end_label_expr);
add_opcode_nn(0xCD, target_expr);
asm_LABEL_offset(end_label, 6);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_Z _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x2003CD);
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCD);
}

| label? _TK_CCF _TK_F _TK_NEWLINE @{
DO_stmt(0x3F);
}

| label? _TK_CCF _TK_F1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CCF _TK_NEWLINE @{
DO_stmt(0x3F);
}

| label? _TK_CCF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xBF);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xB8);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xB9);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xBA);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xBB);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xBC);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xBE);
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBC); } else { DO_stmt(0xFDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBD); } else { DO_stmt(0xFDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBC); } else { DO_stmt(0xDDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBD); } else { DO_stmt(0xDDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xBD);
}

| label? _TK_CP _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
}

| label? _TK_CP _TK_A _TK_NEWLINE @{
DO_stmt(0xBF);
}

| label? _TK_CP _TK_B _TK_NEWLINE @{
DO_stmt(0xB8);
}

| label? _TK_CP _TK_C _TK_NEWLINE @{
DO_stmt(0xB9);
}

| label? _TK_CP _TK_D _TK_NEWLINE @{
DO_stmt(0xBA);
}

| label? _TK_CP _TK_E _TK_NEWLINE @{
DO_stmt(0xBB);
}

| label? _TK_CP _TK_H _TK_NEWLINE @{
DO_stmt(0xBC);
}

| label? _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xBE);
}

| label? _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDBE00); } else { DO_stmt(0xFDBE00); }
}

| label? _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDBE); } else { DO_stmt_idx(0xFDBE); }
}

| label? _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDBE00); } else { DO_stmt(0xDDBE00); }
}

| label? _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDBE); } else { DO_stmt_idx(0xDDBE); }
}

| label? _TK_CP _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBC); } else { DO_stmt(0xFDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDBD); } else { DO_stmt(0xFDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBC); } else { DO_stmt(0xDDBC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDBD); } else { DO_stmt(0xDDBD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_CP _TK_L _TK_NEWLINE @{
DO_stmt(0xBD);
}

| label? _TK_CP expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
}

| label? _TK_CPD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpd");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpdr");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpi");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__cpir");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_A _TK_NEWLINE @{
DO_stmt(0x2F);
}

| label? _TK_CPL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_NEWLINE @{
DO_stmt(0x2F);
}

| label? _TK_DAA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__daa");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x27);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_A _TK_NEWLINE @{
DO_stmt(0x3D);
}

| label? _TK_DEC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_B _TK_NEWLINE @{
DO_stmt(0x05);
}

| label? _TK_DEC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_BC _TK_NEWLINE @{
DO_stmt(0x0B);
}

| label? _TK_DEC _TK_BC1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_C _TK_NEWLINE @{
DO_stmt(0x0D);
}

| label? _TK_DEC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_D _TK_NEWLINE @{
DO_stmt(0x15);
}

| label? _TK_DEC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_DE _TK_NEWLINE @{
DO_stmt(0x1B);
}

| label? _TK_DEC _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_E _TK_NEWLINE @{
DO_stmt(0x1D);
}

| label? _TK_DEC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_H _TK_NEWLINE @{
DO_stmt(0x25);
}

| label? _TK_DEC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_HL _TK_NEWLINE @{
DO_stmt(0x2B);
}

| label? _TK_DEC _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x35);
}

| label? _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD3500); } else { DO_stmt(0xFD3500); }
}

| label? _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD35); } else { DO_stmt_idx(0xFD35); }
}

| label? _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD3500); } else { DO_stmt(0xDD3500); }
}

| label? _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD35); } else { DO_stmt_idx(0xDD35); }
}

| label? _TK_DEC _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD2B); } else { DO_stmt(0xFD2B); }
}

| label? _TK_DEC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD25); } else { DO_stmt(0xFD25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD2D); } else { DO_stmt(0xFD2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD2B); } else { DO_stmt(0xDD2B); }
}

| label? _TK_DEC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD25); } else { DO_stmt(0xDD25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD2D); } else { DO_stmt(0xDD2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_L _TK_NEWLINE @{
DO_stmt(0x2D);
}

| label? _TK_DEC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_SP _TK_NEWLINE @{
DO_stmt(0x3B);
}

| label? _TK_DI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_DJNZ _TK_B _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x10);
}

| label? _TK_DJNZ _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_jr(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_DJNZ expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x10);
}

| label? _TK_EI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_AF _TK_COMMA _TK_AF _TK_NEWLINE @{
DO_stmt(0x08);
}

| label? _TK_EX _TK_AF _TK_COMMA _TK_AF1 _TK_NEWLINE @{
DO_stmt(0x08);
}

| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0xEB);
}

| label? _TK_EX _TK_DE _TK_COMMA _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_DE1 _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_DE1 _TK_COMMA _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xE3);
break;
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED54);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED54);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE3); } else { DO_stmt(0xFDE3); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE3); } else { DO_stmt(0xDDE3); }
}

| label? _TK_EXX _TK_NEWLINE @{
DO_stmt(0xD9);
}

| label? _TK_HALT _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0x76);
break;
default: error_illegal_ident(); }
}

| label? _TK_IDET _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IM const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xED00+((expr_value==0?0x46:expr_value==1?0x56:0x5E)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_A _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED78);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_n(0xDB);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_B _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED40);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_C _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED48);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_D _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED50);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_E _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED58);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_F _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_H _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED60);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_L _TK_COMMA _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED68);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED38);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED00);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED08);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED10);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED18);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_F _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED30);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED20);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED28);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN0 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED30);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_A _TK_NEWLINE @{
DO_stmt(0x3C);
}

| label? _TK_INC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_B _TK_NEWLINE @{
DO_stmt(0x04);
}

| label? _TK_INC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_BC _TK_NEWLINE @{
DO_stmt(0x03);
}

| label? _TK_INC _TK_BC1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_C _TK_NEWLINE @{
DO_stmt(0x0C);
}

| label? _TK_INC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_D _TK_NEWLINE @{
DO_stmt(0x14);
}

| label? _TK_INC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_DE _TK_NEWLINE @{
DO_stmt(0x13);
}

| label? _TK_INC _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_E _TK_NEWLINE @{
DO_stmt(0x1C);
}

| label? _TK_INC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_H _TK_NEWLINE @{
DO_stmt(0x24);
}

| label? _TK_INC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_HL _TK_NEWLINE @{
DO_stmt(0x23);
}

| label? _TK_INC _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x34);
}

| label? _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD3400); } else { DO_stmt(0xFD3400); }
}

| label? _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD34); } else { DO_stmt_idx(0xFD34); }
}

| label? _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD3400); } else { DO_stmt(0xDD3400); }
}

| label? _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD34); } else { DO_stmt_idx(0xDD34); }
}

| label? _TK_INC _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD23); } else { DO_stmt(0xFD23); }
}

| label? _TK_INC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD24); } else { DO_stmt(0xFD24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD2C); } else { DO_stmt(0xFD2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD23); } else { DO_stmt(0xDD23); }
}

| label? _TK_INC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD24); } else { DO_stmt(0xDD24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD2C); } else { DO_stmt(0xDD2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_L _TK_NEWLINE @{
DO_stmt(0x2C);
}

| label? _TK_INC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_SP _TK_NEWLINE @{
DO_stmt(0x33);
}

| label? _TK_IND _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_INDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_INI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_INIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7700); } else { 
DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7000); } else { 
DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7100); } else { 
DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7200); } else { 
DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7300); } else { 
DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7400); } else { 
DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xF400); } else { 
DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7500); } else { 
DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_n(0xDD3600); } else { 
DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD77); } else { 
DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD70); } else { 
DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD71); } else { 
DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD72); } else { 
DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD73); } else { 
DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD74); } else { 
DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xF4); } else { 
DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD75); } else { 
DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx_n(0xDD36); } else { 
DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7700); } else { 
DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7000); } else { 
DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7100); } else { 
DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7200); } else { 
DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7300); } else { 
DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7400); } else { 
DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDF400); } else { 
DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7500); } else { 
DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_n(0xFD3600); } else { 
DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD77); } else { 
DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD70); } else { 
DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD71); } else { 
DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD72); } else { 
DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD73); } else { 
DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD74); } else { 
DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDF4); } else { 
DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD75); } else { 
DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx_n(0xFD36); } else { 
DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xDD2A); } else { 
DO_stmt_nn(0xFD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xFD2A); } else { 
DO_stmt_nn(0xDD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xDD22); } else { 
DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xFD22); } else { 
DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xDB);
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDDSR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xED98);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LDISR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xED90);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LSDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LSDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LSIDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_LSIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xEDF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB86+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RES const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0086+((8*expr_value))); } else { 
DO_stmt(0xFDCB0086+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RES const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RES const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0086+((8*expr_value))); } else { 
DO_stmt(0xDDCB0086+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RES const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC6+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SET const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xFDCB00C6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SET const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SET const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xDDCB00C6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SET const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xDB);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOE _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDB);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8E00); } else { 
DO_stmt(0xFD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD8E); } else { 
DO_stmt_idx(0xFD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8E00); } else { 
DO_stmt(0xDD8E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD8E); } else { 
DO_stmt_idx(0xDD8E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD8600); } else { 
DO_stmt(0xFD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD86); } else { 
DO_stmt_idx(0xFD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD8600); } else { 
DO_stmt(0xDD8600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_ADD _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD86); } else { 
DO_stmt_idx(0xDD86); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_ALTD _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDA600); } else { 
DO_stmt(0xFDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDA6); } else { 
DO_stmt_idx(0xFDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDA600); } else { 
DO_stmt(0xDDA600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_AND _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDA6); } else { 
DO_stmt_idx(0xDDA6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB46+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0046+((8*expr_value))); } else { 
DO_stmt(0xFDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0046+((8*expr_value))); } else { 
DO_stmt(0xDDCB0046+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_BIT const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB46+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB46+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDBE00); } else { 
DO_stmt(0xFDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDBE); } else { 
DO_stmt_idx(0xFDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDBE00); } else { 
DO_stmt(0xDDBE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_CP _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDBE); } else { 
DO_stmt_idx(0xDDBE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3500); } else { 
DO_stmt(0xFD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD35); } else { 
DO_stmt_idx(0xFD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3500); } else { 
DO_stmt(0xDD3500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_DEC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD35); } else { 
DO_stmt_idx(0xDD35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD3400); } else { 
DO_stmt(0xFD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD34); } else { 
DO_stmt_idx(0xFD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD3400); } else { 
DO_stmt(0xDD3400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_INC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD34); } else { 
DO_stmt_idx(0xDD34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0xED5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7700); } else { 
DO_stmt(0xFD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7000); } else { 
DO_stmt(0xFD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7100); } else { 
DO_stmt(0xFD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7200); } else { 
DO_stmt(0xFD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7300); } else { 
DO_stmt(0xFD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7400); } else { 
DO_stmt(0xFD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xF400); } else { 
DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7500); } else { 
DO_stmt(0xFD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_n(0xDD3600); } else { 
DO_stmt_n(0xFD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD77); } else { 
DO_stmt_idx(0xFD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD70); } else { 
DO_stmt_idx(0xFD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD71); } else { 
DO_stmt_idx(0xFD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD72); } else { 
DO_stmt_idx(0xFD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD73); } else { 
DO_stmt_idx(0xFD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD74); } else { 
DO_stmt_idx(0xFD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xF4); } else { 
DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD75); } else { 
DO_stmt_idx(0xFD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx_n(0xDD36); } else { 
DO_stmt_idx_n(0xFD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7700); } else { 
DO_stmt(0xDD7700); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7000); } else { 
DO_stmt(0xDD7000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7100); } else { 
DO_stmt(0xDD7100); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7200); } else { 
DO_stmt(0xDD7200); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7300); } else { 
DO_stmt(0xDD7300); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7400); } else { 
DO_stmt(0xDD7400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDF400); } else { 
DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7500); } else { 
DO_stmt(0xDD7500); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_n(0xFD3600); } else { 
DO_stmt_n(0xDD3600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD77); } else { 
DO_stmt_idx(0xDD77); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD70); } else { 
DO_stmt_idx(0xDD70); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD71); } else { 
DO_stmt_idx(0xDD71); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD72); } else { 
DO_stmt_idx(0xDD72); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD73); } else { 
DO_stmt_idx(0xDD73); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD74); } else { 
DO_stmt_idx(0xDD74); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDF4); } else { 
DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD75); } else { 
DO_stmt_idx(0xDD75); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx_n(0xFD36); } else { 
DO_stmt_idx_n(0xDD36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xDD2A); } else { 
DO_stmt_nn(0xFD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xFD2A); } else { 
DO_stmt_nn(0xDD2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED43);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED53);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xDD22); } else { 
DO_stmt_nn(0xFD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_nn(0xFD22); } else { 
DO_stmt_nn(0xDD22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt(0xD3);
DO_stmt_nn(0xED73);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDDSR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xED98);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LDISR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xED90);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LSDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LSDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LSIDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_LSIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xEDF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB86+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RES const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0086+((8*expr_value))); } else { 
DO_stmt(0xFDCB0086+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RES const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RES const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0086+((8*expr_value))); } else { 
DO_stmt(0xDDCB0086+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RES const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB16);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0016); } else { 
DO_stmt(0xFDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB16); } else { 
DO_stmt_idx(0xFDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0016); } else { 
DO_stmt(0xDDCB0016); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB16); } else { 
DO_stmt_idx(0xDDCB16); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB06);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0006); } else { 
DO_stmt(0xFDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB06); } else { 
DO_stmt_idx(0xFDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0006); } else { 
DO_stmt(0xDDCB0006); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB06); } else { 
DO_stmt_idx(0xDDCB06); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB001E); } else { 
DO_stmt(0xFDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB1E); } else { 
DO_stmt_idx(0xFDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB001E); } else { 
DO_stmt(0xDDCB001E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB1E); } else { 
DO_stmt_idx(0xDDCB1E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB000E); } else { 
DO_stmt(0xFDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB0E); } else { 
DO_stmt_idx(0xFDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB000E); } else { 
DO_stmt(0xDDCB000E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB0E); } else { 
DO_stmt_idx(0xDDCB0E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC6+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SET const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xFDCB00C6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SET const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SET const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xDDCB00C6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SET const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0xD3);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB26);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0026); } else { 
DO_stmt(0xFDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB26); } else { 
DO_stmt_idx(0xFDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0026); } else { 
DO_stmt(0xDDCB0026); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB26); } else { 
DO_stmt_idx(0xDDCB26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB002E); } else { 
DO_stmt(0xFDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB2E); } else { 
DO_stmt_idx(0xFDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB002E); } else { 
DO_stmt(0xDDCB002E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB2E); } else { 
DO_stmt_idx(0xDDCB2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xCB3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB003E); } else { 
DO_stmt(0xFDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB3E); } else { 
DO_stmt_idx(0xFDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB003E); } else { 
DO_stmt(0xDDCB003E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB3E); } else { 
DO_stmt_idx(0xDDCB3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IOI _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD3);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_IPRES _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_IPSET const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xED00+((expr_value==0?0x46:expr_value==1?0x56:expr_value==2?0x4E:0x5E)));
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_C _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDA);
}

| label? _TK_JP _TK_IND_C _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED98);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xE9);
}

| label? _TK_JP _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE9); } else { DO_stmt(0xFDE9); }
}

| label? _TK_JP _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE9); } else { DO_stmt(0xDDE9); }
}

| label? _TK_JP _TK_LO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_LZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_M _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
}

| label? _TK_JP _TK_NC _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD2);
}

| label? _TK_JP _TK_NV _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
}

| label? _TK_JP _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC2);
}

| label? _TK_JP _TK_P _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF2);
}

| label? _TK_JP _TK_PE _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
}

| label? _TK_JP _TK_PO _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
}

| label? _TK_JP _TK_V _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
}

| label? _TK_JP _TK_Z _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCA);
}

| label? _TK_JP expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC3);
}

| label? _TK_JR _TK_C _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x38);
}

| label? _TK_JR _TK_NC _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x30);
}

| label? _TK_JR _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x20);
}

| label? _TK_JR _TK_Z _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x28);
}

| label? _TK_JR expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_jr(0x18);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x7F);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x78);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x79);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x7A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x7B);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_EIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x7C);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_I _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x0A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x1A);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x7E);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7E00); } else { DO_stmt(0xFD7E00); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD7E); } else { DO_stmt_idx(0xFD7E); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7E00); } else { DO_stmt(0xDD7E00); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD7E); } else { DO_stmt_idx(0xDD7E); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x7D);
}

| label? _TK_LD _TK_A _TK_COMMA _TK_R _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_XPC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED77);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_EIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7E00); } else { 
DO_stmt(0xFD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD7E); } else { 
DO_stmt_idx(0xFD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7E00); } else { 
DO_stmt(0xDD7E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD7E); } else { 
DO_stmt_idx(0xDD7E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA _TK_XPC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED77);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0x3A); } else { 
DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x47);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x40);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x41);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x42);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x43);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x44);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x46);
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD4600); } else { DO_stmt(0xFD4600); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD46); } else { DO_stmt_idx(0xFD46); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD4600); } else { DO_stmt(0xDD4600); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD46); } else { DO_stmt_idx(0xDD46); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD44); } else { DO_stmt(0xFD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD45); } else { DO_stmt(0xFD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD44); } else { DO_stmt(0xDD44); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD45); } else { DO_stmt(0xDD45); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x45);
}

| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4600); } else { 
DO_stmt(0xFD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD46); } else { 
DO_stmt_idx(0xFD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4600); } else { 
DO_stmt(0xDD4600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD46); } else { 
DO_stmt_idx(0xDD46); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED4B); } else { DO_stmt_nn(0x01); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0xED4B); } else { 
DO_stmt_nn(0x01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x4F);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x48);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x49);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x4A);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x4B);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x4C);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x4E);
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD4E00); } else { DO_stmt(0xFD4E00); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD4E); } else { DO_stmt_idx(0xFD4E); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD4E00); } else { DO_stmt(0xDD4E00); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD4E); } else { DO_stmt_idx(0xDD4E); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4C); } else { DO_stmt(0xFD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD4D); } else { DO_stmt(0xFD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4C); } else { DO_stmt(0xDD4C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD4D); } else { DO_stmt(0xDD4D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x4D);
}

| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD4E00); } else { 
DO_stmt(0xFD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD4E); } else { 
DO_stmt_idx(0xFD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD4E00); } else { 
DO_stmt(0xDD4E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD4E); } else { 
DO_stmt_idx(0xDD4E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x57);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x50);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x51);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x52);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x53);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x54);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x56);
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD5600); } else { DO_stmt(0xFD5600); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD56); } else { DO_stmt_idx(0xFD56); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD5600); } else { DO_stmt(0xDD5600); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD56); } else { DO_stmt_idx(0xDD56); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD54); } else { DO_stmt(0xFD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD55); } else { DO_stmt(0xFD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD54); } else { DO_stmt(0xDD54); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD55); } else { DO_stmt(0xDD55); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x55);
}

| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5600); } else { 
DO_stmt(0xFD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD56); } else { 
DO_stmt_idx(0xFD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5600); } else { 
DO_stmt(0xDD5600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD56); } else { 
DO_stmt_idx(0xDD56); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED5B); } else { DO_stmt_nn(0x11); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0xED5B); } else { 
DO_stmt_nn(0x11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x5F);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x58);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x59);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x5A);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x5B);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x5C);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x5E);
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD5E00); } else { DO_stmt(0xFD5E00); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD5E); } else { DO_stmt_idx(0xFD5E); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD5E00); } else { DO_stmt(0xDD5E00); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD5E); } else { DO_stmt_idx(0xDD5E); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5C); } else { DO_stmt(0xFD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD5D); } else { DO_stmt(0xFD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5C); } else { DO_stmt(0xDD5C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD5D); } else { DO_stmt(0xDD5D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x5D);
}

| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD5E00); } else { 
DO_stmt(0xFD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD5E); } else { 
DO_stmt_idx(0xFD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD5E00); } else { 
DO_stmt(0xDD5E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD5E); } else { 
DO_stmt_idx(0xDD5E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_EIR _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x67);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x60);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x61);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x62);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x63);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x64);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x66);
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD6600); } else { DO_stmt(0xFD6600); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD66); } else { DO_stmt_idx(0xFD66); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD6600); } else { DO_stmt(0xDD6600); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD66); } else { DO_stmt_idx(0xDD66); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x65);
}

| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6600); } else { 
DO_stmt(0xFD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD66); } else { 
DO_stmt_idx(0xFD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6600); } else { 
DO_stmt(0xDD6600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD66); } else { 
DO_stmt_idx(0xDD66); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xE400); } else { DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xE4); } else { DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDE400); } else { DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDE4); } else { DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7C); } else { DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7C); } else { DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xDDE400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_HL expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_idx(0xDDE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xE400); } else { 
DO_stmt(0xFDE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xE4); } else { 
DO_stmt_idx(0xFDE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDE400); } else { 
DO_stmt(0xE400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDE4); } else { 
DO_stmt_idx(0xE4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt_n(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD7C); } else { 
DO_stmt(0xFD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD7C); } else { 
DO_stmt(0xDD7C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (expr_in_parens) { 
DO_stmt_nn(0x2A); } else { 
DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_I _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IIR _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x02);
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x12);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x77);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x70);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x71);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x72);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x73);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x74);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xDDF400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x75);
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
}

| label? _TK_LD _TK_IND_HL expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_idx(0xDDF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7700); } else { DO_stmt(0xFD7700); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7000); } else { DO_stmt(0xFD7000); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7100); } else { DO_stmt(0xFD7100); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7200); } else { DO_stmt(0xFD7200); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7300); } else { DO_stmt(0xFD7300); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7400); } else { DO_stmt(0xFD7400); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xF400); } else { DO_stmt(0xFDF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD7500); } else { DO_stmt(0xFD7500); }
}

| label? _TK_LD _TK_IND_IX _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD3600); } else { DO_stmt_n(0xFD3600); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD77); } else { DO_stmt_idx(0xFD77); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD70); } else { DO_stmt_idx(0xFD70); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD71); } else { DO_stmt_idx(0xFD71); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD72); } else { DO_stmt_idx(0xFD72); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD73); } else { DO_stmt_idx(0xFD73); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD74); } else { DO_stmt_idx(0xFD74); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xF4); } else { DO_stmt_idx(0xFDF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD75); } else { DO_stmt_idx(0xFD75); }
}

| label? _TK_LD _TK_IND_IX expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xDD36); } else { DO_stmt_idx_n(0xFD36); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7700); } else { DO_stmt(0xDD7700); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7000); } else { DO_stmt(0xDD7000); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7100); } else { DO_stmt(0xDD7100); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7200); } else { DO_stmt(0xDD7200); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7300); } else { DO_stmt(0xDD7300); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7400); } else { DO_stmt(0xDD7400); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDF400); } else { DO_stmt(0xF400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD7500); } else { DO_stmt(0xDD7500); }
}

| label? _TK_LD _TK_IND_IY _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD3600); } else { DO_stmt_n(0xDD3600); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD77); } else { DO_stmt_idx(0xDD77); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD70); } else { DO_stmt_idx(0xDD70); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD71); } else { DO_stmt_idx(0xDD71); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD72); } else { DO_stmt_idx(0xDD72); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD73); } else { DO_stmt_idx(0xDD73); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD74); } else { DO_stmt_idx(0xDD74); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDF4); } else { DO_stmt_idx(0xF4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD75); } else { DO_stmt_idx(0xDD75); }
}

| label? _TK_LD _TK_IND_IY expr _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_idx_n(0xFD36); } else { DO_stmt_idx_n(0xDD36); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xD400);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDD400); } else { DO_stmt(0xFDD400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDD400); } else { DO_stmt(0xDDD400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt_n(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDDD4); } else { DO_stmt_n(0xFDD4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_SP expr _TK_RPAREN _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFDD4); } else { DO_stmt_n(0xDDD4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD7D); } else { DO_stmt(0xFD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDC400); } else { DO_stmt(0xFDC400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xDDC4); } else { DO_stmt_n(0xFDC4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IX _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD2A); } else { DO_stmt_nn(0xFD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD21); } else { DO_stmt_nn(0xFD21); } }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD67); } else { DO_stmt(0xFD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD60); } else { DO_stmt(0xFD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD61); } else { DO_stmt(0xFD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD62); } else { DO_stmt(0xFD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD63); } else { DO_stmt(0xFD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD65); } else { DO_stmt(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD26); } else { DO_stmt_n(0xFD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6F); } else { DO_stmt(0xFD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD68); } else { DO_stmt(0xFD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD69); } else { DO_stmt(0xFD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6A); } else { DO_stmt(0xFD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6B); } else { DO_stmt(0xFD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6D); } else { DO_stmt(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IXL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xDD2E); } else { DO_stmt_n(0xFD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD7D); } else { DO_stmt(0xDD7D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDC400); } else { DO_stmt(0xDDC400); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA _TK_IND_SP expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt_n(0xFDC4); } else { DO_stmt_n(0xDDC4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IY _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD2A); } else { DO_stmt_nn(0xDD2A); } } else { if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD21); } else { DO_stmt_nn(0xDD21); } }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD67); } else { DO_stmt(0xDD67); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD60); } else { DO_stmt(0xDD60); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD61); } else { DO_stmt(0xDD61); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD62); } else { DO_stmt(0xDD62); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD63); } else { DO_stmt(0xDD63); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD65); } else { DO_stmt(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYH _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD26); } else { DO_stmt_n(0xDD26); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6F); } else { DO_stmt(0xDD6F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD68); } else { DO_stmt(0xDD68); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD69); } else { DO_stmt(0xDD69); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6A); } else { DO_stmt(0xDD6A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6B); } else { DO_stmt(0xDD6B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6D); } else { DO_stmt(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IYL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (!opts.swap_ix_iy) { DO_stmt_n(0xFD2E); } else { DO_stmt_n(0xDD2E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x6F);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x68);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x69);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x6A);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x6B);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x6C);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x6E);
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD6E00); } else { DO_stmt(0xFD6E00); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD6E); } else { DO_stmt_idx(0xFD6E); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD6E00); } else { DO_stmt(0xDD6E00); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD6E); } else { DO_stmt_idx(0xDD6E); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x6D);
}

| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD6E00); } else { 
DO_stmt(0xFD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD6E); } else { 
DO_stmt_idx(0xFD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD6E00); } else { 
DO_stmt(0xDD6E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD6E); } else { 
DO_stmt_idx(0xDD6E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_R _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0xF9);
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDF9); } else { DO_stmt(0xFDF9); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDF9); } else { DO_stmt(0xDDF9); }
}

| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) { DO_stmt_nn(0xED7B); } else { DO_stmt_nn(0x31); }
}

| label? _TK_LD _TK_XPC _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
if (!expr_in_parens) return false;
DO_stmt_nn(0x32);
}

| label? _TK_LD expr _TK_COMMA _TK_BC _TK_NEWLINE @{
if (!expr_in_parens) return false;
DO_stmt_nn(0xED43);
}

| label? _TK_LD expr _TK_COMMA _TK_DE _TK_NEWLINE @{
if (!expr_in_parens) return false;
DO_stmt_nn(0xED53);
}

| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
if (!expr_in_parens) return false;
DO_stmt_nn(0x22);
}

| label? _TK_LD expr _TK_COMMA _TK_IX _TK_NEWLINE @{
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD22); } else { DO_stmt_nn(0xFD22); }
}

| label? _TK_LD expr _TK_COMMA _TK_IY _TK_NEWLINE @{
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD22); } else { DO_stmt_nn(0xDD22); }
}

| label? _TK_LD expr _TK_COMMA _TK_SP _TK_NEWLINE @{
if (!expr_in_parens) return false;
DO_stmt_nn(0xED73);
}

| label? _TK_LDD _TK_NEWLINE @{
DO_stmt(0xEDA8);
}

| label? _TK_LDDR _TK_NEWLINE @{
DO_stmt(0xEDB8);
}

| label? _TK_LDDRX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDDSR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED98);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDDX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDI _TK_NEWLINE @{
DO_stmt(0xEDA0);
}

| label? _TK_LDIR _TK_NEWLINE @{
DO_stmt(0xEDB0);
}

| label? _TK_LDIRX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDISR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED90);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDIX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD6C); } else { DO_stmt(0xFD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD6C); } else { DO_stmt(0xDD6C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD64); } else { DO_stmt(0xFD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD64); } else { DO_stmt(0xDD64); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IX _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD6D); } else { DO_stmt_nn(0xFD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP _TK_IY _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD6D); } else { DO_stmt_nn(0xDD6D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
DO_stmt_nn(0xED65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xDD65); } else { DO_stmt_nn(0xFD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDP expr _TK_COMMA _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!expr_in_parens) return false;
if (!opts.swap_ix_iy) { DO_stmt_nn(0xFD65); } else { DO_stmt_nn(0xDD65); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LDPIRX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDWS _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xEDA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_LSDDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LSDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_LSIDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_LSIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_MIRROR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_MLT _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MLT _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED30);
break;
case CPU_Z180: 
DO_stmt(0xED5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MLT _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MLT _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); } else {
if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);
DO_stmt(0xED9250 + expr_value);}
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU const_expr _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); } else {
if (expr_value < 0 || expr_value > 7) error_int_range(expr_value);
DO_stmt_n(0xED9150 + expr_value);}
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU0 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9250);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU0 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9150);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU1 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9251);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU1 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9151);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU2 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9252);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU2 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9152);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU3 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9253);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU3 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9153);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU4 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9254);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU4 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9154);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU5 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9255);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU5 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9155);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU6 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9256);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU6 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9156);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU7 _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED9257);
break;
default: error_illegal_ident(); }
}

| label? _TK_MMU7 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED9157);
break;
default: error_illegal_ident(); }
}

| label? _TK_MUL _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED30);
break;
default: error_illegal_ident(); }
}

| label? _TK_MUL _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED30);
break;
default: error_illegal_ident(); }
}

| label? _TK_MUL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xF7);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_A _TK_NEWLINE @{
DO_stmt(0xED44);
}

| label? _TK_NEG _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED44);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEG _TK_NEWLINE @{
DO_stmt(0xED44);
}

| label? _TK_NEXTREG expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED92);
break;
default: error_illegal_ident(); }
}

| label? _TK_NEXTREG expr _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n_n(0xED91);
break;
default: error_illegal_ident(); }
}

| label? _TK_NOP _TK_NEWLINE @{
DO_stmt(0x00);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xB7);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xB0);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xB1);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xB2);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xB3);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xB4);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xB6);
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB4); } else { DO_stmt(0xFDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB5); } else { DO_stmt(0xFDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB4); } else { DO_stmt(0xDDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB5); } else { DO_stmt(0xDDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xB5);
}

| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
}

| label? _TK_OR _TK_A _TK_NEWLINE @{
DO_stmt(0xB7);
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDB600); } else { 
DO_stmt(0xFDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDB6); } else { 
DO_stmt_idx(0xFDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDB600); } else { 
DO_stmt(0xDDB600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDB6); } else { 
DO_stmt_idx(0xDDB6); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_B _TK_NEWLINE @{
DO_stmt(0xB0);
}

| label? _TK_OR _TK_C _TK_NEWLINE @{
DO_stmt(0xB1);
}

| label? _TK_OR _TK_D _TK_NEWLINE @{
DO_stmt(0xB2);
}

| label? _TK_OR _TK_E _TK_NEWLINE @{
DO_stmt(0xB3);
}

| label? _TK_OR _TK_H _TK_NEWLINE @{
DO_stmt(0xB4);
}

| label? _TK_OR _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xB6);
}

| label? _TK_OR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDB600); } else { DO_stmt(0xFDB600); }
}

| label? _TK_OR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDB6); } else { DO_stmt_idx(0xFDB6); }
}

| label? _TK_OR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDB600); } else { DO_stmt(0xDDB600); }
}

| label? _TK_OR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDB6); } else { DO_stmt_idx(0xDDB6); }
}

| label? _TK_OR _TK_IX _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDEC); } else { DO_stmt(0xFDEC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB4); } else { DO_stmt(0xFDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDB5); } else { DO_stmt(0xFDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IY _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDEC); } else { DO_stmt(0xDDEC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB4); } else { DO_stmt(0xDDB4); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDB5); } else { DO_stmt(0xDDB5); }
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_L _TK_NEWLINE @{
DO_stmt(0xB5);
}

| label? _TK_OR expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
}

| label? _TK_OTDM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTDMR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTDR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTIM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED83);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTIMR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED93);
break;
default: error_illegal_ident(); }
}

| label? _TK_OTIR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED79);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED41);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED49);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED51);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED59);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED61);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED69);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT _TK_IND_C _TK_RPAREN _TK_COMMA const_expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xED00+((0x41+expr_value+6*8)));
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!expr_in_parens) return false;
DO_stmt_n(0xD3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED39);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED01);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED09);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED11);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED19);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED21);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT0 expr _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!expr_in_parens) return false;
DO_stmt_n(0xED29);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUTD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUTI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xEDA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUTINB _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED90);
break;
default: error_illegal_ident(); }
}

| label? _TK_PIXELAD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED94);
break;
default: error_illegal_ident(); }
}

| label? _TK_PIXELDN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED93);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_AF _TK_NEWLINE @{
DO_stmt(0xF1);
}

| label? _TK_POP _TK_AF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_BC _TK_NEWLINE @{
DO_stmt(0xC1);
}

| label? _TK_POP _TK_BC1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_DE _TK_NEWLINE @{
DO_stmt(0xD1);
}

| label? _TK_POP _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_HL _TK_NEWLINE @{
DO_stmt(0xE1);
}

| label? _TK_POP _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE1); } else { DO_stmt(0xFDE1); }
}

| label? _TK_POP _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE1); } else { DO_stmt(0xDDE1); }
}

| label? _TK_POP _TK_SU _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
DO_stmt(0xF5);
}

| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
DO_stmt(0xC5);
}

| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
DO_stmt(0xD5);
}

| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
DO_stmt(0xE5);
}

| label? _TK_PUSH _TK_IP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xED76);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_IX _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDE5); } else { DO_stmt(0xFDE5); }
}

| label? _TK_PUSH _TK_IY _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDE5); } else { DO_stmt(0xDDE5); }
}

| label? _TK_PUSH _TK_SU _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED66);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt_NN(0xED8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_RDMODE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB87+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB87+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB80+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB80+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB81+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB81+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB82+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB82+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB83+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB83+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB84+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB84+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB86+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB0086+((8*expr_value))); } else { 
DO_stmt(0xFDCB0086+((8*expr_value))); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB0086+((8*expr_value))); } else { 
DO_stmt(0xDDCB0086+((8*expr_value))); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCB86+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCB86+((8*expr_value))); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB84+((8*expr_value))); } else { 
DO_stmt(0xFDCB84+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB85+((8*expr_value))); } else { 
DO_stmt(0xFDCB85+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB84+((8*expr_value))); } else { 
DO_stmt(0xDDCB84+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB85+((8*expr_value))); } else { 
DO_stmt(0xDDCB85+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RES const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB85+((8*expr_value)));
}

| label? _TK_RES const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCB85+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_C _TK_NEWLINE @{
DO_stmt(0xD8);
}

| label? _TK_RET _TK_LO _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_LZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_M _TK_NEWLINE @{
DO_stmt(0xF8);
}

| label? _TK_RET _TK_NC _TK_NEWLINE @{
DO_stmt(0xD0);
}

| label? _TK_RET _TK_NEWLINE @{
DO_stmt(0xC9);
}

| label? _TK_RET _TK_NV _TK_NEWLINE @{
DO_stmt(0xE0);
}

| label? _TK_RET _TK_NZ _TK_NEWLINE @{
DO_stmt(0xC0);
}

| label? _TK_RET _TK_P _TK_NEWLINE @{
DO_stmt(0xF0);
}

| label? _TK_RET _TK_PE _TK_NEWLINE @{
DO_stmt(0xE8);
}

| label? _TK_RET _TK_PO _TK_NEWLINE @{
DO_stmt(0xE0);
}

| label? _TK_RET _TK_V _TK_NEWLINE @{
DO_stmt(0xE8);
}

| label? _TK_RET _TK_Z _TK_NEWLINE @{
DO_stmt(0xC8);
}

| label? _TK_RETI _TK_NEWLINE @{
DO_stmt(0xED4D);
}

| label? _TK_RETN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED45);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_A _TK_NEWLINE @{
DO_stmt(0xCB17);
}

| label? _TK_RL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_B _TK_NEWLINE @{
DO_stmt(0xCB10);
}

| label? _TK_RL _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB10);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_C _TK_NEWLINE @{
DO_stmt(0xCB11);
}

| label? _TK_RL _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB11);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_D _TK_NEWLINE @{
DO_stmt(0xCB12);
}

| label? _TK_RL _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB12);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_E _TK_NEWLINE @{
DO_stmt(0xCB13);
}

| label? _TK_RL _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB13);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_H _TK_NEWLINE @{
DO_stmt(0xCB14);
}

| label? _TK_RL _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB14);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB16);
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0017); } else { DO_stmt(0xFDCB0017); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0010); } else { DO_stmt(0xFDCB0010); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0011); } else { DO_stmt(0xFDCB0011); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0012); } else { DO_stmt(0xFDCB0012); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0013); } else { DO_stmt(0xFDCB0013); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0014); } else { DO_stmt(0xFDCB0014); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0015); } else { DO_stmt(0xFDCB0015); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0016); } else { DO_stmt(0xFDCB0016); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB17); } else { DO_stmt_idx(0xFDCB17); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB10); } else { DO_stmt_idx(0xFDCB10); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB11); } else { DO_stmt_idx(0xFDCB11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB12); } else { DO_stmt_idx(0xFDCB12); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB13); } else { DO_stmt_idx(0xFDCB13); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB14); } else { DO_stmt_idx(0xFDCB14); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB15); } else { DO_stmt_idx(0xFDCB15); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB16); } else { DO_stmt_idx(0xFDCB16); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0017); } else { DO_stmt(0xDDCB0017); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0010); } else { DO_stmt(0xDDCB0010); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0011); } else { DO_stmt(0xDDCB0011); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0012); } else { DO_stmt(0xDDCB0012); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0013); } else { DO_stmt(0xDDCB0013); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0014); } else { DO_stmt(0xDDCB0014); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0015); } else { DO_stmt(0xDDCB0015); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0016); } else { DO_stmt(0xDDCB0016); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB17); } else { DO_stmt_idx(0xDDCB17); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB10); } else { DO_stmt_idx(0xDDCB10); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB11); } else { DO_stmt_idx(0xDDCB11); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB12); } else { DO_stmt_idx(0xDDCB12); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB13); } else { DO_stmt_idx(0xDDCB13); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB14); } else { DO_stmt_idx(0xDDCB14); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB15); } else { DO_stmt_idx(0xDDCB15); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB16); } else { DO_stmt_idx(0xDDCB16); }
}

| label? _TK_RL _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB14); } else { DO_stmt(0xFDCB14); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB15); } else { DO_stmt(0xFDCB15); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB14); } else { DO_stmt(0xDDCB14); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB15); } else { DO_stmt(0xDDCB15); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_L _TK_NEWLINE @{
DO_stmt(0xCB15);
}

| label? _TK_RL _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB15);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLA _TK_NEWLINE @{
DO_stmt(0x17);
}

| label? _TK_RLA1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_A _TK_NEWLINE @{
DO_stmt(0xCB07);
}

| label? _TK_RLC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_B _TK_NEWLINE @{
DO_stmt(0xCB00);
}

| label? _TK_RLC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB00);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_C _TK_NEWLINE @{
DO_stmt(0xCB01);
}

| label? _TK_RLC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB01);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_D _TK_NEWLINE @{
DO_stmt(0xCB02);
}

| label? _TK_RLC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB02);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_E _TK_NEWLINE @{
DO_stmt(0xCB03);
}

| label? _TK_RLC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB03);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_H _TK_NEWLINE @{
DO_stmt(0xCB04);
}

| label? _TK_RLC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB04);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB06);
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0007); } else { DO_stmt(0xFDCB0007); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0000); } else { DO_stmt(0xFDCB0000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0001); } else { DO_stmt(0xFDCB0001); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0002); } else { DO_stmt(0xFDCB0002); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0003); } else { DO_stmt(0xFDCB0003); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0004); } else { DO_stmt(0xFDCB0004); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0005); } else { DO_stmt(0xFDCB0005); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0006); } else { DO_stmt(0xFDCB0006); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB07); } else { DO_stmt_idx(0xFDCB07); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB00); } else { DO_stmt_idx(0xFDCB00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB01); } else { DO_stmt_idx(0xFDCB01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB02); } else { DO_stmt_idx(0xFDCB02); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB03); } else { DO_stmt_idx(0xFDCB03); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB04); } else { DO_stmt_idx(0xFDCB04); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB05); } else { DO_stmt_idx(0xFDCB05); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB06); } else { DO_stmt_idx(0xFDCB06); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0007); } else { DO_stmt(0xDDCB0007); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0000); } else { DO_stmt(0xDDCB0000); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0001); } else { DO_stmt(0xDDCB0001); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0002); } else { DO_stmt(0xDDCB0002); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0003); } else { DO_stmt(0xDDCB0003); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0004); } else { DO_stmt(0xDDCB0004); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0005); } else { DO_stmt(0xDDCB0005); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0006); } else { DO_stmt(0xDDCB0006); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB07); } else { DO_stmt_idx(0xDDCB07); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB00); } else { DO_stmt_idx(0xDDCB00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB01); } else { DO_stmt_idx(0xDDCB01); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB02); } else { DO_stmt_idx(0xDDCB02); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB03); } else { DO_stmt_idx(0xDDCB03); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB04); } else { DO_stmt_idx(0xDDCB04); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB05); } else { DO_stmt_idx(0xDDCB05); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB06); } else { DO_stmt_idx(0xDDCB06); }
}

| label? _TK_RLC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB04); } else { DO_stmt(0xFDCB04); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB05); } else { DO_stmt(0xFDCB05); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB04); } else { DO_stmt(0xDDCB04); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB05); } else { DO_stmt(0xDDCB05); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_L _TK_NEWLINE @{
DO_stmt(0xCB05);
}

| label? _TK_RLC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB05);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLCA _TK_NEWLINE @{
DO_stmt(0x07);
}

| label? _TK_RLCA1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rld");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_A _TK_NEWLINE @{
DO_stmt(0xCB1F);
}

| label? _TK_RR _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_B _TK_NEWLINE @{
DO_stmt(0xCB18);
}

| label? _TK_RR _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB18);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_C _TK_NEWLINE @{
DO_stmt(0xCB19);
}

| label? _TK_RR _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB19);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_D _TK_NEWLINE @{
DO_stmt(0xCB1A);
}

| label? _TK_RR _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_DE1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_E _TK_NEWLINE @{
DO_stmt(0xCB1B);
}

| label? _TK_RR _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_H _TK_NEWLINE @{
DO_stmt(0xCB1C);
}

| label? _TK_RR _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_HL1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB1E);
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001F); } else { DO_stmt(0xFDCB001F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0018); } else { DO_stmt(0xFDCB0018); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0019); } else { DO_stmt(0xFDCB0019); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001A); } else { DO_stmt(0xFDCB001A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001B); } else { DO_stmt(0xFDCB001B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001C); } else { DO_stmt(0xFDCB001C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001D); } else { DO_stmt(0xFDCB001D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB001E); } else { DO_stmt(0xFDCB001E); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1F); } else { DO_stmt_idx(0xFDCB1F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB18); } else { DO_stmt_idx(0xFDCB18); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB19); } else { DO_stmt_idx(0xFDCB19); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1A); } else { DO_stmt_idx(0xFDCB1A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1B); } else { DO_stmt_idx(0xFDCB1B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1C); } else { DO_stmt_idx(0xFDCB1C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1D); } else { DO_stmt_idx(0xFDCB1D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB1E); } else { DO_stmt_idx(0xFDCB1E); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001F); } else { DO_stmt(0xDDCB001F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0018); } else { DO_stmt(0xDDCB0018); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0019); } else { DO_stmt(0xDDCB0019); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001A); } else { DO_stmt(0xDDCB001A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001B); } else { DO_stmt(0xDDCB001B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001C); } else { DO_stmt(0xDDCB001C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001D); } else { DO_stmt(0xDDCB001D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB001E); } else { DO_stmt(0xDDCB001E); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1F); } else { DO_stmt_idx(0xDDCB1F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB18); } else { DO_stmt_idx(0xDDCB18); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB19); } else { DO_stmt_idx(0xDDCB19); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1A); } else { DO_stmt_idx(0xDDCB1A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1B); } else { DO_stmt_idx(0xDDCB1B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1C); } else { DO_stmt_idx(0xDDCB1C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1D); } else { DO_stmt_idx(0xDDCB1D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB1E); } else { DO_stmt_idx(0xDDCB1E); }
}

| label? _TK_RR _TK_IX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDFC); } else { DO_stmt(0xFDFC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB1C); } else { DO_stmt(0xFDCB1C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB1D); } else { DO_stmt(0xFDCB1D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IY _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDFC); } else { DO_stmt(0xDDFC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB1C); } else { DO_stmt(0xDDCB1C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB1D); } else { DO_stmt(0xDDCB1D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RR _TK_L _TK_NEWLINE @{
DO_stmt(0xCB1D);
}

| label? _TK_RR _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRA _TK_NEWLINE @{
DO_stmt(0x1F);
}

| label? _TK_RRA1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_A _TK_NEWLINE @{
DO_stmt(0xCB0F);
}

| label? _TK_RRC _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_B _TK_NEWLINE @{
DO_stmt(0xCB08);
}

| label? _TK_RRC _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB08);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_C _TK_NEWLINE @{
DO_stmt(0xCB09);
}

| label? _TK_RRC _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB09);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_D _TK_NEWLINE @{
DO_stmt(0xCB0A);
}

| label? _TK_RRC _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_E _TK_NEWLINE @{
DO_stmt(0xCB0B);
}

| label? _TK_RRC _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_H _TK_NEWLINE @{
DO_stmt(0xCB0C);
}

| label? _TK_RRC _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB0E);
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000F); } else { DO_stmt(0xFDCB000F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0008); } else { DO_stmt(0xFDCB0008); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0009); } else { DO_stmt(0xFDCB0009); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000A); } else { DO_stmt(0xFDCB000A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000B); } else { DO_stmt(0xFDCB000B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000C); } else { DO_stmt(0xFDCB000C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000D); } else { DO_stmt(0xFDCB000D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB000E); } else { DO_stmt(0xFDCB000E); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0F); } else { DO_stmt_idx(0xFDCB0F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB08); } else { DO_stmt_idx(0xFDCB08); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB09); } else { DO_stmt_idx(0xFDCB09); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0A); } else { DO_stmt_idx(0xFDCB0A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0B); } else { DO_stmt_idx(0xFDCB0B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0C); } else { DO_stmt_idx(0xFDCB0C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0D); } else { DO_stmt_idx(0xFDCB0D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB0E); } else { DO_stmt_idx(0xFDCB0E); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000F); } else { DO_stmt(0xDDCB000F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0008); } else { DO_stmt(0xDDCB0008); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0009); } else { DO_stmt(0xDDCB0009); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000A); } else { DO_stmt(0xDDCB000A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000B); } else { DO_stmt(0xDDCB000B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000C); } else { DO_stmt(0xDDCB000C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000D); } else { DO_stmt(0xDDCB000D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB000E); } else { DO_stmt(0xDDCB000E); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0F); } else { DO_stmt_idx(0xDDCB0F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB08); } else { DO_stmt_idx(0xDDCB08); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB09); } else { DO_stmt_idx(0xDDCB09); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0A); } else { DO_stmt_idx(0xDDCB0A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0B); } else { DO_stmt_idx(0xDDCB0B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0C); } else { DO_stmt_idx(0xDDCB0C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0D); } else { DO_stmt_idx(0xDDCB0D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB0E); } else { DO_stmt_idx(0xDDCB0E); }
}

| label? _TK_RRC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0C); } else { DO_stmt(0xFDCB0C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0D); } else { DO_stmt(0xFDCB0D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0C); } else { DO_stmt(0xDDCB0C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0D); } else { DO_stmt(0xDDCB0D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_L _TK_NEWLINE @{
DO_stmt(0xCB0D);
}

| label? _TK_RRC _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRCA _TK_NEWLINE @{
DO_stmt(0x0F);
}

| label? _TK_RRCA1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRD _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_STMT_LABEL();
add_call_emul_func("__z80asm__rrd");
break;
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xED67);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST const_expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_STMT_LABEL();
if (expr_error) { error_expected_const_expr(); } else {
if (expr_value > 0 && expr_value < 8) expr_value *= 8;
switch (expr_value) {
case 0x00: case 0x08: case 0x30:
  if (opts.cpu & CPU_RABBIT)
    DO_stmt(0xCD0000 + (expr_value << 8));
  else
    DO_stmt(0xC7 + expr_value);
  break;
case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
  DO_stmt(0xC7 + expr_value); break;
default: error_int_range(expr_value);
}}
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x9F);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x98);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x99);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x9A);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x9B);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x9C);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x9E);
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9C); } else { DO_stmt(0xFD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9D); } else { DO_stmt(0xFD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9C); } else { DO_stmt(0xDD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9D); } else { DO_stmt(0xDD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x9D);
}

| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
}

| label? _TK_SBC _TK_A _TK_NEWLINE @{
DO_stmt(0x9F);
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9E00); } else { 
DO_stmt(0xFD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD9E); } else { 
DO_stmt_idx(0xFD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9E00); } else { 
DO_stmt(0xDD9E00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD9E); } else { 
DO_stmt_idx(0xDD9E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_B _TK_NEWLINE @{
DO_stmt(0x98);
}

| label? _TK_SBC _TK_C _TK_NEWLINE @{
DO_stmt(0x99);
}

| label? _TK_SBC _TK_D _TK_NEWLINE @{
DO_stmt(0x9A);
}

| label? _TK_SBC _TK_E _TK_NEWLINE @{
DO_stmt(0x9B);
}

| label? _TK_SBC _TK_H _TK_NEWLINE @{
DO_stmt(0x9C);
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
DO_stmt(0xED42);
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
DO_stmt(0xED52);
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
DO_stmt(0xED62);
}

| label? _TK_SBC _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
DO_stmt(0xED72);
}

| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED42);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED52);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED62);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_HL1 _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xED72);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x9E);
}

| label? _TK_SBC _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9E00); } else { DO_stmt(0xFD9E00); }
}

| label? _TK_SBC _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD9E); } else { DO_stmt_idx(0xFD9E); }
}

| label? _TK_SBC _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9E00); } else { DO_stmt(0xDD9E00); }
}

| label? _TK_SBC _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD9E); } else { DO_stmt_idx(0xDD9E); }
}

| label? _TK_SBC _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9C); } else { DO_stmt(0xFD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD9D); } else { DO_stmt(0xFD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9C); } else { DO_stmt(0xDD9C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD9D); } else { DO_stmt(0xDD9D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_L _TK_NEWLINE @{
DO_stmt(0x9D);
}

| label? _TK_SBC expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
}

| label? _TK_SCF _TK_F _TK_NEWLINE @{
DO_stmt(0x37);
}

| label? _TK_SCF _TK_F1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SCF _TK_NEWLINE @{
DO_stmt(0x37);
}

| label? _TK_SCF1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_A _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC7+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC7+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_B _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC0+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC0+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_C _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC1+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC1+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_D _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC2+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC2+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_E _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC3+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC3+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_H _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC4+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC4+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC6+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xFDCB00C6+((8*expr_value))); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCB00C6+((8*expr_value))); } else { 
DO_stmt(0xDDCB00C6+((8*expr_value))); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDCBC6+((8*expr_value))); } else { 
DO_stmt_idx(0xDDCBC6+((8*expr_value))); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCBC4+((8*expr_value))); } else { 
DO_stmt(0xFDCBC4+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDCBC5+((8*expr_value))); } else { 
DO_stmt(0xFDCBC5+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCBC4+((8*expr_value))); } else { 
DO_stmt(0xDDCBC4+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDCBC5+((8*expr_value))); } else { 
DO_stmt(0xDDCBC5+((8*expr_value))); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SET const_expr _TK_COMMA _TK_L _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC5+((8*expr_value)));
}

| label? _TK_SET const_expr _TK_COMMA _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
if (expr_error) { error_expected_const_expr(); } else {
switch (expr_value) {
case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: break;
default: error_int_range(expr_value);
}}
DO_stmt(0xCBC5+((8*expr_value)));
break;
default: error_illegal_ident(); }
}

| label? _TK_SETAE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SETUSR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_A _TK_NEWLINE @{
DO_stmt(0xCB27);
}

| label? _TK_SLA _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB27);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_B _TK_NEWLINE @{
DO_stmt(0xCB20);
}

| label? _TK_SLA _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB20);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_C _TK_NEWLINE @{
DO_stmt(0xCB21);
}

| label? _TK_SLA _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB21);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_D _TK_NEWLINE @{
DO_stmt(0xCB22);
}

| label? _TK_SLA _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB22);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_E _TK_NEWLINE @{
DO_stmt(0xCB23);
}

| label? _TK_SLA _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB23);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_H _TK_NEWLINE @{
DO_stmt(0xCB24);
}

| label? _TK_SLA _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB24);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB26);
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0027); } else { DO_stmt(0xFDCB0027); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0020); } else { DO_stmt(0xFDCB0020); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0021); } else { DO_stmt(0xFDCB0021); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0022); } else { DO_stmt(0xFDCB0022); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0023); } else { DO_stmt(0xFDCB0023); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0024); } else { DO_stmt(0xFDCB0024); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0025); } else { DO_stmt(0xFDCB0025); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0026); } else { DO_stmt(0xFDCB0026); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB27); } else { DO_stmt_idx(0xFDCB27); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB20); } else { DO_stmt_idx(0xFDCB20); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB21); } else { DO_stmt_idx(0xFDCB21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB22); } else { DO_stmt_idx(0xFDCB22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB23); } else { DO_stmt_idx(0xFDCB23); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB24); } else { DO_stmt_idx(0xFDCB24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB25); } else { DO_stmt_idx(0xFDCB25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB26); } else { DO_stmt_idx(0xFDCB26); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0027); } else { DO_stmt(0xDDCB0027); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0020); } else { DO_stmt(0xDDCB0020); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0021); } else { DO_stmt(0xDDCB0021); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0022); } else { DO_stmt(0xDDCB0022); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0023); } else { DO_stmt(0xDDCB0023); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0024); } else { DO_stmt(0xDDCB0024); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0025); } else { DO_stmt(0xDDCB0025); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0026); } else { DO_stmt(0xDDCB0026); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB27); } else { DO_stmt_idx(0xDDCB27); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB20); } else { DO_stmt_idx(0xDDCB20); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB21); } else { DO_stmt_idx(0xDDCB21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB22); } else { DO_stmt_idx(0xDDCB22); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB23); } else { DO_stmt_idx(0xDDCB23); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB24); } else { DO_stmt_idx(0xDDCB24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB25); } else { DO_stmt_idx(0xDDCB25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB26); } else { DO_stmt_idx(0xDDCB26); }
}

| label? _TK_SLA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB24); } else { DO_stmt(0xFDCB24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB25); } else { DO_stmt(0xFDCB25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB24); } else { DO_stmt(0xDDCB24); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB25); } else { DO_stmt(0xDDCB25); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLA _TK_L _TK_NEWLINE @{
DO_stmt(0xCB25);
}

| label? _TK_SLA _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB25);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB31);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB32);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB33);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB34);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB36);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0037); } else { DO_stmt(0xFDCB0037); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0030); } else { DO_stmt(0xFDCB0030); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0031); } else { DO_stmt(0xFDCB0031); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0032); } else { DO_stmt(0xFDCB0032); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0033); } else { DO_stmt(0xFDCB0033); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0034); } else { DO_stmt(0xFDCB0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0035); } else { DO_stmt(0xFDCB0035); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0036); } else { DO_stmt(0xFDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB37); } else { DO_stmt_idx(0xFDCB37); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB30); } else { DO_stmt_idx(0xFDCB30); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB31); } else { DO_stmt_idx(0xFDCB31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB32); } else { DO_stmt_idx(0xFDCB32); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB33); } else { DO_stmt_idx(0xFDCB33); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB34); } else { DO_stmt_idx(0xFDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB35); } else { DO_stmt_idx(0xFDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB36); } else { DO_stmt_idx(0xFDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0037); } else { DO_stmt(0xDDCB0037); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0030); } else { DO_stmt(0xDDCB0030); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0031); } else { DO_stmt(0xDDCB0031); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0032); } else { DO_stmt(0xDDCB0032); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0033); } else { DO_stmt(0xDDCB0033); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0034); } else { DO_stmt(0xDDCB0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0035); } else { DO_stmt(0xDDCB0035); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0036); } else { DO_stmt(0xDDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB37); } else { DO_stmt_idx(0xDDCB37); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB30); } else { DO_stmt_idx(0xDDCB30); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB31); } else { DO_stmt_idx(0xDDCB31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB32); } else { DO_stmt_idx(0xDDCB32); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB33); } else { DO_stmt_idx(0xDDCB33); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB34); } else { DO_stmt_idx(0xDDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB35); } else { DO_stmt_idx(0xDDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB36); } else { DO_stmt_idx(0xDDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB34); } else { DO_stmt(0xFDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB35); } else { DO_stmt(0xFDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB34); } else { DO_stmt(0xDDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB35); } else { DO_stmt(0xDDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLI _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB35);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB31);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB32);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB33);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB34);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB36);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0037); } else { DO_stmt(0xFDCB0037); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0030); } else { DO_stmt(0xFDCB0030); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0031); } else { DO_stmt(0xFDCB0031); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0032); } else { DO_stmt(0xFDCB0032); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0033); } else { DO_stmt(0xFDCB0033); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0034); } else { DO_stmt(0xFDCB0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0035); } else { DO_stmt(0xFDCB0035); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0036); } else { DO_stmt(0xFDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB37); } else { DO_stmt_idx(0xFDCB37); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB30); } else { DO_stmt_idx(0xFDCB30); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB31); } else { DO_stmt_idx(0xFDCB31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB32); } else { DO_stmt_idx(0xFDCB32); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB33); } else { DO_stmt_idx(0xFDCB33); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB34); } else { DO_stmt_idx(0xFDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB35); } else { DO_stmt_idx(0xFDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB36); } else { DO_stmt_idx(0xFDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0037); } else { DO_stmt(0xDDCB0037); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0030); } else { DO_stmt(0xDDCB0030); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0031); } else { DO_stmt(0xDDCB0031); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0032); } else { DO_stmt(0xDDCB0032); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0033); } else { DO_stmt(0xDDCB0033); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0034); } else { DO_stmt(0xDDCB0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0035); } else { DO_stmt(0xDDCB0035); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0036); } else { DO_stmt(0xDDCB0036); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB37); } else { DO_stmt_idx(0xDDCB37); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB30); } else { DO_stmt_idx(0xDDCB30); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB31); } else { DO_stmt_idx(0xDDCB31); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB32); } else { DO_stmt_idx(0xDDCB32); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB33); } else { DO_stmt_idx(0xDDCB33); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB34); } else { DO_stmt_idx(0xDDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB35); } else { DO_stmt_idx(0xDDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB36); } else { DO_stmt_idx(0xDDCB36); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB34); } else { DO_stmt(0xFDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB35); } else { DO_stmt(0xFDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB34); } else { DO_stmt(0xDDCB34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB35); } else { DO_stmt(0xDDCB35); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SLL _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: case CPU_Z80: case CPU_Z80N: 
DO_stmt(0xCB35);
break;
default: error_illegal_ident(); }
}

| label? _TK_SLP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED76);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_A _TK_NEWLINE @{
DO_stmt(0xCB2F);
}

| label? _TK_SRA _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_B _TK_NEWLINE @{
DO_stmt(0xCB28);
}

| label? _TK_SRA _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB28);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_C _TK_NEWLINE @{
DO_stmt(0xCB29);
}

| label? _TK_SRA _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB29);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_D _TK_NEWLINE @{
DO_stmt(0xCB2A);
}

| label? _TK_SRA _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_E _TK_NEWLINE @{
DO_stmt(0xCB2B);
}

| label? _TK_SRA _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_H _TK_NEWLINE @{
DO_stmt(0xCB2C);
}

| label? _TK_SRA _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB2E);
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002F); } else { DO_stmt(0xFDCB002F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0028); } else { DO_stmt(0xFDCB0028); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0029); } else { DO_stmt(0xFDCB0029); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002A); } else { DO_stmt(0xFDCB002A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002B); } else { DO_stmt(0xFDCB002B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002C); } else { DO_stmt(0xFDCB002C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002D); } else { DO_stmt(0xFDCB002D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB002E); } else { DO_stmt(0xFDCB002E); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2F); } else { DO_stmt_idx(0xFDCB2F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB28); } else { DO_stmt_idx(0xFDCB28); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB29); } else { DO_stmt_idx(0xFDCB29); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2A); } else { DO_stmt_idx(0xFDCB2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2B); } else { DO_stmt_idx(0xFDCB2B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2C); } else { DO_stmt_idx(0xFDCB2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2D); } else { DO_stmt_idx(0xFDCB2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB2E); } else { DO_stmt_idx(0xFDCB2E); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002F); } else { DO_stmt(0xDDCB002F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0028); } else { DO_stmt(0xDDCB0028); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0029); } else { DO_stmt(0xDDCB0029); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002A); } else { DO_stmt(0xDDCB002A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002B); } else { DO_stmt(0xDDCB002B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002C); } else { DO_stmt(0xDDCB002C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002D); } else { DO_stmt(0xDDCB002D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB002E); } else { DO_stmt(0xDDCB002E); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2F); } else { DO_stmt_idx(0xDDCB2F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB28); } else { DO_stmt_idx(0xDDCB28); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB29); } else { DO_stmt_idx(0xDDCB29); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2A); } else { DO_stmt_idx(0xDDCB2A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2B); } else { DO_stmt_idx(0xDDCB2B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2C); } else { DO_stmt_idx(0xDDCB2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2D); } else { DO_stmt_idx(0xDDCB2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB2E); } else { DO_stmt_idx(0xDDCB2E); }
}

| label? _TK_SRA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB2C); } else { DO_stmt(0xFDCB2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB2D); } else { DO_stmt(0xFDCB2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB2C); } else { DO_stmt(0xDDCB2C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB2D); } else { DO_stmt(0xDDCB2D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_L _TK_NEWLINE @{
DO_stmt(0xCB2D);
}

| label? _TK_SRA _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_A _TK_NEWLINE @{
DO_stmt(0xCB3F);
}

| label? _TK_SRL _TK_A1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_B _TK_NEWLINE @{
DO_stmt(0xCB38);
}

| label? _TK_SRL _TK_B1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB38);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_C _TK_NEWLINE @{
DO_stmt(0xCB39);
}

| label? _TK_SRL _TK_C1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB39);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_D _TK_NEWLINE @{
DO_stmt(0xCB3A);
}

| label? _TK_SRL _TK_D1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_E _TK_NEWLINE @{
DO_stmt(0xCB3B);
}

| label? _TK_SRL _TK_E1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_H _TK_NEWLINE @{
DO_stmt(0xCB3C);
}

| label? _TK_SRL _TK_H1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xCB3E);
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003F); } else { DO_stmt(0xFDCB003F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0038); } else { DO_stmt(0xFDCB0038); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB0039); } else { DO_stmt(0xFDCB0039); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003A); } else { DO_stmt(0xFDCB003A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003B); } else { DO_stmt(0xFDCB003B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003C); } else { DO_stmt(0xFDCB003C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003D); } else { DO_stmt(0xFDCB003D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB003E); } else { DO_stmt(0xFDCB003E); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3F); } else { DO_stmt_idx(0xFDCB3F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB38); } else { DO_stmt_idx(0xFDCB38); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB39); } else { DO_stmt_idx(0xFDCB39); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3A); } else { DO_stmt_idx(0xFDCB3A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3B); } else { DO_stmt_idx(0xFDCB3B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3C); } else { DO_stmt_idx(0xFDCB3C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3D); } else { DO_stmt_idx(0xFDCB3D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDCB3E); } else { DO_stmt_idx(0xFDCB3E); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003F); } else { DO_stmt(0xDDCB003F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0038); } else { DO_stmt(0xDDCB0038); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB0039); } else { DO_stmt(0xDDCB0039); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003A); } else { DO_stmt(0xDDCB003A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003B); } else { DO_stmt(0xDDCB003B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003C); } else { DO_stmt(0xDDCB003C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003D); } else { DO_stmt(0xDDCB003D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB003E); } else { DO_stmt(0xDDCB003E); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3F); } else { DO_stmt_idx(0xDDCB3F); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB38); } else { DO_stmt_idx(0xDDCB38); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB39); } else { DO_stmt_idx(0xDDCB39); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3A); } else { DO_stmt_idx(0xDDCB3A); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3B); } else { DO_stmt_idx(0xDDCB3B); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3C); } else { DO_stmt_idx(0xDDCB3C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3D); } else { DO_stmt_idx(0xDDCB3D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDCB3E); } else { DO_stmt_idx(0xDDCB3E); }
}

| label? _TK_SRL _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB3C); } else { DO_stmt(0xFDCB3C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDCB3D); } else { DO_stmt(0xFDCB3D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB3C); } else { DO_stmt(0xDDCB3C); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDCB3D); } else { DO_stmt(0xDDCB3D); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SRL _TK_L _TK_NEWLINE @{
DO_stmt(0xCB3D);
}

| label? _TK_SRL _TK_L1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xCB3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0x97);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0x90);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0x91);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0x92);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0x93);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0x94);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x96);
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD94); } else { DO_stmt(0xFD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD95); } else { DO_stmt(0xFD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD94); } else { DO_stmt(0xDD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD95); } else { DO_stmt(0xDD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0x95);
}

| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
}

| label? _TK_SUB _TK_A _TK_NEWLINE @{
DO_stmt(0x97);
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDD9600); } else { 
DO_stmt(0xFD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDD96); } else { 
DO_stmt_idx(0xFD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFD9600); } else { 
DO_stmt(0xDD9600); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFD96); } else { 
DO_stmt_idx(0xDD96); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_B _TK_NEWLINE @{
DO_stmt(0x90);
}

| label? _TK_SUB _TK_C _TK_NEWLINE @{
DO_stmt(0x91);
}

| label? _TK_SUB _TK_D _TK_NEWLINE @{
DO_stmt(0x92);
}

| label? _TK_SUB _TK_E _TK_NEWLINE @{
DO_stmt(0x93);
}

| label? _TK_SUB _TK_H _TK_NEWLINE @{
DO_stmt(0x94);
}

| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0x96);
}

| label? _TK_SUB _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDD9600); } else { DO_stmt(0xFD9600); }
}

| label? _TK_SUB _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDD96); } else { DO_stmt_idx(0xFD96); }
}

| label? _TK_SUB _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFD9600); } else { DO_stmt(0xDD9600); }
}

| label? _TK_SUB _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFD96); } else { DO_stmt_idx(0xDD96); }
}

| label? _TK_SUB _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD94); } else { DO_stmt(0xFD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDD95); } else { DO_stmt(0xFD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD94); } else { DO_stmt(0xDD94); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFD95); } else { DO_stmt(0xDD95); }
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_L _TK_NEWLINE @{
DO_stmt(0x95);
}

| label? _TK_SUB expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
}

| label? _TK_SURES _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SWAPNIB _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
DO_stmt(0xED23);
break;
default: error_illegal_ident(); }
}

| label? _TK_SYSCALL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xED75);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TEST expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED04);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED14);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED24);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED34);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDED0034); } else { DO_stmt(0xFDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDED34); } else { DO_stmt_idx(0xFDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDED0034); } else { DO_stmt(0xDDED0034); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDED34); } else { DO_stmt_idx(0xDDED34); }
break;
default: error_illegal_ident(); }
}

| label? _TK_TST _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
DO_stmt(0xED2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_TST expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80N: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED27);
break;
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED64);
break;
default: error_illegal_ident(); }
}

| label? _TK_TSTIO expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z180: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xED74);
break;
default: error_illegal_ident(); }
}

| label? _TK_UMA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDC0);
break;
default: error_illegal_ident(); }
}

| label? _TK_UMS _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R3K: 
DO_stmt(0xEDC8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
DO_stmt(0xAF);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
DO_stmt(0xA8);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
DO_stmt(0xA9);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
DO_stmt(0xAA);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
DO_stmt(0xAB);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
DO_stmt(0xAC);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xAE);
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAC); } else { DO_stmt(0xFDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAD); } else { DO_stmt(0xFDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAC); } else { DO_stmt(0xDDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAD); } else { DO_stmt(0xDDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
DO_stmt(0xAD);
}

| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
}

| label? _TK_XOR _TK_A _TK_NEWLINE @{
DO_stmt(0xAF);
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xDDAE00); } else { 
DO_stmt(0xFDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xDDAE); } else { 
DO_stmt_idx(0xFDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt(0xFDAE00); } else { 
DO_stmt(0xDDAE00); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
if (!opts.swap_ix_iy) { 
DO_stmt_idx(0xFDAE); } else { 
DO_stmt_idx(0xDDAE); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
DO_stmt(0x76);
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A1 _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_R2K: case CPU_R3K: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt(0x76);
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_B _TK_NEWLINE @{
DO_stmt(0xA8);
}

| label? _TK_XOR _TK_C _TK_NEWLINE @{
DO_stmt(0xA9);
}

| label? _TK_XOR _TK_D _TK_NEWLINE @{
DO_stmt(0xAA);
}

| label? _TK_XOR _TK_E _TK_NEWLINE @{
DO_stmt(0xAB);
}

| label? _TK_XOR _TK_H _TK_NEWLINE @{
DO_stmt(0xAC);
}

| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
DO_stmt(0xAE);
}

| label? _TK_XOR _TK_IND_IX _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xDDAE00); } else { DO_stmt(0xFDAE00); }
}

| label? _TK_XOR _TK_IND_IX expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xDDAE); } else { DO_stmt_idx(0xFDAE); }
}

| label? _TK_XOR _TK_IND_IY _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt(0xFDAE00); } else { DO_stmt(0xDDAE00); }
}

| label? _TK_XOR _TK_IND_IY expr _TK_RPAREN _TK_NEWLINE @{
if (!opts.swap_ix_iy) { DO_stmt_idx(0xFDAE); } else { DO_stmt_idx(0xDDAE); }
}

| label? _TK_XOR _TK_IXH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAC); } else { DO_stmt(0xFDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IXL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xDDAD); } else { DO_stmt(0xFDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IYH _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAC); } else { DO_stmt(0xDDAC); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IYL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_Z80: case CPU_Z80N: 
if (!opts.swap_ix_iy) { DO_stmt(0xFDAD); } else { DO_stmt(0xDDAD); }
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_L _TK_NEWLINE @{
DO_stmt(0xAD);
}

| label? _TK_XOR expr _TK_NEWLINE @{
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
}

