/* primary.c */
extern int primary(LVALUE *lval);
extern double calc(double left, void (*oper)(LVALUE *), double right, int is16bit);
extern double calcun(double left, void (*oper)(LVALUE *),double right);
extern double CalcStand(double left, void (*oper)(LVALUE *), double right);
extern int intcheck(LVALUE *lval, LVALUE *lval2);
extern void force(int t1, int t2, char sign1, char sign2, int lconst);
extern int widen(LVALUE *lval, LVALUE *lval2);
extern void widenlong(LVALUE *lval, LVALUE *lval2);
extern int dbltest(LVALUE *lval, LVALUE *lval2);
extern void result(LVALUE *lval, LVALUE *lval2);
extern void prestep(LVALUE *lval, int n, void (*step)(LVALUE *lval));
extern void poststep(int k, LVALUE *lval, int n, void (*step)(LVALUE *lval), void (*unstep)(LVALUE *lval));
extern void nstep(LVALUE *lval, int n, void (*unstep)(LVALUE *lval));
extern void store(LVALUE *lval);
extern void smartpush(LVALUE *lval, char *before);
extern void smartstore(LVALUE *lval);
extern void rvaluest(LVALUE *lval);
extern void rvalload(LVALUE  *lval);
extern void rvalue(LVALUE *lval);
extern void test(int label, int parens);
extern int constexpr(double *val, int *valtype, int flag);
extern void cscale(int type, TAG_SYMBOL *tag, int *val);
extern int  docast(LVALUE *lval,LVALUE *dest_lval);
extern void convert_int_to_double(char type, char zunsign);
extern int   utype(LVALUE *lval);
extern int check_lastop_was_testjump(LVALUE *lval);

