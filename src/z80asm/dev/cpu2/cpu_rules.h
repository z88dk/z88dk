| label? _TK_ACI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8F);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x88);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x89);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8A);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8B);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8C);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8D);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x8E);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xCE);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x87);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x80);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x81);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x82);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x83);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x84);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_HL _TK_COMMA _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x85);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x86);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_ADI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xC6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA7);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA0);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA1);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA2);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA3);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA4);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA6);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA5);
break;
default: error_illegal_ident(); }
}

| label? _TK_AND expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ANI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xE6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ARHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_NZ _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_P _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_PO _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL _TK_Z _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CALL expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CM expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBF);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB8);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB9);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBA);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBB);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBD);
break;
default: error_illegal_ident(); }
}

| label? _TK_CMP _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xBE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CNC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPE expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEC);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xFE);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2F);
break;
default: error_illegal_ident(); }
}

| label? _TK_CPO expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE4);
break;
default: error_illegal_ident(); }
}

| label? _TK_CZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCC);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x27);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x09);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x19);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x29);
break;
default: error_illegal_ident(); }
}

| label? _TK_DAD _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x39);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCR _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DCX _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x05);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x15);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x25);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x35);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2D);
break;
default: error_illegal_ident(); }
}

| label? _TK_DEC _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3B);
break;
default: error_illegal_ident(); }
}

| label? _TK_DI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF3);
break;
default: error_illegal_ident(); }
}

| label? _TK_DSUB _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_EI _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xFB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_DE _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_EX _TK_IND_SP _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

| label? _TK_HALT _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x76);
break;
default: error_illegal_ident(); }
}

| label? _TK_HLT _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x76);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (!expr_in_parens) return false;
DO_stmt_n(0xDB);
break;
default: error_illegal_ident(); }
}

| label? _TK_IN expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDB);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INC _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x33);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x3C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x04);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x14);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x24);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x2C);
break;
default: error_illegal_ident(); }
}

| label? _TK_INR _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x34);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x03);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x13);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x23);
break;
default: error_illegal_ident(); }
}

| label? _TK_INX _TK_SP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x33);
break;
default: error_illegal_ident(); }
}

| label? _TK_JC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JK expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JM expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JMP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC3);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xD2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNK expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNX5 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xDD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JNZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xC2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE9);
break;
default: error_illegal_ident(); }
}

| label? _TK_JP expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xF2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JPE expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xEA);
break;
default: error_illegal_ident(); }
}

| label? _TK_JPO expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xE2);
break;
default: error_illegal_ident(); }
}

| label? _TK_JX5 expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xFD);
break;
default: error_illegal_ident(); }
}

| label? _TK_JZ expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0xCA);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_BC _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) { DO_stmt_nn(0x3A); } else { DO_stmt_n(0x3E); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_HL _TK_PLUS expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA _TK_SP _TK_PLUS expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA _TK_IND_DE _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) { DO_stmt_nn(0x2A); } else { DO_stmt_nn(0x21); }
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_BC _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_DE _TK_RPAREN _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_IND_HL _TK_RPAREN _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_LD expr _TK_COMMA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (!expr_in_parens) return false;
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x3A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDHI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x28);
break;
default: error_illegal_ident(); }
}

| label? _TK_LDSI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x38);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x2A);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xED);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_BC _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x01);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_DE _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x11);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_HL _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x21);
break;
default: error_illegal_ident(); }
}

| label? _TK_LXI _TK_SP _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x31);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x78);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x79);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_A _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x7E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x47);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x40);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x41);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x42);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x43);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x44);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x45);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_B _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x46);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x48);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x49);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_C _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x4E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x57);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x50);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x51);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x52);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x53);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x54);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x55);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_D _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x56);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x58);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x59);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_E _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x5E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x67);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x60);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x61);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x62);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x63);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x64);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x65);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_H _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x66);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6F);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x68);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x69);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6A);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6B);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6C);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6D);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_L _TK_COMMA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x6E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x77);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x70);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x71);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x72);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x73);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x74);
break;
default: error_illegal_ident(); }
}

