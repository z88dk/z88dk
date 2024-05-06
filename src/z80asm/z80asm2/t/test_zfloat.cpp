//-----------------------------------------------------------------------------
// z80asm - floating point values
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "zfloat.h"
#include "t/test.h"
#include <cmath>
#include <cstdint>
#include <vector>
using namespace std;

static bool check_float_format(FloatFormat& ff, double value, 
							   const vector<uint8_t>& expected) {
	vector<uint8_t> got = ff.float_to_bytes(value);
	if (got.size() != expected.size())
		return false;
	for (size_t i = 0; i < got.size(); i++) {
		if (got[i] != expected[i])
			return false;
	}
	return true;
}

void test_float_to_bytes() {
	FloatFormat ff;
	
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,0,0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,128}));
	
	ff.set(FLOAT_genmath);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,0,0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,128}));
	
	ff.set(FLOAT_math48);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,0,0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,128}));
	
	ff.set(FLOAT_z80);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,0,0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,128}));
	
	ff.set(FLOAT_ieee16);
	OK(check_float_format(ff, 0.0,      {0,0}));
	OK(check_float_format(ff, 1.0,      {0,60}));
	OK(check_float_format(ff, -1.0,     {0,188}));
	OK(check_float_format(ff, 255.0,    {248,91}));
	OK(check_float_format(ff, -255.0,   {248,219}));
	OK(check_float_format(ff, 256.0,    {0,92}));
	OK(check_float_format(ff, -256.0,   {0,220}));
	OK(check_float_format(ff, 65535.0,  {255,123}));
	OK(check_float_format(ff, -65535.0, {255,251}));
	OK(check_float_format(ff, 65536.0,  {0,124}));
	OK(check_float_format(ff, -65536.0, {0,252}));
	OK(check_float_format(ff, 5.5,      {128,69}));
	OK(check_float_format(ff, -5.5,     {128,197}));
	OK(check_float_format(ff, 5.5e1,    {224,82}));
	OK(check_float_format(ff, 5.0e-1,   {0,56}));
	
	ff.set(FLOAT_ieee32);
	OK(check_float_format(ff, 0.0,      {0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,128,63}));
	OK(check_float_format(ff, -1.0,     {0,0,128,191}));
	OK(check_float_format(ff, 255.0,    {0,0,127,67}));
	OK(check_float_format(ff, -255.0,   {0,0,127,195}));
	OK(check_float_format(ff, 256.0,    {0,0,128,67}));
	OK(check_float_format(ff, -256.0,   {0,0,128,195}));
	OK(check_float_format(ff, 65535.0,  {0,255,127,71}));
	OK(check_float_format(ff, -65535.0, {0,255,127,199}));
	OK(check_float_format(ff, 65536.0,  {0,0,128,71}));
	OK(check_float_format(ff, -65536.0, {0,0,128,199}));
	OK(check_float_format(ff, 5.5,      {0,0,176,64}));
	OK(check_float_format(ff, -5.5,     {0,0,176,192}));
	OK(check_float_format(ff, 5.5e1,    {0,0,92,66}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,63}));
	
	ff.set(FLOAT_ieee64);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,0,240,63}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,0,0,240,191}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,0,224,111,64}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,0,224,111,192}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,0,112,64}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,0,0,112,192}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,0,224,255,239,64}));
	OK(check_float_format(ff, -65535.0, {0,0,0,0,224,255,239,192}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,0,240,64}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,0,0,240,192}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,0,0,22,64}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,0,0,22,192}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,0,128,75,64}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,0,224,63}));
	
	ff.set(FLOAT_zx81);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {129,0,0,0,0}));
	OK(check_float_format(ff, -1.0,     {129,128,0,0,0}));
	OK(check_float_format(ff, 255.0,    {136,127,0,0,0}));
	OK(check_float_format(ff, -255.0,   {136,255,0,0,0}));
	OK(check_float_format(ff, 256.0,    {137,0,0,0,0}));
	OK(check_float_format(ff, -256.0,   {137,128,0,0,0}));
	OK(check_float_format(ff, 65535.0,  {144,127,255,0,0}));
	OK(check_float_format(ff, -65535.0, {144,255,255,0,0}));
	OK(check_float_format(ff, 65536.0,  {145,0,0,0,0}));
	OK(check_float_format(ff, -65536.0, {145,128,0,0,0}));
	OK(check_float_format(ff, 5.5,      {131,48,0,0,0}));
	OK(check_float_format(ff, -5.5,     {131,176,0,0,0}));
	OK(check_float_format(ff, 5.5e1,    {134,92,0,0,0}));
	OK(check_float_format(ff, 5.0e-1,   {128,0,0,0,0}));
	
	ff.set(FLOAT_zx);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,1,0,0}));
	OK(check_float_format(ff, -1.0,     {0,255,255,255,0}));
	OK(check_float_format(ff, 255.0,    {0,0,255,0,0}));
	OK(check_float_format(ff, -255.0,   {0,255,1,255,0}));
	OK(check_float_format(ff, 256.0,    {0,0,0,1,0}));
	OK(check_float_format(ff, -256.0,   {0,255,0,255,0}));
	OK(check_float_format(ff, 65535.0,  {0,0,255,255,0}));
	OK(check_float_format(ff, -65535.0, {0,255,1,0,0}));
	OK(check_float_format(ff, 65536.0,  {145,0,0,0,0}));
	OK(check_float_format(ff, -65536.0, {145,128,0,0,0}));
	OK(check_float_format(ff, 5.5,      {131,48,0,0,0}));
	OK(check_float_format(ff, -5.5,     {131,176,0,0,0}));
	OK(check_float_format(ff, 5.5e1,    {0,0,55,0,0}));
	OK(check_float_format(ff, 5.0e-1,   {128,0,0,0,0}));
	
	ff.set(FLOAT_z88);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,128}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,128,128}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,127,135}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,255,135}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,136}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,128,136}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,255,127,143}));
	OK(check_float_format(ff, -65535.0, {0,0,0,255,255,143}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,144}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,128,144}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,48,130}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,176,130}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,92,133}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,127}));
	
	ff.set(FLOAT_mbfs);
	OK(check_float_format(ff, 0.0,      {0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,128}));
	
	ff.set(FLOAT_mbf40);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,129,0}));
	OK(check_float_format(ff, -1.0,     {0,0,0,128,129,0}));
	OK(check_float_format(ff, 255.0,    {0,0,0,127,136,0}));
	OK(check_float_format(ff, -255.0,   {0,0,0,255,136,0}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,137,0}));
	OK(check_float_format(ff, -256.0,   {0,0,0,128,137,0}));
	OK(check_float_format(ff, 65535.0,  {0,0,255,127,144,0}));
	OK(check_float_format(ff, -65535.0, {0,0,255,255,144,0}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,145,0}));
	OK(check_float_format(ff, -65536.0, {0,0,0,128,145,0}));
	OK(check_float_format(ff, 5.5,      {0,0,0,48,131,0}));
	OK(check_float_format(ff, -5.5,     {0,0,0,176,131,0}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,92,134,0}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,128,0}));
	
	ff.set(FLOAT_mbf64);
	OK(check_float_format(ff, 0.0,      {0,0,0,0,0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,0,0,0,0,0,129}));
	OK(check_float_format(ff, -1.0,     {0,0,0,0,0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,0,0,0,0,127,136}));
	OK(check_float_format(ff, -255.0,   {0,0,0,0,0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,0,0,0,0,0,137}));
	OK(check_float_format(ff, -256.0,   {0,0,0,0,0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,0,0,0,0,255,127,144}));
	OK(check_float_format(ff, -65535.0, {0,0,0,0,0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,0,0,0,0,0,145}));
	OK(check_float_format(ff, -65536.0, {0,0,0,0,0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,0,0,0,0,48,131}));
	OK(check_float_format(ff, -5.5,     {0,0,0,0,0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,0,0,0,0,92,134}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,0,0,0,0,0,128}));
	
	ff.set(FLOAT_am9511);
	OK(check_float_format(ff, 0.0,      {0,0,0,0}));
	OK(check_float_format(ff, 1.0,      {0,0,128,1}));
	OK(check_float_format(ff, -1.0,     {0,0,128,129}));
	OK(check_float_format(ff, 255.0,    {0,0,255,8}));
	OK(check_float_format(ff, -255.0,   {0,0,255,136}));
	OK(check_float_format(ff, 256.0,    {0,0,128,9}));
	OK(check_float_format(ff, -256.0,   {0,0,128,137}));
	OK(check_float_format(ff, 65535.0,  {0,255,255,16}));
	OK(check_float_format(ff, -65535.0, {0,255,255,144}));
	OK(check_float_format(ff, 65536.0,  {0,0,128,17}));
	OK(check_float_format(ff, -65536.0, {0,0,128,145}));
	OK(check_float_format(ff, 5.5,      {0,0,176,3}));
	OK(check_float_format(ff, -5.5,     {0,0,176,131}));
	OK(check_float_format(ff, 5.5e1,    {0,0,220,6}));
	OK(check_float_format(ff, 5.0e-1,   {0,0,128,0}));
}

