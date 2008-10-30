# to86.awk
# Convert a Z80ASM assembler source file to 8086/80486 mnemonics.
# The resulting code should be valid with NASM (Netwide Assembler)
#
# Based on the "toz80" tool By Douglas Beattie Jr.
#
# Re-arranged for Z88DK by Stefano Bodrato
#
# $Id: to86.awk,v 1.6 2008-10-30 17:44:13 stefano Exp $
#


BEGIN {
 temp_xyz = "zyzyxx"         # temporary replacement for Mnemonic
 temp_label = "zzlabelzz"    # temporary replacement for ^LABEL
 label = " "            # storage for label during conversion
 label_reg_exp = "^[^; \t]+"
 instr_tabulator = "\t" # space between operator and operand on some converted
 lblcnt = 0
 new_label = "L86L0"
 another_label = "L86L0"

 # Record separator
 RS = "\r\n|\n"         # try first CRLF then CR alone
 # RS = "\r\n|\n|!"     # try this one to split if one liners are used

 # MODE486: 1 if the dest. CPU is capable of 486 instructions, otherwise 0
 MODE486 = 1

 # At the very beginning, write a header and force the assembler 
 # to produce uppercase global object names

 print
 print "; Converted with 'to86.awk', part of the z88dk Developement Kit"
 print "; -------------------------------------------------------------"
 print
 print instr_tabulator "UPPERCASE  ; force 'nasm' to produce uppercase global object names"
 print
 print
}

############ FUNCTIONS ############

function al_comma(wkg_str) {
    if (!match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]*+[^; \t]+[,]+[^; \t]+*([; \t]|$)/)) {
        sub(wkg_str,"AL,"wkg_str )
        return 0
    }
    return 1
}


function make_new_label() {
    print label
    reset_label()
    lblcnt=lblcnt+1;
    new_label = "L86L" lblcnt
}


function save_label() {
    if (match($0,/^[^; \t]+/)) {
        label = substr($0,RSTART,RLENGTH)
        #printf("%d %d",RSTART,RLENGTH)
        sub(label_reg_exp,temp_label)
        if (match(label,/[.]/)) {
            if (RSTART == 1) { label = substr(label,2) ":" }
        }
    }
  #save symbols
        sub(/@/,"czhzi")
        sub(/+/,"pzlzs")
        sub(/-/,"mzizn")
        sub(/*/,"mzuzl")  #*/  just to fix the colouring of some editor :o)
        sub("/","dzizv")
        sub(/[$]/,"dzozl")
        sub(/[?]/,"qzezs")
        sub(/[\[]/,"zlzspz")
        sub(/[\]]/,"zrzspz")
        sub(/['][(][']/,"zlzprz")
        sub(/['][)][']/,"zrzprz")
        sub(/['][,][']/,"zczmaz")
        sub(/['][|][']/,"zpzpez")
        sub("\\&","zazndz")
}

function convert_dollar() {
  #convert definition for current location (Z80ASM -> NASM syntax conversion)
        sub(/[Aa][Ss][Mm][Pp][Cc]/,/[$]/)
}

function restore_label() {
    if (label != " ") {
        sub(temp_label,label)
        label = " "          # init for next label
    }
  #restore symbols
        sub("czhzi",/@/)
        sub("pzlzs","+")
        sub("mzizn","-")
        sub("mzuzl","*")
        sub("dzizv","/")
        sub("dzozl","\x24")	# dollar sign
        sub("qzezs","?")
        sub("zlzspz","[")
        sub("zrzspz","]")
        sub("zlzprz","'('")
        sub("zrzprz","')'")
        sub("zczmaz","','")
        sub("zpzpez","'|'")
        sub("zazndz","\\&")	# & symbol
  #convert brackets
        sub(/[{]/,"[")
        sub(/[}]/,"]")
        convert_dollar()
}

function reset_label() {
    if (label != " ") {
        sub(temp_label," ")
        label = " "          # init for next label
    }
  #restore symbols
        sub("czhzi",/@/)
        sub("pzlzs","+")
        sub("mzizn","-")
        sub("mzuzl","*")
        sub("dzizv","/")
        sub("dzozl","\x24")	# dollar sign
        sub("qzezs","?")
        sub("zlzspz","[")
        sub("zrzspz","]")
        sub("zlzprz","'('")
        sub("zrzprz","')'")
        sub("zczmaz","','")
        sub("zpzpez","'|'")
        sub("zazndz","\\&")	# & symbol
}

function get_operand(op_regexp,op_len) {
        regexp_str = op_regexp "[ \t]+[^ \t,]+([, \t]|$)"
        match($0,regexp_str)
        tmp_str = substr($0,(RSTART+op_len),(RLENGTH-(op_len)))
        match(tmp_str,/[^ \t,]+/)
        tmp_str = substr(tmp_str,(RSTART),(RLENGTH))
        return tmp_str
}

function get_operand_block(op_regexp,op_len) {
        regexp_str = op_regexp "[ \t]+[^ \t]+([ \t]|$)"
        match($0,regexp_str)
        tmp_str = substr($0,(RSTART+op_len),(RLENGTH-(op_len)))
        match(tmp_str,/[^ \t]+/)
        tmp_str = substr(tmp_str,(RSTART),(RLENGTH))
        return tmp_str
}


