# toZ80.awk
# Convert any 8080 assembler source file to Z80 mnemonics
# Copyright (c) 2003 Douglas Beattie Jr.
# All rights reserved world-wide
#
# Re-arranged for Z88DK by Stefano Bodrato
# Feb 2015: added partial support for the old style Z80
# CP/M assemblers mnemonics, i.e. the Thechnical Design Lab one (TDL).
#
# $Id: toZ80.awk,v 1.9 2015-02-10 12:41:38 stefano Exp $
#


BEGIN {
 temp_xyz = "z_z"     # temporary replacement for Mnemonic
 temp_label = "zzz" # temporary replacement for ^LABEL
 label = "?"          # storage for label during conversion
 label_reg_exp = "^[^; \t]+"
 instr_tabulator = "\t" # space between operator and operand on some converted

 # Record separator
 RS = "\r\n|\n"		# try first CRLF then CR alone
 # RS = "\r\n|\n|!"	# try this one to split if one liners are used

}

############ FUNCTIONS ############

function save_label() {
    if (match($0,/^[^; \t]+/)) {
        label = substr($0,RSTART,RLENGTH)
        #printf("%d %d",RSTART,RLENGTH);
        sub(label_reg_exp,temp_label)
    }
  #save symbols
        sub(/@/,"czhzi");
        sub(/+/,"pzlzs");
        sub(/-/,"mzizn");
        sub(/*/,"mzuzl");  #*/  just to fix the colouring of some editor :o)
        sub("/","dzizv");
}


function restore_label() {
    if (label != "?") {
        sub(temp_label,label)
        label = "?"          # init for next label
    }
  #restore symbols
        sub("czhzi",/@/);
        sub("pzlzs","+");
        sub("mzizn","-");
        sub("mzuzl","*");
        sub("dzizv","/");
}


function get_operand(op_regexp,op_len) {
        regexp_str = op_regexp "[ \t]+[^ \t,]+([, \t]|$)"
        match($0,regexp_str);
        tmp_str = substr($0,(RSTART+op_len),(RLENGTH-(op_len)))
        match(tmp_str,/[^ \t,]+/);
        tmp_str = substr(tmp_str,(RSTART),(RLENGTH))
        return tmp_str
}


# Substitute BC for B, DE for D, or HL for H in operand field
function sub_bdh() {
    if (match(wkg_str,/[BbDdHhXxYy]/)) {
        if (match(wkg_str,/[Bb]/)) {
            sub(/[Bb]/,"BC");
        }
        else if (match(wkg_str,/[Dd]/)) {
            sub(/[Dd]/,"DE");
        }
        else if (match(wkg_str,/[Hh]/)) {
            sub(/[Hh]/,"HL");
        }
    }
}

# Substitute IX for X, IY for Y in operand field
function sub_xy() {
    if (match(wkg_str,/[XxYy]/)) {
		if (match(wkg_str,/[Xx]/)) {
            sub(/[Xx]/,"IX");
        }
        else if (match(wkg_str,/[Yy]/)) {
            sub(/[Yy]/,"IY");
        }
    }
}

# Substitute (IX+n) for n(X), (IY+n) for n(Y) in operand field
function sub_xy_idx() {
    if (match(wkg_str,/[\(][XxYy][\)]/)) {
		if (match(wkg_str,/[\(][Xx][\)]/)) {
            sub(/[Xx]/,"");
			wkg_str = "(IX+" + wkg_str + ")";
        }
        else if (match(wkg_str,/[\(][Yy][\)]/)) {
            sub(/[Yy]/,"");
			wkg_str = "(IY+" + wkg_str + ")";
        }
    }
}

############ MAIN LOOP ############

#### look for ".+" and ".-"
    (/^[^;]*[ \t][.][\+\-]/) {
        sub(/[\.][\+]/,"ASMPC+");
        sub(/[\.][\-]/,"ASMPC-");
    }

