/* expr.c */
extern void ClearCast(LVALUE *lval);
extern int expression(int *con, double *val, uint32_t *packedArgumentType);
extern int heir1(LVALUE *lval);
extern int heir1a(LVALUE *lval);
extern int heir2a(LVALUE *lval);
extern int heir2b(LVALUE *lval);
extern int heir234(LVALUE *lval, int (*heir)(LVALUE *lval), char opch, void (*oper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int32_t value));
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