function convert_line(wkg_operand, wkg_match, wkg_oplen) {
        save_label()

        sub(wkg_match,wkg_operand)

        wkg_str=get_operand_block(wkg_operand,wkg_oplen)
        if (!sub_ptr(wkg_str)) {
          sub_bdh(wkg_operand,wkg_str)
        }

        restore_label()
}

function convert_line_comma(wkg_operand, wkg_match, wkg_oplen) {
        save_label()

        sub(wkg_match,wkg_operand)

        wkg_str =  get_operand_block(wkg_operand,wkg_oplen)
        al_comma(wkg_str)
        sub_reg_comma()

        restore_label()
}

function convert_line_al(wkg_operand, wkg_match, wkg_oplen) {
        save_label()

        sub(wkg_match,wkg_operand)

        wkg_str=get_operand_block(wkg_operand,wkg_oplen)
        if (!sub_ptr(wkg_str)) {
           sub_bdh(wkg_operand,wkg_str)
        }

        wkg_str =  get_operand_block(wkg_operand,wkg_oplen)
        sub_reg_comma()

        wkg_str =  get_operand(wkg_operand,wkg_oplen)
        al_comma(wkg_str)


        restore_label()
}

function comma_one(wkg_operand,wkg_oplen) {
        wkg_str =  get_operand_block(wkg_operand,wkg_oplen)
        wkg_match = wkg_operand "[ \t]+" wkg_str
        sub(wkg_match,wkg_operand instr_tabulator wkg_str ",1")
}


#### register Remapping
#####################################
######  We want to keep AF unchanged, if will be managed in the single cases
########################################################


########################################################
# The trick:
# if this function gives zero, the A register was implicit
#############################################################
function sub_reg_comma() {
#############################################################

    if (!match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]*+[^; \t]+[,]+[^; \t]+*([; \t]|$)/)) {
        sub(/[(]/,"{")
        sub(/[)]/,"}")
        return 0
    }

# Substitute CX for BC, DX for DE, or BX for HL in operand field
# Mainly used for functions with a single operand
#

############################################
### REG,...

#### look for "(BC),r"
    if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[(][Bb][Cc][)],[^; \t]+([; \t]|$)/)) {
        if (label != " ") { print label }
        print instr_tabulator "MOV" instr_tabulator "BP,CX"
        sub(/[(][Bb][Cc][)],/,"{BP},")
        reset_label()
    }

#### look for "(DE),r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[(][Dd][Ee][)],[^; \t]+([; \t]|$)/)) {
        if (label != " ") { print label }
        print instr_tabulator "MOV" instr_tabulator "BP,DX"
        sub(/[(][Dd][Ee][)],/,"{BP},")
        reset_label()
    }

#### look for "(HL),r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[(][Hh][Ll][)],[^; \t]+([; \t]|$)/)) {
        sub(/[(][Hh][Ll][)],/,"{BX},")
    }

#### look for "(IY...),r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[(][Ii][Yy][^; \t]*[)],[^; \t]+([; \t]|$)/)) {
        sub(/[(][Ii][Yy]/,"{DI")
        sub(/[)],/,"},")
    }

#### look for "(IX...),r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[(][Ii][Xx][^; \t]*[)],[^; \t]+([; \t]|$)/)) {
        sub(/[(][Ii][Xx]/,"{SI")
        sub(/[)],/,"},")
    }

#### look for "BC,r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Bb][Cc],[^; \t]+([; \t]|$)/)) {
        sub(/[Bb][Cc],/,"CX,")
    }

#### look for "DE,r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Dd][Ee],[^; \t]+([; \t]|$)/)) {
        sub(/[Dd][Ee],/,"DX,")
    }

#### look for "HL,r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Hh][Ll],[^; \t]+([; \t]|$)/)) {
        sub(/[Hh][Ll],/,"BX,")
    }

#### look for "IX,r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Ii][Xx],[^; \t]+([; \t]|$)/)) {
        sub(/[Ii][Xx],/,"SI,")
    }

#### look for "IY,r"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Ii][Yy],[^; \t]+([; \t]|$)/)) {
        sub(/[Ii][Yy],/,"DI,")
    }

#### look for "A,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Aa],[^; \t]+([; \t]|$)/)) {
        sub(/[Aa],/,"AL,")
    }

#####  Getting flags register needs data to be stored on AH ####

#### look for "F,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Ff],[^; \t]+([; \t]|$)/)) {
        sub(/[Ff],/,"AH,")
        print instr_tabulator "SAHF"
    }

#### look for "B,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Bb],[^; \t]+([; \t]|$)/)) {
        sub(/[Bb],/,"CH,")
    }

#### look for "C,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Cc],[^; \t]+([; \t]|$)/)) {
        sub(/[Cc],/,"CL,")
    }

#### look for "D,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Dd],[^; \t]+([; \t]|$)/)) {
        sub(/[Dd],/,"DH,")
    }

#### look for "E,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Ee],[^; \t]+([; \t]|$)/)) {
        sub(/[Ee],/,"DL,")
    }

#### look for "H,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Hh],[^; \t]+([; \t]|$)/)) {
        sub(/[Hh],/,"BH,")
    }

#### look for "L,.."
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[Ll],[^; \t]+([; \t]|$)/)) {
        sub(/[Ll],/,"BL,")
    }



############################################
### ...,REG