#### .LOC to "ORG"
    (/^[^; \t]*[ \t]+([.][L][O][C])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/''/,"zpicettaz");

	sub(/'/,"\"");
	sub(/'/,"\"");
        sub(/[.][L][O][C]/,"ORG");

        sub("zpicettaz","'");
        restore_label()
        print $0
        next
    }

#### Z80ASM label redefinition
#### EQU to "DEFC"
    (/^[^;]*[ \t]+[eE][qQ][uU][ \t]/) {
    	#save_label()
        #restore_label()
        match_counter=match($0,/;/);
        match_result="";
        if (match_counter>0) match_result=substr($0,match_counter);
        # get rid of terminating ":" if any
        if (match($1,/:$/)) {
          print "DEFC", substr($1,0,RSTART-1), " = " ,$3, match_result
        }
        else {
          print "DEFC", $1, " = " ,$3, match_result
        }
        next
    }

#### = to "DEFC"
    (/^[^;]*[ \t]+[=][ \t]/) {
    	#save_label()
        #restore_label()
        match_counter=match($0,/;/);
        match_result="";
        if (match_counter>0) match_result=substr($0,match_counter);
        # get rid of terminating ":" if any
        if (match($1,/:$/)) {
          print "DEFC", substr($1,0,RSTART-1), " = " ,$3, match_result
        }
        else {
          print "DEFC", $1, " = " ,$3, match_result
        }
        next
    }
    
#### db to "DEFM"
    (/^[^; \t]*[ \t]+([Dd][Bb])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/''/,"zpicettaz");

	sub(/'/,"\"");
	sub(/'/,"\"");
        sub(/[Dd][Bb]/,"DEFM");

        sub("zpicettaz","'");
        restore_label()

        print $0
        next
    }

#### .ASCII to "DEFM"
#### db to "DEFM"
    (/^[^; \t]*[ \t]+([.][A][S][C][I][I])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/''/,"zpicettaz");

	sub(/'/,"\"");
	sub(/'/,"\"");
        sub(/[.][A][S][C][I][I]/,"DEFM");

        sub("zpicettaz","'");
        restore_label()
		# [^H00] hex format (TDL SYNTAX)
		if (match($0,/\[\^[Hh]/)) {
			gsub(/\[\^[Hh]/,"$");
			gsub(/\]/,",");
		}
		
        print $0
        next
    }

#### .BYTE to "DEFB"
    (/^[^; \t]*[ \t]+([.][B][Y][T][E])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/''/,"zpicettaz");

	sub(/'/,"\"");
	sub(/'/,"\"");
        sub(/[.][B][Y][T][E]/,"DEFB");

        sub("zpicettaz","'");
        restore_label()
        print $0
        next
    }

#### ds to "DEFS"
    (/^[^; \t]*[ \t]+([Dd][Ss])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ss]/,"DEFS");
        restore_label()
        print $0
        next
    }

#### .BLKB to "DEFS"
    (/^[^; \t]*[ \t]+([.][B][L][K][B])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[.][B][L][K][B]/,"DEFS");
        restore_label()
        print $0
        next
    }

#### .BLKW to "DEFS 2*"
    (/^[^; \t]*[ \t]+([.][B][L][K][W])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[.][B][L][K][W]/,"DEFS"instr_tabulator"2*");
        restore_label()
        print $0
        next
    }

#### dw to "DEFW"
    (/^[^; \t]*[ \t]+([Dd][Ww])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ww]/,"DEFW");
        restore_label()
        print $0
        next
    }

#### .WORD to "DEFW"
    (/^[^; \t]*[ \t]+([.][W][O][R][D])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[.][W][O][R][D]/,"DEFW");
        restore_label()
        print $0
        next
    }

#### Label section end


#### look for "r,M"
    (/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[mM]([; \t]|$)/) {
        sub(/,[mM]/,",(HL)");
    }


#### look for "M,r"
    (/^[^; \t]*[ \t]+[^; \t]+[ \t]+[mM],[^; \t]+([; \t]|$)/) {
        sub(/[mM],/,"(HL),");
    }

#### look for n(X), n(Y) Z80 index registers
    (/[^,; \t][\(][XxYy][\)]/) {
		if (match($0,/[^,; \t][_0-f\+\-]*[\(][XxYy][\)]/)) {
			label = substr($0,RSTART,RLENGTH);
			tmp_str = substr($0,(RSTART),(RLENGTH)-3)

			# Negative sign ?
			if (tmp_str ~ /-/) {
				sub(/[^,; \t][_0-f\+\-]*[\(][Xx][\)]/,"(IX" tmp_str ")");
				sub(/[^,; \t][_0-f\+\-]*[\(][Yy][\)]/,"(IY" tmp_str ")");
			} else {
				sub(/[^,; \t][_0-f\+\-]*[\(][Xx][\)]/,"(IX+" tmp_str ")");
				sub(/[^,; \t][_0-f\+\-]*[\(][Yy][\)]/,"(IY+" tmp_str ")");
			}
		}
	}

#### MOV
############################
    (/^[^; \t]*[ \t]+[Mm][Oo][Vv][ \t]/) {
        save_label()
        sub(/[Mm][Oo][Vv]/,"LD ");
        restore_label()
        print $0
        next
    }

#### MVI
############################
    (/^[^; \t]*[ \t]+[Mm][Vv][Ii][ \t]/) {
        save_label()
        sub(/[Mm][Vv][Ii]/,"LD ");
        restore_label()
        print $0
        next
    }

