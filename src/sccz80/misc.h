/* misc.c */
extern void prefix(void);
extern void changesuffix(char *name, char *suffix);
extern void initstack(void);
extern SYMBOL *retrstk(char *flags);
extern int addstk(LVALUE *lval);
extern int chkstk(SYMBOL *ptr);