#### look for "r,(BC)"
    if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[(][Bb][Cc][)]+([; \t]|$)/)) {
        if (label != " ") { print label }
        print instr_tabulator "MOV" instr_tabulator "BP,CX"
        sub(/,[(][Bb][Cc][)]/,",{BP}")
        reset_label()
    }

#### look for "r,(DE)"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[(][Dd][Ee][)]+([; \t]|$)/)) {
        if (label != " ") { print label }
        print instr_tabulator "MOV" instr_tabulator "BP,DX"
        sub(/,[(][Dd][Ee][)]/,",{BP}")
        reset_label()
    }

#### look for "r,(HL)"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[(][Hh][Ll][)]+([; \t]|$)/)) {
        sub(/,[(][Hh][Ll][)]/,",{BX}")
    }

#### look for "r,(IX...)"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[(][Ii][Xx][^; \t]*[)]+([; \t]|$)/)) {
        sub(/,[(][Ii][Xx]/,",{SI")
        sub(/[)]/,"}")
    }

#### look for "r,(IY...)"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[(][Ii][Yy][^; \t]*[)]+([; \t]|$)/)) {
        sub(/,[(][Ii][Yy]/,",{DI")
        sub(/[)]/,"}")
    }

#### look for "r,BC"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Bb][Cc]+([; \t]|$)/)) {
        sub(/,[Bb][Cc]/,",CX")
    }

#### look for "r,DE"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Dd][Ee]+([; \t]|$)/)) {
        sub(/,[Dd][Ee]/,",DX")
    }

#### look for "r,HL"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Hh][Ll]+([; \t]|$)/)) {
        sub(/,[Hh][Ll]/,",BX")
    }

#### look for "r,IX"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Ii][Xx]+([; \t]|$)/)) {
        sub(/,[Ii][Xx]/,",SI")
    }

#### look for "r,IY"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Ii][Yy]+([; \t]|$)/)) {
        sub(/,[Ii][Yy]/,",DI")
    }

#### look for "..,A"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Aa]+([; \t]|$)/)) {
        sub(/,[Aa]/,",AL")
    }

#####  Getting flags register needs data to be stored on AH ####

#### look for "..,F"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Ff]+([; \t]|$)/)) {
        if (label != " ") { print label }
        print instr_tabulator "LAHF"
        sub(/,[Ff]/,",AH")
        reset_label()
    }

#### look for "..,B"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Bb]+([; \t]|$)/)) {
        sub(/,[Bb]/,",CH")
    }

#### look for "..,C"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Cc]+([; \t]|$)/)) {
        sub(/,[Cc]/,",CL")
    }

#### look for "..,D"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Dd]+([; \t]|$)/)) {
        sub(/,[Dd]/,",DH")
    }

#### look for "..,E"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Ee]+([; \t]|$)/)) {
        sub(/,[Ee]/,",DL")
    }

#### look for "..,H"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Hh]+([; \t]|$)/)) {
        sub(/,[Hh]/,",BH")
    }

#### look for "..,L"
    else if (match($0,/^[^; \t]*[ \t]+[^; \t]+[ \t]+[^; \t]+,[Ll]+([; \t]|$)/)) {
        sub(/,[Ll]/,",BL")
    }

############################################################
#### convert remaining round brackets
############################################################
    sub(/[(]/,"{")
    sub(/[)]/,"}")

    return 1;
}


#########################
################################
#########################

function sub_ptr(wkg_str) {
    if (match(wkg_str,/^[(][Hh][Ll][)]$/)) {
            sub(/[(][Hh][Ll][)]/,"{BX}")
            return 1
        }
    else if (match(wkg_str,/^[(][Ii][Xx][)]$/)) {
            sub(/[(][Ii][Xx][)]/,"{SI}")
            return 1
        }
    else if (match(wkg_str,/^[(][Ii][Yy][)]$/)) {
            sub(/[(][Ii][Yy][)]/,"{DI}")
            return 1
        }
    return 0
    }

function sub_bdh(wkg_operand,wkg_str) {

    # ToDo: what about AF ?

    wkg_match = wkg_operand "[ \t]+[Bb][Cc]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "CX")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Dd][Ee]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "DX")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Hh][Ll]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "BX")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Ii][Xx]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "SI")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Ii][Yy]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "DI")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Aa]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "AL")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Bb]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "CH")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Cc]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "CL")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Dd]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "DH")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Ee]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "DL")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Ff]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            # Todo: fix the label stuff for 'F'
            print label
            print instr_tabulator "LAHF"
            sub(wkg_match,wkg_operand instr_tabulator "AH")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Hh]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "BH")
            return
        }
    wkg_match = wkg_operand "[ \t]+[Ll]+([; \t]|$)"
    if (match($0,wkg_match)) {
            wkg_match = wkg_operand "[ \t]+" wkg_str
            sub(wkg_match,wkg_operand instr_tabulator "BL")
            return
        }
}


############ MAIN LOOP ############

##################################################
#### Force label conversion, in case it is alone
##################################################

    (/^[.]+/) {
    	save_label()
    	restore_label()
    }

##############################################
#### redefinition of assembler directives ####
##############################################

############################
#### INCLUDE to %include
############################
    (/^[^;]*+[Ii][Nn][Cc][Ll][Uu][Dd][Ee][ \t]/) {
        sub (/[Ii][Nn][Cc][Ll][Uu][Dd][Ee]/,"%include")
        print $0
        next
    }