static bool check_float_expr(const string& text, double expected) {
	Lexer lexer(text);
	FloatExpr expr;
	if (!expr.parse(lexer))
		return false;
	if (expr.eval_error())
		return false;
	if (abs(expr.value() - expected) > 1e-6)
		return false;
	
	return true;
}

void test_float_expr() {
	OK(check_float_expr("1", 1));
	OK(check_float_expr("pi", M_PI));
	OK(check_float_expr("e", exp(1)));
	OK(check_float_expr("1+.5", 1.5));
	OK(check_float_expr("1-.5", 0.5));
	OK(check_float_expr("1+-.5", 0.5));
	OK(check_float_expr("2*4", 8));
	OK(check_float_expr("2/4", 0.5));
	OK(check_float_expr("2*-4", -8));
	OK(check_float_expr("2**8", 256));
	OK(check_float_expr("4**3**2", 262144));
	OK(check_float_expr("(4**3)**2", 4096));
	OK(check_float_expr("4**(0.5)", 2));
	OK(check_float_expr("+4", 4));
	OK(check_float_expr("++4", 4));
	OK(check_float_expr("++-4", -4));
	OK(check_float_expr("++--4", 4));
	OK(check_float_expr("2+3*4", 14));
	OK(check_float_expr("(2+3)*4", 20));
	OK(check_float_expr("2*3+4", 10));
	OK(check_float_expr("2*(3+4)", 14));
	OK(check_float_expr("sin(0.5)", sin(0.5)));
	OK(check_float_expr("asin(sin(0.5))", 0.5));
	OK(check_float_expr("cos(0.5)", cos(0.5)));
	OK(check_float_expr("acos(cos(0.5))", 0.5));
	OK(check_float_expr("tan(0.5)", tan(0.5)));
	OK(check_float_expr("atan(tan(0.5))", 0.5));
	OK(check_float_expr("sinh(0.5)", sinh(0.5)));
	OK(check_float_expr("asinh(sinh(0.5))", 0.5));
	OK(check_float_expr("cosh(0.5)", cosh(0.5)));
	OK(check_float_expr("acosh(cosh(0.5))", 0.5));
	OK(check_float_expr("tanh(0.5)", tanh(0.5)));
	OK(check_float_expr("atanh(tanh(0.5))", 0.5));
	OK(check_float_expr("atan2(0.5,0.5)", atan2(0.5,0.5)));
	OK(check_float_expr("log(2.7)", log(2.7)));
	OK(check_float_expr("log2(2.5)", log(2.5)/log(2)));
	OK(check_float_expr("log10(15)", log(15)/log(10)));
	OK(check_float_expr("exp(2)", exp(2)));
	OK(check_float_expr("exp2(2)", 4));
	OK(check_float_expr("pow(2,4)", 16));
	OK(check_float_expr("sqrt(4)", 2));
	OK(check_float_expr("cbrt(8)", 2));
	OK(check_float_expr("ceil(2.5)", 3));
	OK(check_float_expr("ceil(-2.5)", -2));
	OK(check_float_expr("floor(2.5)", 2));
	OK(check_float_expr("floor(-2.5)", -3));
	OK(check_float_expr("trunc(2.5)", 2));
	OK(check_float_expr("trunc(-2.5)", -2));
	OK(check_float_expr("abs(2.5)", 2.5));
	OK(check_float_expr("abs(-2.5)", 2.5));
	OK(check_float_expr("hypot(2,3)", sqrt(2*2+3*3)));
	OK(check_float_expr("fmod(10,3)", 1));
	OK(check_float_expr("fmod(10,-3)", 1));
	OK(check_float_expr("fmod(-10,3)", -1));
	OK(check_float_expr("fmod(-10,-3)", -1));
}