#### LDAX
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa][Xx])/) {
        save_label()

        wkg_str =  get_operand("[Ll][Dd][Aa][Xx]",4);

        if (match(wkg_str,/[Dd]/)) {
            sub(/[Ll][Dd][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"A,(DE)");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

        else if (match(wkg_str,/[Bb]/)) {
            sub(/[Ll][Dd][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"A,(BC)");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

    }


#### STAX
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa][Xx])/) {
        save_label()

        wkg_str =  get_operand("[Ss][Tt][Aa][Xx]",4);

        if (match(wkg_str,/[Dd]/)) {
            sub(/[Ss][Tt][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"(DE),A");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

        else if (match(wkg_str,/[Bb]/)) {
            sub(/[Ss][Tt][Aa][Xx]/,temp_xyz);
            sub(wkg_str,"(BC),A");
            sub(temp_xyz,"LD");

            restore_label()
            print $0
            next
        }

    }

###### LDAR (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa][Rr])([; \t]|$)/) {
        save_label()
        sub(/[Ll][Dd][Aa][Rr]/,"LD"instr_tabulator"A,R");
        restore_label()
        print $0
        next
    }

###### LDAI (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa][Ii])([; \t]|$)/) {
        save_label()
        sub(/[Ll][Dd][Aa][Ii]/,"LD"instr_tabulator"A,I");
        restore_label()
        print $0
        next
    }

###### STAR (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa][Rr])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Tt][Aa][Rr]/,"LD"instr_tabulator"R,A");
        restore_label()
        print $0
        next
    }

###### STAI (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa][Ii])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Tt][Aa][Ii]/,"LD"instr_tabulator"I,A");
        restore_label()
        print $0
        next
    }

### LDA word
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Aa])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Ll][Dd][Aa]",3);
            sub(/[Ll][Dd][Aa]/,temp_xyz);
            sub(wkg_str,"A,(" wkg_str ")" );
            sub(temp_xyz,"LD");

        restore_label()
        print $0
        next

    }

### STA word
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Aa])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Ss][Tt][Aa]",3);

            sub(/[Ss][Tt][Aa]/,temp_xyz);
            sub(wkg_str,"(" wkg_str "),A" );
            sub(temp_xyz,"LD");

        restore_label()
        print $0
        next

    }

###   LXI   B/D/H/SP,word
############################
    (/^[^; \t]*[ \t]+([Ll][Xx][Ii])/) {
        save_label()


        wkg_str =  get_operand("[Ll][Xx][Ii]",3);
        sub_bdh()
        sub(/[Ll][Xx][Ii]/,"LD");
        sub_xy()

        restore_label()
        print $0
        next
    }

### LHLD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Hh][Ll][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Hh][Ll][Dd]",4);

            sub(/[Ll][Hh][Ll][Dd]/,temp_xyz);
            sub(wkg_str,"HL,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LBCD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Bb][Cc][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Bb][Cc][Dd]",4);

            sub(/[Ll][Bb][Cc][Dd]/,temp_xyz);
            sub(wkg_str,"BC,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LDED word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Ee][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Dd][Ee][Dd]",4);

            sub(/[Ll][Dd][Ee][Dd]/,temp_xyz);
            sub(wkg_str,"DE,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }
	
### LSPD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Ss][Pp][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Ss][Pp][Dd]",4);

            sub(/[Ll][Ss][Pp][Dd]/,temp_xyz);
            sub(wkg_str,"SP,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LIXD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Ii][Xx][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Ii][Xx][Dd]",4);

            sub(/[Ll][Ii][Xx][Dd]/,temp_xyz);
            sub(wkg_str,"IX,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LXIX word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Xx][Ii][Xx])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Xx][Ii][Xx]",4);

            sub(/[Ll][Xx][Ii][Xx]/,temp_xyz);
            sub(wkg_str,"IX," wkg_str );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LIYD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Ii][Yy][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Ii][Yy][Dd]",4);

            sub(/[Ll][Ii][Yy][Dd]/,temp_xyz);
            sub(wkg_str,"IY,(" wkg_str ")" );
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### LXIY word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ll][Xx][Ii][Yy])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ll][Xx][Ii][Yy]",4);

            sub(/[Ll][Xx][Ii][Yy]/,temp_xyz);
            sub(wkg_str,"IY," wkg_str);
            sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SBCD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Bb][Cc][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Bb][Cc][Dd]",4);

        sub(/[Ss][Bb][Cc][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),BC" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SDED word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Dd][Ee][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Dd][Ee][Dd]",4);

        sub(/[Ss][Dd][Ee][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),DE" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SSPD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Ss][Pp][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Ss][Pp][Dd]",4);

        sub(/[Ss][Ss][Pp][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),SP" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SIXD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Ii][Xx][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Ii][Xx][Dd]",4);

        sub(/[Ss][Ii][Xx][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),IX" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SIYD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Ii][Yy][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Ii][Yy][Dd]",4);

        sub(/[Ss][Ii][Yy][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),IY" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

### SHLD word (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ss][Hh][Ll][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Ss][Hh][Ll][Dd]",4);

        sub(/[Ss][Hh][Ll][Dd]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),HL" );
        sub(temp_xyz,"LD")

        restore_label()
        print $0
        next
    }

#### Simple replacements (no operand)
############################