############################
#### XLIB to GLOBAL
############################
    (/^[^;]*+[Xx][Ll][Ii][Bb][ \t]/) {
        sub (/[Xx][Ll][Ii][Bb]/,"GLOBAL")
        print $0
        next
    }

# ToDo: force a tiny model in modules, i.e. extern foo:wrt dgroup

############################
#### XREF to EXTERN
############################
    (/^[^;]*+[Xx][Rr][Ee][Ff][ \t]/) {
        sub (/[Xx][Rr][Ee][Ff]/,"EXTERN")
        print $0
        next
    }

############################
#### LIB to EXTERN
############################
    (/^[^;]*+[Ll][Ii][Bb][ \t]/) {
        sub (/[Ll][Ii][Bb]/,"EXTERN")
        print $0
        next
    }

############################
#### DEFC to EQU
############################
    (/^[^;]*+[Dd][Ee][Ff][Cc][ \t]/) {
        sub (/[Dd][Ee][Ff][Cc]/,"")
        sub (/[=]/," EQU ")
        print $0
        next
    }

############################
#### "DEFM"/"DEFB" to "db"
############################
    (/^[^; \t]*[ \t]+([Dd][Ee][Ff][MmBb])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub("'","zpcttz")
        sub(/[Dd][Ee][Ff][MmBb]/,"db")
        sub("zpcttz","'")
        restore_label()
        print $0
        convert_dollar()
        next
    }

############################
#### "DEFW" to "dw"
############################
    (/^[^; \t]*[ \t]+([Dd][Ee][Ff][Ww])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ee][Ff][Ww]/,"dw")
        restore_label()
        print $0
        convert_dollar()
        next
    }

############################
#### "DEFS" to "RESB"
############################
    (/^[^; \t]*[ \t]+([Dd][Ee][Ff][Ss])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ee][Ff][Ss]/,"RESB")
        restore_label()
        print $0
        convert_dollar()
        next
    }

############################
#### "BINARY" to "incbin"
############################
    (/^[^; \t]*[ \t]+([Bb][Ii][Nn][Aa][Rr][Yy])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Bb][Ii][Nn][Aa][Rr][Yy]/,"INCBIN")
        restore_label()
        print $0
        next
    }


################################
#### [I][F] to %if <expression>
################################

# ToDo: manage teh %ifdef directive

    (/^[I][F]+([; \t]|$)/) {
        sub (/[I][F]/,"%if")
        print $0
        next
    }

###############################
#### [E][N][D][I][F] to %endif
###############################
    (/^[E][N][D][I][F]+([; \t]|$)/) {
        sub (/[E][N][D][I][F]/,"%endif")
        print $0
        next
    }

############################
#### [E][L][S][E] to %else
############################
    (/^[E][L][S][E]+([; \t]|$)/) {
        sub (/[E][L][S][E]/,"%else")
        print $0
        next
    }

#####################################
#### Z80 instructions conversion ####
#####################################

###### DI / EI - let's do it first, because DI is also a register,
###############  and we want to avoid confusion

    (/^[^; \t]*[ \t]+([DdEe][Ii])([; \t]|$)/) {
        save_label()
        sub(/[Dd][Ii]/,"CLI")
        sub(/[Ee][Ii]/,"STI")
        restore_label()
        print $0
        next
    }

### Conditional functions are here to make the converter discriminate between
### the 'carry set' condition and the 'C' register name

###### JP/JR cond,..  else no cond
###################################
    (/^[^; \t]*[ \t]+[Jj][PpRr][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[(]/,"{")
        sub(/[)]/,"}")
        sub(/[Jj][PpRr]/,"JMP")
        wkg_str =  get_operand("JMP",3)

        if (match(wkg_str,/^[Nn][Zz]$/)) {
           sub(/JMP/,"JNZ")
        }
        else if (match(wkg_str,/^[Nn][Cc]$/)) {
           sub(/JMP/,"JNC")
        }
        else if (match(wkg_str,/^[Pp][Oo]$/)) {
           sub(/JMP/,"JPO")
        }
        else if (match(wkg_str,/^[Pp][Ee]$/)) {
           sub(/JMP/,"JPE")
        }
        else if (match(wkg_str,/^[Zz]$/)) {
           sub(/JMP/,"JZ")
        }
        else if (match(wkg_str,/^[Cc]$/)) {
           sub(/JMP/,"JC")
        }
        else if (match(wkg_str,/^[Pp]$/)) {
           sub(/JMP/,"JNS")
        }
        else if (match(wkg_str,/^[Mm]$/)) {
           sub(/JMP/,"JS")
        }
        else {
           wkg_str =  get_operand("JMP",3)
           sub_ptr(wkg_str)
           restore_label()
           print $0
           next
        }


        wkg_str = wkg_str ","
        sub(wkg_str,"" )

        wkg_str =  get_operand("JMP",3)
        sub_ptr(wkg_str)
        restore_label()
        print $0
        next
    }

