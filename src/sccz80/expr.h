/* expr.c */
extern void ClearCast(LVALUE *lval);
extern int expression(int *con, int *val);
extern int heir1(LVALUE *lval);
extern int heir1a(LVALUE *lval);
extern int heir2a(LVALUE *lval);
extern int heir2b(LVALUE *lval);
extern int heir234(LVALUE *lval, int (*heir)(), char opch, void (*oper)());
extern int heir2(LVALUE *lval);
extern int heir3(LVALUE *lval);
extern int heir4(LVALUE *lval);
extern int heir5(LVALUE *lval);
extern int heir6(LVALUE *lval);
extern int heir7(LVALUE *lval);
extern int heir8(LVALUE *lval);
extern int heir9(LVALUE *lval);
extern SYMBOL *deref(LVALUE *lval, char isaddr);
extern int heira(LVALUE *lval);
extern int heirb(LVALUE *lval);
