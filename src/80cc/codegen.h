/* codegen.c */

extern void DoLibHeader(void);
extern void outname(const char *sname, char pref);

extern char dopref(SYMBOL *sym);

extern void defbyte(void);
extern void defstorage(void);
extern void defword(void);
extern void deflong(void);
extern void defmesg(void);
extern void point(void);

extern void GlobalPrefix(void);

extern void function_appendix(SYMBOL *func);

extern int zcriticaloffset(void);
extern void reset_namespace(void);