###### CALL cond,..  else no cond
####################################
    (/^[^; \t]*[ \t]+[Cc][Aa][Ll][Ll][ \t]+[^ \t]+([; \t]|$)/) {

        save_label()

        sub(/[(]/,"{")
        sub(/[)]/,"}")
        sub(/[Cc][Aa][Ll][Ll]/,"CALL")
        wkg_str =  get_operand("CALL",4)

        if (match(wkg_str,/^[Nn][Zz]$/)) {
           make_new_label()
           print instr_tabulator "JZ" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Nn][Cc]$/)) {
           make_new_label()
           print instr_tabulator "JC" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp][Oo]$/)) {
           make_new_label()
           print instr_tabulator "JPE" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp][Ee]$/)) {
           make_new_label()
           print instr_tabulator "JPO" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Zz]$/)) {
           make_new_label()
           print instr_tabulator "JNZ" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Cc]$/)) {
           make_new_label()
           print instr_tabulator "JNC" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp]$/)) {
           make_new_label()
           print instr_tabulator "JS" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Mm]$/)) {
           make_new_label()
           print instr_tabulator "JNS" instr_tabulator new_label
        }
        else {
           wkg_str =  get_operand("CALL",3)
           sub_ptr(wkg_str)
           restore_label()
           print $0
           next
        }

        wkg_str = wkg_str ","
        sub(wkg_str,"" )

        wkg_str =  get_operand("CALL",3)
        sub_ptr(wkg_str)
        restore_label()
        print $0
        print new_label ":"
        next
    }

###### RET cond,..  else no cond
####################################
    (/^[^; \t]*[ \t]+[Rr][Ee][Tt][ \t]+[^ \t]+([; \t]|$)/) {

        save_label()

        sub(/[Rr][Ee][Tt]/,"RET")
        wkg_str =  get_operand("RET",3)

        if (match(wkg_str,/^[Nn][Zz]$/)) {
           make_new_label()
           print instr_tabulator "JZ" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Nn][Cc]$/)) {
           make_new_label()
           print instr_tabulator "JC" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp][Oo]$/)) {
           make_new_label()
           print instr_tabulator "JPE" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp][Ee]$/)) {
           make_new_label()
           print instr_tabulator "JPO" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Zz]$/)) {
           make_new_label()
           print instr_tabulator "JNZ" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Cc]$/)) {
           make_new_label()
           print instr_tabulator "JNC" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Pp]$/)) {
           make_new_label()
           print instr_tabulator "JS" instr_tabulator new_label
        }
        else if (match(wkg_str,/^[Mm]$/)) {
           make_new_label()
           print instr_tabulator "JNS" instr_tabulator new_label
        }
        else {
           print "; Conversion Error: return condition not understood"
           restore_label()
           print $0
           next
        }

        sub(wkg_str,"" )

        sub(/[Rr][Ee][Tt]/,"RET  ;")
        restore_label()
        print $0
        print new_label ":"
        next
    }

###### RET
############################
    (/^[^; \t]*[ \t]+([[Rr][Ee][Tt])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Ee][Tt]/,"RET")
        restore_label()
        print $0
        next
    }


####################################################
## Single byte registers in two arguments functions
####################################################

## ## ## ##


###### LDIR
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Ii][Rr])([; \t]|$)/) {
        wkg_match="[Ll][Dd][Ii][Rr]"
        sub(wkg_match,"XCHG" instr_tabulator "BX,SI  ; Was LDIR - ")
        print $0
        print instr_tabulator "XCHG" instr_tabulator "DX,DI"
        # CX is the counter, already..
        print instr_tabulator "STD"
        print instr_tabulator "REP" instr_tabulator "MOVSB"
        print instr_tabulator "XCHG" instr_tabulator "BX,SI"
        print instr_tabulator "XCHG" instr_tabulator "DX,DI"
        
        next
    }

###### LDDR
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Dd][Rr])([; \t]|$)/) {
        wkg_match="[Ll][Dd][Dd][Rr]"
        sub(wkg_match,"XCHG" instr_tabulator "BX,SI  ; Was LDDR - ")
        print $0
        print instr_tabulator "XCHG" instr_tabulator "DX,DI"
        # CX is the counter, already..
        print instr_tabulator "CLD"
        print instr_tabulator "REP" instr_tabulator "MOVSB"
        print instr_tabulator "XCHG" instr_tabulator "BX,SI"
        print instr_tabulator "XCHG" instr_tabulator "DX,DI"
        
        next
    }

###### LDI
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Ii])([; \t]|$)/) {
        wkg_match="[Ll][Dd][Ii]"
        sub(wkg_match,"MOV" instr_tabulator "BP,DX  ; Was LDI - ")
        print $0
        print instr_tabulator "MOV" instr_tabulator "AH,[BX]"
        print instr_tabulator "MOV" instr_tabulator "[BP],AH"
        print instr_tabulator "INC" instr_tabulator "BX"
        print instr_tabulator "INC" instr_tabulator "DX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        next
    }

###### LDD
############################
    (/^[^; \t]*[ \t]+([Ll][Dd][Dd])([; \t]|$)/) {
        wkg_match="[Ll][Dd][Dd]"
        sub(wkg_match,"MOV" instr_tabulator "BP,DX  ; Was LDD - ")
        print $0
        print instr_tabulator "MOV" instr_tabulator "AH,[BX]"
        print instr_tabulator "MOV" instr_tabulator "[BP],AH"
        print instr_tabulator "DEC" instr_tabulator "BX"
        print instr_tabulator "DEC" instr_tabulator "DX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        next
    }