| label? _TK_MOV _TK_M _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x75);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x3E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_B _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x06);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_C _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x0E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_D _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x16);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_E _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x1E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_H _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x26);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_L _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x2E);
break;
default: error_illegal_ident(); }
}

| label? _TK_MVI _TK_M _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0x36);
break;
default: error_illegal_ident(); }
}

| label? _TK_NOP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x00);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_OR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB7);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB0);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB1);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB2);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB3);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB4);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB5);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xB6);
break;
default: error_illegal_ident(); }
}

| label? _TK_ORI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xF6);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT expr _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (!expr_in_parens) return false;
DO_stmt_n(0xD3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OUT expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD3);
break;
default: error_illegal_ident(); }
}

| label? _TK_OVRST8 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xCB);
break;
default: error_illegal_ident(); }
}

| label? _TK_PCHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE9);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE1);
break;
default: error_illegal_ident(); }
}

| label? _TK_POP _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF1);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_AF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE5);
break;
default: error_illegal_ident(); }
}

| label? _TK_PUSH _TK_PSW _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF5);
break;
default: error_illegal_ident(); }
}

| label? _TK_RAL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RAR _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RDEL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x18);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC9);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_NZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_P _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_PE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_PO _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RET _TK_Z _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RIM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x20);
break;
default: error_illegal_ident(); }
}

| label? _TK_RL _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x18);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x17);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x07);
break;
default: error_illegal_ident(); }
}

| label? _TK_RLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x18);
break;
default: error_illegal_ident(); }
}

| label? _TK_RM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RNC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RNZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RP _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RPE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE8);
break;
default: error_illegal_ident(); }
}

| label? _TK_RPO _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE0);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x1F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRCA _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x0F);
break;
default: error_illegal_ident(); }
}

| label? _TK_RRHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_0 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_1 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xCF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_16 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_2 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xD7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_24 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xDF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_3 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xDF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_32 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_4 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_40 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xEF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_48 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_5 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xEF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_56 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xFF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_6 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF7);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_7 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xFF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RST _TK_8 _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xCF);
break;
default: error_illegal_ident(); }
}

| label? _TK_RSTV _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xCB);
break;
default: error_illegal_ident(); }
}

| label? _TK_RZ _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xC8);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBB _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9F);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x98);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x99);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9A);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9B);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9C);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9E);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x9D);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBC expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SBI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xDE);
break;
default: error_illegal_ident(); }
}

| label? _TK_SCF _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLD expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x22);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLDE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SHLX _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0xD9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SIM _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x30);
break;
default: error_illegal_ident(); }
}

| label? _TK_SPHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xF9);
break;
default: error_illegal_ident(); }
}

| label? _TK_SRA _TK_HL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x10);
break;
default: error_illegal_ident(); }
}

| label? _TK_STA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_nn(0x32);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x02);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_STAX _TK_DE _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x12);
break;
default: error_illegal_ident(); }
}

| label? _TK_STC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x37);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x97);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x90);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x91);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x92);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x93);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x94);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_HL _TK_COMMA _TK_BC _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8085: 
DO_stmt(0x08);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x95);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0x96);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUB expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_SUI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xD6);
break;
default: error_illegal_ident(); }
}

| label? _TK_XCHG _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xEB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_COMMA expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_IND_HL _TK_RPAREN _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XOR expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_A _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAF);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_B _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA8);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_C _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xA9);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_D _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAA);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_E _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAB);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_H _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAC);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_L _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAD);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRA _TK_M _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xAE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XRI expr _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
if (expr_in_parens) warn_expr_in_parens();
DO_stmt_n(0xEE);
break;
default: error_illegal_ident(); }
}

| label? _TK_XTHL _TK_NEWLINE @{
switch (opts.cpu) {
case CPU_8080: case CPU_8085: 
DO_stmt(0xE3);
break;
default: error_illegal_ident(); }
}

