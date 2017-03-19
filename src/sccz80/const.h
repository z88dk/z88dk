/* constant.c */
extern int constant(LVALUE *lval);
extern int fnumber(LVALUE *val);
extern int stash_double_str(char *start,char *end);
extern int number(LVALUE *lval);
extern int hex(char c);
extern void address(SYMBOL *ptr);
extern int pstr(LVALUE *lval);
extern int tstr(int32_t *val);
extern int storeq(int length, unsigned char *queue,int32_t *val);
extern int qstr(int32_t *val);
extern void stowlit(int value, int size);
extern unsigned char litchar(void);
extern void size_of(LVALUE *lval);
extern void load_double_into_fa(LVALUE *lval);