#### LD
############################
    (/^[^; \t]*[ \t]+([Ll][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        wkg_match="[Ll][Dd]"
        wkg_operand="MOV"
        wkg_oplen=3
        convert_line_comma(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### EX DE,HL
############################
    (/^[^; \t]*[ \t]+([Ee][Xx])[ \t]+([HhDd][LlEe][,][DdHh][EeLl])+([; \t]|$)/) {
        wkg_match="[Ee][Xx]"
        wkg_operand="XCHG"
        wkg_oplen=4
        convert_line_comma(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### EX - more exchange instructions
########################################
    (/^[^; \t]*[ \t]+([Ee][Xx])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Ee][Xx]/,"EX")
        wkg_str =  get_operand("EX",2)

        if (match(wkg_str,/^[Aa][Ff]$/)) {
            ## EX AF,AF
            if (label != " ") { print label }
            reset_label()
            print instr_tabulator "LAHF"
            if (INSTR486 = 1) {
                sub(/[Aa][Ff],[Aa][Ff]/,"EAX")
                sub(/EX/,"BSWAP")
            } else {
                # ToDo: check the best way for non-486 CPU
                sub(/[Aa][Ff],[Aa][Ff]/,"ES,AX")
                sub(/[Ee][Xx]/,"XCHG")
            }
            print $0
            print instr_tabulator "SAHF"
            next
        } else {
            ## EX (SP),HL
            # ToDo: Test this one
            save_label()
            if (label != " ") { print label }
            reset_label()
            sub(/EX/,"POP"instr_tabulator"BP  ; Was: EX")
            restore_label()
            print $0
            print instr_tabulator "PUSH" instr_tabulator "BX"
            print instr_tabulator "MOV" instr_tabulator "BX,BP"
            next
        }

        restore_label()
        print $0
        next
    }


#### Simple replacements (no operand)
########################################

###### DJNZ
###################################
    (/^[^; \t]*[ \t]+[Dd][Jj][Nn][Zz][ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        wkg_str =  get_operand("[Dd][Jj][Nn][Zz]",3)
        if (label != " ") { print label }
        reset_label()
        print instr_tabulator"DEC"instr_tabulator"CH"
        sub(/[Dd][Jj][Nn][Zz]/,"JNZ")
        # restore_label has to do the final conversions
        restore_label()
        print $0
        next
        }

###### EXX
############################
    (/^[^; \t]*[ \t]+([Ee][Xx][Xx])([; \t]|$)/) {
        save_label()
        if (INSTR486 = 1) {
            sub(/[Ee][Xx][Xx]/,"BSWAP"instr_tabulator"EBX")
        }
        else {
            sub(/[Ee][Xx][Xx]/,"EXX"instr_tabulator"8086mode")
        }
        restore_label()
        print $0
        if (INSTR486 = 1) {
            print instr_tabulator "BSWAP" instr_tabulator "ECX"
            print instr_tabulator "BSWAP" instr_tabulator "EDX"
            print instr_tabulator "LAHF"
            print instr_tabulator "BSWAP" instr_tabulator "EAX"
            print instr_tabulator "SAHF"
        }
        else {
            # Todo: do something for non-486 CPU
            sub(/[Ee][Xx][Xx]/,"EXX"instr_tabulator"---")
        }
        next
    }


###### DAA
############################
    (/^[^; \t]*[ \t]+([Dd][Aa][Aa])/) {
        save_label()
        sub(/[Dd][Aa][Aa]/,"DAA")
        restore_label()
        print $0
        next
    }


###### HALT
############################
    (/^[^; \t]*[ \t]+([Hh][Aa][Ll][Tt])/) {
        save_label()
        sub(/[Hh][Aa][Ll][Tt]/,"HLT")
        restore_label()
        print $0
        next
    }

###### CPL
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Ll])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Pp][Ll]/,"NOT"instr_tabulator"AL")
        restore_label()
        print $0
        next
    }

###### SCF
############################
    (/^[^; \t]*[ \t]+([Ss][Cc][Ff])([; \t]|$)/) {
        save_label()
        sub(/[Ss][Cc][Fff]/,"STC")
        restore_label()
        print $0
        next
    }

###### CCF
############################
    (/^[^; \t]*[ \t]+([Cc][Cc][Ff])([; \t]|$)/) {
        save_label()
        sub(/[Cc][Cc][Ff]/,"CMC")
        restore_label()
        print $0
        next
    }

###### NEG
############################
    (/^[^; \t]*[ \t]+([Nn][Ee][Gg])([; \t]|$)/) {
        save_label()
        sub(/[Nn][Ee][Gg]/,"NEG"instr_tabulator"AL")
        restore_label()
        print $0
        next
    }

###### RLCA
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Cc][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Ll][Cc][Aa]/,"ROL"instr_tabulator"AL,1")
        restore_label()
        print $0

        next
    }

###### RRCA
############################
    (/^[^; \t]*[ \t]+([Rr][Rr][Cc][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Rr][Cc][Aa]/,"ROR"instr_tabulator"AL,1")
        restore_label()
        print $0
        next
    }

###### RLA
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Ll][Aa]/,"RCL"instr_tabulator"AL,1")
        restore_label()
        print $0
        next
    }

###### RRA
############################
    (/^[^; \t]*[ \t]+([Rr][Rr][Aa])([; \t]|$)/) {
        save_label()
        sub(/[Rr][Rr][Aa]/,"RCR"instr_tabulator"AL,1")
        restore_label()
        print $0
        next
    }

###### RLD
############################
    # ToDo: implement RLD


