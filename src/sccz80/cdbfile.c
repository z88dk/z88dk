#include "ccdefs.h"


static void write_cdb_type(Type *type,int comma);


void debug_write_module()
{
    utstring_printf(debug_utstr,"M:%.*s\n",(int)strlen(Filename)-2,Filename+1);
}

/* C = code, E = data, B = stack */

// Write the cdb declaration
void debug_write_symbol(SYMBOL *sym)
{
    if ( sym->storage == LSTATIC) {
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(debug_utstr,"S:F%.*s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,sym->name,sym->level);
        } else {
            utstring_printf(debug_utstr,"F:F%.*s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,sym->name,sym->level);
        }
        utstring_printf(debug_utstr,"%d", sym->scope_block); // Scope block
        utstring_printf(debug_utstr,"(");
        utstring_printf(debug_utstr,"{%d}", sym->ctype->size);
        write_cdb_type(sym->ctype, 0);
        utstring_printf(debug_utstr,")");
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(debug_utstr,",E,0,0");
        } else {
            utstring_printf(debug_utstr,",C,0,0");
        }
    } else if ( sym->storage == STATIK ) {
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(debug_utstr,"S:G$%s$%d_0$",sym->name, sym->level);
        } else {
            utstring_printf(debug_utstr,"F:G$%s$%d_0$",sym->name, sym->level);
        }
        utstring_printf(debug_utstr,"%d", sym->scope_block); // Scope block
        utstring_printf(debug_utstr,"(");
        utstring_printf(debug_utstr,"{%d}", sym->ctype->size);
        write_cdb_type(sym->ctype, 0);
        utstring_printf(debug_utstr,")");
        if ( sym->ctype->kind != KIND_FUNC ) {
            utstring_printf(debug_utstr,",E,0,0");
        } else {
            utstring_printf(debug_utstr,",C,0,0,0,0,0");
        }
    } else if ( sym->storage == STKLOC ) {
        utstring_printf(debug_utstr,"S:L%.*s.%s$%s$%d_0$",(int)strlen(Filename)-2,Filename+1,currfn->name,sym->name,sym->level);
        utstring_printf(debug_utstr,"%d", sym->scope_block); // Scope block
        utstring_printf(debug_utstr,"(");
        utstring_printf(debug_utstr,"{%d}", sym->ctype->size);
        write_cdb_type(sym->ctype, 0);
        utstring_printf(debug_utstr,")");
        utstring_printf(debug_utstr,",B,1,%d",sym->offset.i);
    } else {
        return;
    }
    utstring_printf(debug_utstr,"\n");
}

void debug_write_type(Type *type)
{
    int i;
    printf("WRite type %d\n",type->kind);
    utstring_printf(debug_utstr,"T:F%.*s$%s",(int)strlen(Filename)-2,Filename+1,type->name);
    write_cdb_type(type, 0);

    if ( type->kind == KIND_STRUCT) {
        utstring_printf(debug_utstr,"[");
        for ( i = 0; i < array_len(type->fields); i++) {
            Type *f = array_get_byindex(type->fields, i);
            utstring_printf(debug_utstr,"({%d}S:S$%s$0_0$0(",(int)f->offset,f->name);
            write_cdb_type(f,0);
            utstring_printf(debug_utstr,"),Z,0,0)");
        }
        utstring_printf(debug_utstr,"]");
    }


    utstring_printf(debug_utstr,"\n");
} 

void write_cdb_type(Type *type,int comma)
{
    if ( type->ptr ) {
        if ( type->kind == KIND_ARRAY ) {
            utstring_printf(debug_utstr,"%sDA%dd", comma ? "," : "",type->len);
        } else {
            utstring_printf(debug_utstr,"%sDG", comma ? "," : "");
        }
        write_cdb_type(type->ptr, 1);
        return;
    }

    switch ( type->kind ) {
    case KIND_NONE:
        return;
    case KIND_VOID:
        utstring_printf(debug_utstr,"%sDV",comma ? "," : "");
        break;
    case KIND_CHAR:
        utstring_printf(debug_utstr,"%sSC:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_SHORT:
        utstring_printf(debug_utstr,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_INT:
        utstring_printf(debug_utstr,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_LONG:
        utstring_printf(debug_utstr,"%sSL:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_LONGLONG:
        // This is wrong, but so is sdcc
        utstring_printf(debug_utstr,"%sSI:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_FLOAT:
    case KIND_DOUBLE:    
        utstring_printf(debug_utstr,"%sSF:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_FLOAT16:
        utstring_printf(debug_utstr,"%sS6:%s", comma ? "," : "", type->isunsigned ? "U" : "S");
        break;
    case KIND_ARRAY:
        utstring_printf(debug_utstr,"%sDA%d", comma ? "," : "", type->size);
        break;
    case KIND_PTR:
        break;
    case KIND_CPTR:
       // utstring_printf(output,"*__far ");
        break;
    case KIND_STRUCT:
        utstring_printf(debug_utstr,"%sST_%s", comma ? "," : "", type->name);
        break;
    case KIND_FUNC:
        utstring_printf(debug_utstr,"%sDF", comma ? "," : "");
        write_cdb_type(type->return_type, 1);
        return;
    case KIND_ELLIPSES:
        return;
    case KIND_PORT8:
    case KIND_PORT16:
    case KIND_ENUM:
    case KIND_CARRY:
        break;
    }
    return;

}



/*
    char tail[100];
    int  i;

    tail[0] = 0;

    if ( type->ptr )
        type_describe(type->ptr,output);

    if ( type->namespace ) {
        utstring_printf(output,"%s ", type->namespace);
    }

    if ( type->isconst ) {
        utstring_printf(output,"const ");
    }
   
    switch ( type->kind ) {
    case KIND_NONE:
        return;
    case KIND_VOID:
        utstring_printf(output, "void ");
        break;
    case KIND_CHAR:
        utstring_printf(output,"%schar ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_SHORT:
        utstring_printf(output,"%sshort ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_INT:
        utstring_printf(output,"%sint ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_LONG:
        utstring_printf(output,"%slong ",type->isunsigned ? "unsigned " : "");
        break;
    case KIND_FLOAT:
    case KIND_DOUBLE:    
        utstring_printf(output,"double ");
        break;
    case KIND_FLOAT16:
        utstring_printf(output,"_Float16 ");
        break;
    case KIND_ARRAY:
        snprintf(tail, sizeof(tail),"[%d]",type->len);
        break;
    case KIND_PTR:
        utstring_printf(output,"*");
        break;
    case KIND_CPTR:
        utstring_printf(output,"*__far ");
        break;
    case KIND_STRUCT:
        utstring_printf(output,"%s %s ",type->tag->isstruct ? "struct" : "union", type->tag->name);
        break;
    case KIND_FUNC:
        type_describe(type->return_type, output);
        utstring_printf(output,"%s(",type->name);
        for ( i = 0; i < array_len(type->parameters) ; i++ ) {
            if ( i ) utstring_printf(output,", ");
            type_describe(array_get_byindex(type->parameters,i), output);
        }
        utstring_printf(output,")");
        return;
    case KIND_ELLIPSES:
        utstring_printf(output,"...");
        return;
    case KIND_PORT8:
    case KIND_PORT16:
    case KIND_ENUM:
    case KIND_CARRY:
        break;
    }
    utstring_printf(output,"%s%s",type->name,tail);
    return;

*/