###### INXIX (TDL SYNTAX)
###########################
    (/^[^; \t]*[ \t]+([Ii][Nn][Xx][Ii][Xx])([; \t]|$)/) {
        save_label()
        sub(/[Ii][Nn][Xx][Ii][Xx]/,"INC"instr_tabulator"IX");
        restore_label()
        print $0
        next
    }

###### INXIY (TDL SYNTAX)
###########################
    (/^[^; \t]*[ \t]+([Ii][Nn][Xx][Ii][Yy])([; \t]|$)/) {
        save_label()
        sub(/[Ii][Nn][Xx][Ii][Yy]/,"INC"instr_tabulator"IY");
        restore_label()
        print $0
        next
    }

###### DCXIX (TDL SYNTAX)
###########################
    (/^[^; \t]*[ \t]+([Dd][Cc][Xx][Ii][Xx])([; \t]|$)/) {
        save_label()
        sub(/[Dd][Cc][Xx][Ii][Xx]/,"DEC"instr_tabulator"IX");
        restore_label()
        print $0
        next
    }

###### DCXIY (TDL SYNTAX)
###########################
    (/^[^; \t]*[ \t]+([Dd][Cc][Xx][Ii][Yy])([; \t]|$)/) {
        save_label()
        sub(/[Dd][Cc][Xx][Ii][Yy]/,"DEC"instr_tabulator"IY");
        restore_label()
        print $0
        next
    }


###### SPHL
    (/^[^; \t]*[ \t]+([Ss][Pp][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Pp][Hh][Ll]/,"LD"instr_tabulator"SP,HL");
        restore_label()
        print $0
        next
    }

###### XCHG
    (/^[^; \t]*[ \t]+([Xx][Cc][Hh][Gg])([; \t]|$)/) {
        save_label()
        sub(/[Xx][Cc][Hh][Gg]/,"EX"instr_tabulator"DE,HL");
        restore_label()
        print $0
        next
    }

###### XTHL
    (/^[^; \t]*[ \t]+([Xx][Tt][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Xx][Tt][Hh][Ll]/,"EX"instr_tabulator"(SP),HL");
        restore_label()
        print $0
        next
    }

###### HLT
    (/^[^; \t]*[ \t]+([Hh][Ll][Tt])/) {
        save_label()
        sub(/[Hh][Ll][Tt]/,"HALT");
        restore_label()
        print $0
        next
    }

###### PCHL
    (/^[^; \t]*[ \t]+([Pp][Cc][Hh][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Pp][Cc][Hh][Ll]/,"JP"instr_tabulator"(HL)");
        restore_label()
        print $0
        next
    }

###### ADI ACI
############################
    (/^[^; \t]*[ \t]+[aA]([dD]|[cC])[iI][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[aA]([dD]|[cC])[iI]",3);

        if (match($0,/[Aa][Dd][Ii]/)) {
            sub(/[Aa][Dd][Ii]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADD")
        }
        else if (match($0,/[Aa][Cc][Ii]/)) {
            sub(/[Aa][Cc][Ii]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADC")
        }

        restore_label()
        print $0;
        next
    }


###### SUI SBI
############################
    (/^[^; \t]*[ \t]+[sS]([uU]|[bB])[iI][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Ss][Uu][Ii]/)) {
            sub(/[Ss][Uu][Ii]/,"SUB");
        }
        else if (match($0,/[Ss][Bb][Ii]/)) {
            sub(/[Ss][Bb][Ii]/,"SBC");
        }

        restore_label()
        print $0;
        next
    }

###### SBB
    (/^[^; \t]*[ \t]+[sS][bB][bB][ \t]+[^ \t]+([; \t]|$)/) {

        wkg_str =  get_operand("([Ss][Bb][Bb])",3);

		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }

        save_label()

        if (match($0,/[sS][bB][bB]/)) {
            sub(/[sS][bB][bB]/,"SBC");
        }

        restore_label()
        print $0;
        next
    }

###### SUB M
    (/^[^; \t]*[ \t]+[sS][uU][bB][ \t]+[^ \t]+([; \t]|$)/) {

        wkg_str =  get_operand("([Ss][Uu][Bb])",3);

		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }

        print $0;
        next
    }

###### ADD ADC
############################
    (/^[^; \t]*[ \t]+([aA][dD][dD]|[aA][dD][cC])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("([aA][dD][dD]|[aA][dD][cC])",3);

        if (match($0,/[Aa][Dd][Dd]/)) {
            sub(/[Aa][Dd][Dd]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADD")
        }
        else if (match($0,/[Aa][Dd][Cc]/)) {
            sub(/[Aa][Dd][Cc]/,temp_xyz);
            sub(wkg_str,"A," wkg_str );
            sub(temp_xyz,"ADC")
        }

		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }

        restore_label()
        print $0
        next
    }

