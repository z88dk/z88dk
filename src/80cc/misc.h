/* misc.c */
extern void prefix(void);
extern void changesuffix(char *name, char *suffix);
extern void initstack(void);
extern Type *retrstk(char *flags);
extern int addstk(LVALUE *lval);
extern const char *get_section_name(const char *namespace, const char *section);
extern int stkcount;