###### RLC o
############################
    (/^[^; \t]*[ \t]+([Rr][Ll][Cc])([; \t]|$)/) {
        wkg_match="[Rr][Ll][Cc]"
        wkg_operand="ROL"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

###### RRC o
############################
    (/^[^; \t]*[ \t]+([Rr][Rr][Cc])([; \t]|$)/) {
        wkg_match="[Rr][Rr][Cc]"
        wkg_operand="ROR"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

# What is the difference between SAL and SHL ?

###### SLA o
############################
    (/^[^; \t]*[ \t]+([Ss][Ll][Aa])([; \t]|$)/) {
        wkg_match="[Ss][Ll][Aa]"
        wkg_operand="SHL"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

###### SRL o
############################
    (/^[^; \t]*[ \t]+([Ss][Rr][Ll])([; \t]|$)/) {
        wkg_match="[Ss][Rr][Ll]"
        wkg_operand="SHR"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

###### RL o
############################
    (/^[^; \t]*[ \t]+([Rr][Ll])([; \t]|$)/) {
        wkg_match="[Rr][Ll]"
        wkg_operand="RCL"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

###### RR o
############################
    (/^[^; \t]*[ \t]+([Rr][Rr])([; \t]|$)/) {
        wkg_match="[Rr][Rr]"
        wkg_operand="RCR"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        comma_one(wkg_operand, wkg_oplen)
        print $0
        next
    }

###### ADD
############################
    (/^[^; \t]*[ \t]+([Aa][Dd][Dd])[ \t]+[^ \t]+([; \t]|$)/) {
        wkg_match="[Aa][Dd][Dd]"
        wkg_operand="ADD"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### ADC
############################
    (/^[^; \t]*[ \t]+([Aa][Dd][Cc])[ \t]+[^ \t]+([; \t]|$)/) {
        wkg_match="[Aa][Dd][Cc]"
        wkg_operand="ADC"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### SUB
############################
    (/^[^; \t]*[ \t]+([Ss][Uu][Bb])[ \t]+[^ \t]+([; \t]|$)/) {
        wkg_match="[Ss][Uu][Bb]"
        wkg_operand="SUB"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### SBC
############################
    (/^[^; \t]*[ \t]+([Ss][Bb][Cc])[ \t]+[^ \t]+([; \t]|$)/) {
        wkg_match="[Ss][Bb][Cc]"
        wkg_operand="SBB"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### INC
############################

    (/^[^; \t]*[ \t]+([Ii][Nn][Cc])[ \t]+[^ \t]+([; \t]|$)/) {

        sub(/[Ii][Nn][Cc]/,"INC")
        wkg_str =  get_operand("INC",3)
        if (match(wkg_str,/^[AaBbDdHhIi][FfCcEeLlXxYy]$/)) {
            save_label()
            if (label != " ") { print label }
            reset_label()
            print instr_tabulator "LAHF"

            wkg_match="[Ii][Nn][Cc]"
            wkg_operand="INC"
            wkg_oplen=3

            convert_line(wkg_operand, wkg_match, wkg_oplen)
            print $0

            print instr_tabulator "SAHF"
            next
        }
        
	wkg_match="[Ii][Nn][Cc]"
	wkg_operand="INC"
	wkg_oplen=3
	
	convert_line(wkg_operand, wkg_match, wkg_oplen)
	print $0
	next

    }

###### DEC
############################

    (/^[^; \t]*[ \t]+([Dd][Ee][Cc])[ \t]+[^ \t]+([; \t]|$)/) {

        sub(/[Dd][Ee][Cc]/,"DEC")
        wkg_str =  get_operand("DEC",3)
        if (match(wkg_str,/^[AaBbDdHhIi][FfCcEeLlXxYy]$/)) {
            save_label()
            if (label != " ") { print label }
            reset_label()
            print instr_tabulator "LAHF"

            wkg_match="[Dd][Ee][Cc]"
            wkg_operand="DEC"
            wkg_oplen=3

            convert_line(wkg_operand, wkg_match, wkg_oplen)
            print $0

            print instr_tabulator "SAHF"
            next
        }
        
	wkg_match="[Dd][Ee][Cc]"
	wkg_operand="DEC"
	wkg_oplen=3
	
	convert_line(wkg_operand, wkg_match, wkg_oplen)
	print $0
	next

    }

###### AND
############################
    (/^[^; \t]*[ \t]+([Aa][Nn][Dd])[ \t]/) {
        wkg_match="[Aa][Nn][Dd]"
        wkg_operand="AND"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### XOR
############################
    (/^[^; \t]*[ \t]+([Xx][Oo][Rr])[ \t]/) {
        wkg_match="[Xx][Oo][Rr]"
        wkg_operand="XOR"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### OR
############################
    (/^[^; \t]*[ \t]+([Oo][Rr])[ \t]/) {
        wkg_match="[Oo][Rr]"
        wkg_operand="OR"
        wkg_oplen=2
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### CPIR
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Ii][Rr])([; \t]|$)/) {
        wkg_match="[Cc][Pp][Ii][Rr]"
        make_new_label()
        another_label=new_label
        print another_label ":"
        sub(wkg_match,"CMP" instr_tabulator "AL,[BX]  ; Was CPIR - ")
        print $0
        make_new_label()
        print instr_tabulator "JZ" instr_tabulator new_label
        print instr_tabulator "INC" instr_tabulator "BX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        print instr_tabulator "JNZ" instr_tabulator another_label
        print new_label ":"
        next
    }

###### CPDR
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Dd][Rr])([; \t]|$)/) {
        wkg_match="[Cc][Pp][Dd][Rr]"
        make_new_label()
        another_label=new_label
        print another_label ":"
        sub(wkg_match,"CMP" instr_tabulator "AL,[BX]  ; Was CPDR - ")
        print $0
        make_new_label()
        print instr_tabulator "JZ" instr_tabulator new_label
        print instr_tabulator "DEC" instr_tabulator "BX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        print instr_tabulator "JNZ" instr_tabulator another_label
        print new_label ":"
        next
    }

###### CPI
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Ii])([; \t]|$)/) {
        wkg_match="[Cc][Pp][Ii]"
        save_label()
        sub(wkg_match,"CMP" instr_tabulator "AL,[BX]  ; Was CPI - ")
        restore_label()
        print $0
        make_new_label()
        print instr_tabulator "JZ" instr_tabulator new_label
        print instr_tabulator "INC" instr_tabulator "BX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        print new_label ":"
        next
    }

###### CPD
############################
    (/^[^; \t]*[ \t]+([Cc][Pp][Dd])([; \t]|$)/) {
        wkg_match="[Cc][Pp][Dd]"
        save_label()
        sub(wkg_match,"CMP" instr_tabulator "AL,[BX]  ; Was CPD - ")
        restore_label()
        print $0
        make_new_label()
        print instr_tabulator "JZ" instr_tabulator new_label
        print instr_tabulator "DEC" instr_tabulator "BX"
        print instr_tabulator "DEC" instr_tabulator "CX"
        print new_label ":"
        next
    }

###### CP
############################
    (/^[^; \t]*[ \t]+([Cc][Pp])[ \t]/) {
        wkg_match="[Cc][Pp]"
        wkg_operand="CMP"
        wkg_oplen=3
        convert_line_al(wkg_operand, wkg_match, wkg_oplen)
        print $0
        next
    }

###### RST - restart calls
############################
    (/^[^; \t]*[ \t]+([Rr][Ss][Tt])[ \t]/) {

        save_label()

        wkg_str =  get_operand("[Rr][Ss][Tt]",4)

        sub(/[Rr][Ss][Tt]/,temp_xyz)
        #sub(wkg_str,"I_" wkg_str )
        sub(temp_xyz,"INT")

        restore_label()
        print $0
        next
    }

###### PUSH BC/DE/HL/AF
############################

    (/^[^; \t]*[ \t]+([Pp][Uu][Ss][Hh])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Pp][Uu][Ss][Hh]/,"PUSH")
        wkg_str =  get_operand("PUSH",4)
        if (match(wkg_str,/^[Aa][Ff]$/)) {
            if (label != " ") { print label }
            reset_label()
            print instr_tabulator "LAHF"
            sub(/[Aa][Ff]/,"AX")
        }
        else {
            wkg_operand = "PUSH"
            wkg_str = get_operand_block("PUSH",4)
            sub_bdh(wkg_operand,wkg_str)
        }

        restore_label()
        print $0
        next
    }

###### POP BC/DE/HL/AF
############################

    (/^[^; \t]*[ \t]+([Pp][Oo][Pp])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()
        sub(/[Pp][Oo][Pp]/,"POP")
        wkg_str =  get_operand("POP",3)
        if (match(wkg_str,/^[Aa][Ff]$/)) {
            sub(/[Aa][Ff]/,"AX")
            restore_label()
            print $0
            print instr_tabulator "SAHF"
        }
        else {
            wkg_operand = "POP"
            wkg_str = get_operand_block("POP",3)
            sub_bdh(wkg_operand,wkg_str)
            restore_label()
            print $0
        }
        next
    }

### OUT byte
############################
    (/^[^; \t]*[ \t]+([Oo][Uu][Tt])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Oo][Uu][Tt]/,"OUT")
        sub_reg_comma()

        restore_label()
        print $0
        next
    }