###### DADC (TDL SYNTAX)
################################

    (/^[^; \t]*[ \t]+([dD][aA][dD][cC])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][aA][dD][cC]",4);
        sub(/[dD][aA][dD][cC]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"ADC")
        sub(/ADC[ \t]*/,"ADC"instr_tabulator"HL,")
        restore_label()
        print $0
        next
    }

###### DSBC (TDL SYNTAX)
################################

    (/^[^; \t]*[ \t]+([dD][sS][bB][cC])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][sS][bB][cC]",4);
        sub(/[dD][sS][bB][cC]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"SBC")
        sub(/SBC[ \t]*/,"SBC"instr_tabulator"HL,")
        restore_label()
        print $0
        next
    }

###### DADX (TDL SYNTAX)
################################

    (/^[^; \t]*[ \t]+([dD][aA][dD][xX])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][aA][dD][xX]",4);
        sub(/[dD][aA][dD][xX]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"ADD")
        sub(/ADD[ \t]*/,"ADD"instr_tabulator"IX,")
        restore_label()
        print $0
        next
    }

###### DADY (TDL SYNTAX)
################################

    (/^[^; \t]*[ \t]+([dD][aA][dD][yY])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][aA][dD][yY]",4);
        sub(/[dD][aA][dD][yY]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"ADD")
        sub(/ADD[ \t]*/,"ADD"instr_tabulator"IY,")
        restore_label()
        print $0
        next
    }

###### DAD
############################

    (/^[^; \t]*[ \t]+([dD][aA][dD])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[dD][aA][dD]",3);
        sub(/[dD][aA][dD]/,temp_xyz);
        sub_bdh()
        sub(temp_xyz,"ADD")
        sub(/ADD[ \t]*/,"ADD"instr_tabulator"HL,")
        restore_label()
        print $0
        next
    }


###### INR DCR
############################
    (/^[^; \t]*[ \t]+([Ii][Nn][Rr]|[Dd][Cc][Rr])[ \t]/) {
        save_label()

        wkg_str =  get_operand("([Ii][Nn][Rr]|[Dd][Cc][Rr])",3);

		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }

        if (match($0,/[Ii][Nn][Rr]/)) {
            sub(/[Ii][Nn][Rr]/,"INC");
        }
        else if (match($0,/[Dd][Cc][Rr]/)) {
            sub(/[Dd][Cc][Rr]/,"DEC");
        }

        restore_label()
        print $0
        next
    }

###### INX DCX
############################
    (/^[^; \t]*[ \t]+([Ii][Nn][Xx]|[Dd][Cc][Xx])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("([Ii][Nn][Xx]|[Dd][Cc][Xx])",3);

        if (match($0,/[Ii][Nn][Xx]/)) {
            sub(/[Ii][Nn][Xx]/,temp_xyz);
            sub_bdh()
            sub(temp_xyz,"INC")
            sub_xy()
        }
        else if (match($0,/[Dd][Cc][Xx]/)) {
            sub(/[Dd][Cc][Xx]/,temp_xyz);
            sub_bdh()
            sub(temp_xyz,"DEC")
            sub_xy()
        }

        restore_label()
        print $0
        next
    }


###### CMA
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Mm][Aa]/,"CPL");
        restore_label()
        print $0
        next
    }

###### STC
############################
    (/^[^; \t]*[ \t]+([Ss][Tt][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Tt][Cc]/,"SCF");
        restore_label()
        print $0
        next
    }

###### CMC
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Mm][Cc]/,"CCF");
        restore_label()
        print $0
        next
    }

###### SRAR SLAR SRLR RARR RALR 
#################################
    (/^[^; \t]*[ \t]+([Ss][Rr][Aa][Rr]|[Ss][Ll][Aa][Rr]|[Ss][Rr][Ll][Rr]|[Rr][Aa][Rr][Rr]|[Rr][Aa][Ll][Rr])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Ss][Rr][Aa][Rr]/)) {
            sub(/[Ss][Rr][Aa][Rr]/,"SRA");
        }
        else if (match($0,/[Ss][Ll][Aa][Rr]/)) {
            sub(/[Ss][Ll][Aa][Rr]/,"SLA");
        }
        else if (match($0,/[Ss][Rr][Ll][Rr]/)) {
            sub(/[Ss][Rr][Ll][Rr]/,"SRL");
        }
        else if (match($0,/[Rr][Aa][Rr][Rr]/)) {
            sub(/[Rr][Aa][Rr][Rr]/,"RR");
        }
        else if (match($0,/[Rr][Aa][Ll][Rr]/)) {
            sub(/[Rr][Aa][Ll][Rr]/,"RR");
        }
        restore_label()
        print $0;
        next
    }

###### RLCR RRCR
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Cc][Rr]|[Rr][Rr][Cc][Rr])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Rr][Ll][Cc][Rr]/)) {
            sub(/[Rr][Ll][Cc][Rr]/,"RLC");
        }
        else if (match($0,/[Rr][Rr][Cc][Rr]/)) {
            sub(/[Rr][Rr][Cc][Rr]/,"RRC");
        }
        restore_label()
        print $0;
        next
    }

