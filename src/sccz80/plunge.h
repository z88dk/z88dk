/* plunge.c */
extern int skim(char *opstr, void (*testfuncz)(), void (*testfuncq)(), int dropval, int endval, int (*heir)(), LVALUE *lval);
extern void dropout(int k, void (*testfuncz)(), void (*testfuncq)(), int exit1, LVALUE *lval);
extern int plnge1(int (*heir)(), LVALUE *lval);
extern void plnge2a(int (*heir)(), LVALUE *lval, LVALUE *lval2, void (*oper)(), void (*doper)());
extern void plnge2b(int (*heir)(), LVALUE *lval, LVALUE *lval2, void (*oper)());
