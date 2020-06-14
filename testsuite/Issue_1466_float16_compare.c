

void Yes() { }
void No() { }

void eq_int_c(_Float16 a) {
	if ( a == 1 ) Yes();
	else No();
}
void eq_long_c(_Float16 a) {
	if ( a == 1L ) Yes();
	else No();
}
void eq_double_c(_Float16 a) {
	if ( a == 1.0 ) Yes();
	else No();
}
void eq_float16_c(_Float16 a) {
	if ( a == 1.0f16 ) Yes();
	else No();
}
void eq_int_cr(_Float16 a) {
	if ( 1 == a ) Yes();
	else No();
}
void eq_long_cr(_Float16 a) {
	if ( 1L == a ) Yes();
	else No();
}
void eq_double_cr(_Float16 a) {
	if ( 1.0 == a ) Yes();
	else No();
}
void eq_float16_cr(_Float16 a) {
	if ( 1.0f16 == a) Yes();
	else No();
}




void eq_int(_Float16 a, int b) {
	if ( a == b ) Yes();
	else No();
}
void eq_long(_Float16 a, long b) {
	if ( a == b ) Yes();
	else No();
}
void eq_double(_Float16 a, double b) {
	if ( a == b ) Yes();
	else No();
}
void eq_float16(_Float16 a, _Float16 b) {
	if ( a == b ) Yes();
	else No();
}
void eq_int_r(_Float16 a, int b) {
	if ( b == a ) Yes();
	else No();
}
void eq_long_r(_Float16 a, long b) {
	if ( b == a ) Yes();
	else No();
}
void eq_double_r(_Float16 a, double b) {
	if ( b == a ) Yes();
	else No();
}
void eq_float16_r(_Float16 a, _Float16 b) {
	if ( b == a ) Yes();
	else No();
}



void lt_int_c(_Float16 a) {
	if ( a < 1 ) Yes();
	else No();
}
void lt_long_c(_Float16 a) {
	if ( a < 1L ) Yes();
	else No();
}
void lt_double_c(_Float16 a) {
	if ( a < 1.0 ) Yes();
	else No();
}
void lt_float16_c(_Float16 a) {
	if ( a < 1.0f16 ) Yes();
	else No();
}
void lt_int_cr(_Float16 a) {
	if ( 1 < a ) Yes();
	else No();
}
void lt_long_cr(_Float16 a) {
	if ( 1L < a ) Yes();
	else No();
}
void lt_double_cr(_Float16 a) {
	if ( 1.0 < a ) Yes();
	else No();
}
void lt_float16_cr(_Float16 a) {
	if ( 1.0f16 < a) Yes();
	else No();
}




void lt_int(_Float16 a, int b) {
	if ( a < b ) Yes();
	else No();
}
void lt_long(_Float16 a, long b) {
	if ( a < b ) Yes();
	else No();
}
void lt_double(_Float16 a, double b) {
	if ( a < b ) Yes();
	else No();
}
void lt_float16(_Float16 a, _Float16 b) {
	if ( a < b ) Yes();
	else No();
}
void lt_int_r(_Float16 a, int b) {
	if ( b < a ) Yes();
	else No();
}
void lt_long_r(_Float16 a, long b) {
	if ( b < a ) Yes();
	else No();
}
void lt_double_r(_Float16 a, double b) {
	if ( b < a ) Yes();
	else No();
}
void lt_float16_r(_Float16 a, _Float16 b) {
	if ( b < a ) Yes();
	else No();
}