###### RLC
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Ll][Cc]/,"RLCA");
        restore_label()
        print $0
        next
    }

###### RRC
############################
    (/^[^; \t]*[ \t]+([Rr][Rr][Cc])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Rr][Cc]/,"RRCA");
        restore_label()
        print $0
        next
    }

###### RAL
############################
    (/^[^; \t]*[ \t]+([Rr][Aa][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Aa][Ll]/,"RLA");
        restore_label()
        print $0
        next
    }

###### RAR
############################
    (/^[^; \t]*[ \t]+([Rr][Aa][Rr])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Aa][Rr]/,"RRA");
        restore_label()
        print $0
        next
    }

###### ANI XRI ORI
############################
    (/^[^; \t]*[ \t]+([Aa][Nn][Ii]|[Xx][Rr][Ii]|[Oo][Rr][Ii])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Aa][Nn][Ii]/)) {
            sub(/[Aa][Nn][Ii]/,"AND");
        }
        else if (match($0,/[Xx][Rr][Ii]/)) {
            sub(/[Xx][Rr][Ii]/,"XOR");
        }
        else if (match($0,/[Oo][Rr][Ii]/)) {
            sub(/[Oo][Rr][Ii]/,"OR");
        }
        restore_label()
        print $0;
        next
    }

###### ANA XRA ORA
############################
    (/^[^; \t]*[ \t]+([Aa][Nn][Aa]|[Xx][Rr][Aa]|[Oo][Rr][Aa])[ \t]/) {
        save_label()

        wkg_str =  get_operand("([Aa][Nn][Aa]|[Xx][Rr][Aa]|[Oo][Rr][Aa])",3);

		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }

        if (match($0,/[Aa][Nn][Aa]/)) {
            sub(/[Aa][Nn][Aa]/,"AND");
        }
        else if (match($0,/[Xx][Rr][Aa]/)) {
            sub(/[Xx][Rr][Aa]/,"XOR");
        }
        else if (match($0,/[Oo][Rr][Aa]/)) {
            sub(/[Oo][Rr][Aa]/,"OR");
        }

        restore_label()
        print $0
        next
    }

###### CPI
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Ii])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Pp][Ii]/,"CP");

        restore_label()
        print $0;
        next
    }

###### CCIR (TDL Syntax)
############################
    (/^[^; \t]*[ \t]+([Cc][Cc][Ii][Rr])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Cc][Ii][Rr]/,"CPIR");

        restore_label()
        print $0;
        next
    }

###### CCDR (TDL Syntax)
############################
    (/^[^; \t]*[ \t]+([Cc][Cc][Dd][Rr])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Cc][Dd][Rr]/,"CPDR");

        restore_label()
        print $0;
        next
    }

###### CCI (TDL Syntax)
############################
    (/^[^; \t]*[ \t]+([Cc][Cc][Ii])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Cc][Ii]/,"CPI");

        restore_label()
        print $0;
        next
    }

###### CCD (TDL Syntax)
############################
    (/^[^; \t]*[ \t]+([Cc][Cc][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Cc][Cc][Dd]/,"CPD");

        restore_label()
        print $0;
        next
    }

###### CMP
############################
    (/^[^; \t]*[ \t]+([Cc][Mm][Pp])[ \t]/) {
        save_label()

        wkg_str =  get_operand("[Cc][Mm][Pp]",3);

        sub(/[Cc][Mm][Pp]/,temp_xyz);
		if  ((wkg_str == "M")||(wkg_str == "m")) {
            sub(/[Mm]/,"(HL)");
        }
        sub(temp_xyz,"CP")

        restore_label()
        print $0
        next
    }

###### EXAF (TDL SYNTAX)
############################
    (/^[^; \t]*[ \t]+([Ee][Xx][Aa][Ff])([; \t]|$)/) {
        save_label()
        sub(/[Ee][Xx][Aa][Ff]/,"EX"instr_tabulator"AF,AF");
        restore_label()
        print $0
        next
    }

###### JMP
############################
    (/^[^; \t]*[ \t]+([Jj][Mm][Pp])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Jj][Mm][Pp]/,"JP");

        restore_label()
        print $0;
        next
    }

###### JNZ JNC JPO JPE
############################
    (/^[^; \t]*[ \t]+[Jj]([Nn][Zz]|[Nn][Cc]|[Pp][Oo]|[Pp][Ee])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Jj][Nn][Zz][ \t]+/)) {
            sub(/[Jj][Nn][Zz][ \t]+/,"JP"instr_tabulator"NZ,");
        }
        else if (match($0,/[Jj][Nn][Cc][ \t]+/)) {
            sub(/[Jj][Nn][Cc][ \t]+/,"JP"instr_tabulator"NC,");
        }
        else if (match($0,/[Jj][Pp][Oo][ \t]+/)) {
            sub(/[Jj][Pp][Oo][ \t]+/,"JP"instr_tabulator"PO,");
        }
        else if (match($0,/[Jj][Pp][Ee][ \t]+/)) {
            sub(/[Jj][Pp][Ee][ \t]+/,"JP"instr_tabulator"PE,");
        }

        restore_label()
        print $0;
        next
    }

