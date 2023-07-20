/* codegen.c */


extern void DoLibHeader(void);
extern void outname(const char *sname, char pref);
extern int getloc(SYMBOL *sym, int off);
extern void putstk(LVALUE *lval);
extern void puttos(void);
extern void put2tos(void);
extern void immed(void);
extern void immedlit(int lab,int offs);
extern void lpush(void);
extern void llpush(void);
extern void zpush(void);



extern void zpop(void);

extern char dopref(SYMBOL *sym);
extern void callrts(char *sname);
extern int callstk(Type *type, int n, int isfarptr, int last_argument_size);

extern void defbyte(void);
extern void defstorage(void);
extern void defword(void);
extern void deflong(void);
extern void defmesg(void);
extern void point(void);
extern int modstk(int newsp, Kind save,int saveaf, int usebc);
extern void scale(Kind type, Type *tag);


extern void vlongconst(zdouble val);
extern void vlongconst_tostack(zdouble val);
extern void vllongconst_tostack(zdouble val);
extern void vllongconst(zdouble val);
extern void vconst(int64_t val);
extern void const2(int32_t val);
extern void GlobalPrefix(void);
extern void jumpc(int);
extern void jumpnc(int);

extern void jumpr(int);
extern void opjumpr(char *, int);



extern void function_appendix(SYMBOL *func);


extern int zcriticaloffset(void);
extern void zconvert_to_decimal(Kind from, Kind to, unsigned char isunsigned, unsigned char tounsigned);
extern void zconvert_from_decimal(Kind from, Kind to, unsigned char isunsigned);
extern int push_function_argument_fnptr(Kind expr, Type *type, Type *functype, int push_sdccchar, int is_last_argument);
extern void reset_namespace(void);
extern void zwiden_stack_to_long(LVALUE *lval);
extern void zwiden_stack_to_llong(LVALUE *lval);
extern void zconvert_stacked_to_decimal(Kind stacked_kind, Kind float_kind, unsigned char isunsigned,  unsigned char float_sign, int operator_is_commutative);