### IN byte
############################
    (/^[^; \t]*[ \t]+([Ii][Nn])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Ii][Nn]/,"IN")
        sub_reg_comma()

        restore_label()
        print $0
        next
    }

### BIT ...
############################
    (/^[^; \t]*[ \t]+([Bb][Ii][Tt])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Bb][Ii][Tt]/,"TEST")

        sub_reg_comma()

        wkg_str =  get_operand("TEST",4)
        wkg_exponent = 2^wkg_str
        wkg_str = wkg_str ","
        sub(wkg_str,"")

        wkg_str =  get_operand("TEST",4)
        sub(wkg_str,wkg_str "," wkg_exponent "  ; Was a 'bit test' command - ")

        restore_label()
        print $0
        next
    }

### SET ...
############################
    (/^[^; \t]*[ \t]+([Ss][Ee][Tt])[ \t]+[^ \t]+([; \t]|$)/) {
        save_label()

        sub(/[Ss][Ee][Tt]/,"OR")

        sub_reg_comma()

        wkg_str =  get_operand("OR",2)
        wkg_exponent = 2^wkg_str
        wkg_str = wkg_str ","
        sub(wkg_str,"")

        wkg_str =  get_operand("OR",2)
        sub(wkg_str,wkg_str "," wkg_exponent "  ; Was a 'bit set' command - ")

        restore_label()
        print $0
        next
    }



###### Default
############################
(/^.*/) {
    print $0
    next
}