###### JMPR (TDL SYNTAX)
##############################
    (/^[^; \t]*[ \t]+([Jj][Mm][Pp][Rr])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Jj][Mm][Pp][Rr][ \t]+/)) {
            sub(/[Jj][Mm][Pp][Rr][ \t]+/,"JR"instr_tabulator);
        }

        restore_label()
        print $0;
        next
    }

###### JRNZ JRNC (TDL SYNTAX)
################################
    (/^[^; \t]*[ \t]+[Jj]([Rr][Nn][Zz]|[Rr][Nn][Cc])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Jj][Rr][Nn][Zz][ \t]+/)) {
            sub(/[Jj][Rr][Nn][Zz][ \t]+/,"JR"instr_tabulator"NZ,");
        }
        else if (match($0,/[Jj][Rr][Nn][Cc][ \t]+/)) {
            sub(/[Jj][Rr][Nn][Cc][ \t]+/,"JR"instr_tabulator"NC,");
        }

        restore_label()
        print $0;
        next
    }

###### JZ JC JP JM
############################
    (/^[^; \t]*[ \t]+[Jj]([Zz]|[Cc]|[Pp]|[Mm])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/^[^;]*[Jj][Zz][ \t]+/)) {
            sub(/[Jj][Zz][ \t]+/,"JP"instr_tabulator"Z,");
        }
        else if (match($0,/^[^;]*[Jj][Cc][ \t]+/)) {
            sub(/[Jj][Cc][ \t]+/,"JP"instr_tabulator"C,");
        }
        else if (match($0,/^[^;]*[Jj][Pp][ \t]+/)) {
            sub(/[Jj][Pp][ \t]+/,"JP"instr_tabulator"P,");
        }
        else if (match($0,/^[^;]*[Jj][Mm][ \t]+/)) {
            sub(/[Jj][Mm][ \t]+/,"JP"instr_tabulator"M,");
        }

        restore_label()
        print $0;
        next
    }

###### JRZ JRC (TDL SYNTAX)
##############################
    (/^[^; \t]*[ \t]+[Jj]([Rr][Zz]|[Rr][Cc])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Jj][Rr][Zz][ \t]+/)) {
            sub(/[Jj][Rr][Zz][ \t]+/,"JR"instr_tabulator"Z,");
        }
        else if (match($0,/[Jj][Rr][Cc][ \t]+/)) {
            sub(/[Jj][Rr][Cc][ \t]+/,"JR"instr_tabulator"C,");
        }

        restore_label()
        print $0;
        next
    }



###### CNZ CNC CPO CPE
############################
    (/^[^; \t]*[ \t]+[Cc]([Nn]([Zz]|[Cc])|([Pp]([Oo]|[Ee])))[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Cc][Nn][Zz][ \t]+/)) {
            sub(/[Cc][Nn][Zz][ \t]+/,"CALL"instr_tabulator"NZ,");
        }
        else if (match($0,/[Cc][Nn][Cc][ \t]+/)) {
            sub(/[Cc][Nn][Cc][ \t]+/,"CALL"instr_tabulator"NC,");
        }
        else if (match($0,/[Cc][Pp][Oo][ \t]+/)) {
            sub(/[Cc][Pp][Oo][ \t]+/,"CALL"instr_tabulator"PO,");
        }
        else if (match($0,/[Cc][Pp][Ee][ \t]+/)) {
            sub(/[Cc][Pp][Ee][ \t]+/,"CALL"instr_tabulator"PE,");
        }

        restore_label()
        print $0;
        next
    }

###### CZ CC CP CM
############################
    (/^[^; \t]*[ \t]+[Cc]([Zz]|[Cc]|[Pp]|[Mm])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        if (match($0,/[Cc][Zz][ \t]+/)) {
            sub(/[Cc][Zz][ \t]+/,"CALL"instr_tabulator"Z,");
        }
        else if (match($0,/[Cc][Cc][ \t]+/)) {
            sub(/[Cc][Cc][ \t]+/,"CALL"instr_tabulator"C,");
        }
        else if (match($0,/[Cc][Pp][ \t]+/)) {
            sub(/[Cc][Pp][ \t]+/,"CALL"instr_tabulator"P,");
        }
        else if (match($0,/[Cc][Mm][ \t]+/)) {
            sub(/[Cc][Mm][ \t]+/,"CALL"instr_tabulator"M,");
        }

        restore_label()
        print $0;
        next
    }

###### RNZ RNC RPO RPE
############################

    (/^[^; \t]*[ \t]+[Rr]([Nn]([Zz]|[Cc])|([Pp]([Oo]|[Ee])))/) {

        save_label()

        if (match($0,/[Rr][Nn][Zz]+/)) {
            sub(/[Rr][Nn][Zz]+/,"RET"instr_tabulator"NZ");
        }
        else if (match($0,/[Rr][Nn][Cc]+/)) {
            sub(/[Rr][Nn][Cc]+/,"RET"instr_tabulator"NC");
        }
        else if (match($0,/[Rr][Pp][Oo][ \t]+/)) {
            sub(/[Rr][Pp][Oo]+/,"RET"instr_tabulator"PO");
        }
        else if (match($0,/[Rr][Pp][Ee][ \t]+/)) {
            sub(/[Rr][Pp][Ee]+/,"RET"instr_tabulator"PE");
        }

        restore_label()
        print $0;
        next
    }

###### RZ RC RP RM
############################

    (/^[^; \t]*[ \t]+[Rr]([Zz]|[Cc]|[Pp]|[Mm])/) {
        save_label()

        if (match($0,/[Rr][Zz]+/)) {
            sub(/[Rr][Zz]+/,"RET"instr_tabulator"Z");
        }
        else if (match($0,/[Rr][Cc]+/)) {
            sub(/[Rr][Cc]+/,"RET"instr_tabulator"C");
        }
        else if (match($0,/[Rr][Pp]+/)) {
            sub(/[Rr][Pp]+/,"RET"instr_tabulator"P");
        }
        else if (match($0,/[Rr][Mm]+/)) {
            sub(/[Rr][Mm]+/,"RET"instr_tabulator"M");
        }

        restore_label()
        print $0;
        next
    }

###### RST 0..7
############################
    (/^[^; \t]*[ \t]+([Rr][Ss][Tt])[ \t]/) {
        save_label()

        wkg_str =  get_operand("[Rr][Ss][Tt]",3);

        if (match(wkg_str,/^[^;]*1/)) {
            sub(/1/,"08h");
        }
        else if (match(wkg_str,/^[^;]*2/)) {
            sub(/2/,"10h");
        }
        else if (match(wkg_str,/^[^;]*3/)) {
            sub(/3/,"18h");
        }
        else if (match(wkg_str,/^[^;]*4/)) {
            sub(/4/,"20h");
        }
        else if (match(wkg_str,/^[^;]*5/)) {
            sub(/5/,"28h");
        }
        else if (match(wkg_str,/^[^;]*6/)) {
            sub(/6/,"30h");
        }
        else if (match(wkg_str,/^[^;]*7/)) {
            sub(/7/,"38h");
        }

        restore_label()
        print $0
        next
    }

###### PUSH B/D/H/PSW
############################

    (/^[^; \t]*[ \t]+([Pp][Uu][Ss][Hh])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Pp][Uu][Ss][Hh]",4);
        sub(/[Pp][Uu][Ss][Hh]/,temp_xyz);
        sub_bdh()
        sub_xy()
        if (match(wkg_str,/[Pp][Ss][Ww]/)) {
            sub(/[Pp][Ss][Ww]/,"AF");
        }
        sub(temp_xyz,"PUSH")

        restore_label()
        print $0
        next
    }

###### POP B/D/H/PSW
############################

    (/^[^; \t]*[ \t]+([Pp][Oo][Pp])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        wkg_str =  get_operand("[Pp][Oo][Pp]",3);
        sub(/[Pp][Oo][Pp]/,temp_xyz);
        sub_bdh()
        sub_xy()
        if (match(wkg_str,/[Pp][Ss][Ww]/)) {
            sub(/[Pp][Ss][Ww]/,"AF");
        }
        sub(temp_xyz,"POP")

        restore_label()
        print $0
        next
    }

### OUT byte
############################
    (/^[^; \t]*[ \t]+([Oo][Uu][Tt])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()


        wkg_str =  get_operand("[Oo][Uu][Tt]",3);

        sub(/[Oo][Uu][Tt]/,temp_xyz);
        sub(wkg_str,"(" wkg_str "),A" );
        sub(temp_xyz,"OUT")

        restore_label()
        print $0
        next
    }

### IN byte
############################
    (/^[^; \t]*[ \t]+([Ii][Nn])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

            wkg_str =  get_operand("[Ii][Nn]",2);

            sub(/[Ii][Nn]/,temp_xyz);
            sub(wkg_str,"A,(" wkg_str ")" );
            sub(temp_xyz,"IN")

        restore_label()
        print $0
        next
    }

#### Make END be the last line, 
#### so we get rid of some CP/M rubbish
###########################################
    (/^[^; \t]*[ \t]+([eE][nN][dD])([; \t]|$)/) {
        print $0
        exit
    }


###### Default
(/^.*/) {
    print $0
    next
}
