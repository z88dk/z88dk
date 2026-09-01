GAMES_NEWLIBGLOBS := "sound/bit/z80/asm_bit_beepfx/*.asm"
GAMES_NEWLIBGLOBS_ex := sound/bit/z80/asm_bit_beepfx/*.asm


GAMES_NEWLIB_TARGETS := classic/games/obj/newlib-z80-classic-games \
	classic/games/obj/newlib-z80n-classic-games \
	classic/games/obj/newlib-z80n-classic-games \
	classic/games/obj/newlib-r2ka-classic-games \
	classic/games/obj/newlib-ixiy-classic-games \
	classic/games/obj/newlib-8080-classic-games \
	classic/games/obj/newlib-8085-classic-games \
	classic/games/obj/newlib-gbz80-classic-games \
	classic/games/obj/newlib-z180-classic-games \
	classic/games/obj/newlib-ez80_z80-classic-games

# Target library sub-builds. Keep the stamp separate from the objects while
# the existing .lst files still use obj/${TARGET} paths.
GAMES_STAMP_SOURCES := $(shell find classic/games -type f \( -name '*.asm' -o -name '*.c' -o -name 'Makefile' \))

define games_stamp
classic/games/obj/.stamp-$(1): $(GAMES_STAMP_SOURCES)
	@mkdir -p $$(dir $$@)
	$(MAKE) -C classic/games TARGET=$(1)
	@touch $$@
endef

define games_stamp_args
classic/games/obj/.stamp-$(1): $(GAMES_STAMP_SOURCES)
	@mkdir -p $$(dir $$@)
	$(MAKE) -C classic/games $(2)
	@touch $$@
endef

$(eval $(call games_stamp,z88))
$(eval $(call games_stamp,zx))
$(eval $(call games_stamp,zxn))
$(eval $(call games_stamp,ts2068))
$(eval $(call games_stamp_args,pacman,TARGET=pacman SUBSET=joystick.asm))
$(eval $(call games_stamp_args,p2000,TARGET=p2000))
$(eval $(call games_stamp_args,pc6001,TARGET=pc6001))
$(eval $(call games_stamp_args,pc88,TARGET=pc88))
$(eval $(call games_stamp_args,pps,TARGET=pps))
$(eval $(call games_stamp_args,cpm-apple2,TARGET=cpm SUBTYPE=apple2))
$(eval $(call games_stamp_args,cpm-px4,TARGET=cpm SUBTYPE=px4))
$(eval $(call games_stamp_args,cpm-px8,TARGET=cpm SUBTYPE=px8))
$(eval $(call games_stamp_args,cpm-v1050,TARGET=cpm SUBTYPE=v1050))
$(eval $(call games_stamp_args,vz,TARGET=vz))
$(eval $(call games_stamp_args,zx80,TARGET=zx80))
$(eval $(call games_stamp_args,zx81,TARGET=zx81))
$(eval $(call games_stamp_args,ti82,TARGET=ti82))
$(eval $(call games_stamp_args,ti83,TARGET=ti83))
$(eval $(call games_stamp_args,ti83p,TARGET=ti83p))
$(eval $(call games_stamp_args,ti85,TARGET=ti85))
$(eval $(call games_stamp_args,ti86,TARGET=ti86))
$(eval $(call games_stamp_args,oz,TARGET=oz))
$(eval $(call games_stamp_args,cpm-attache,TARGET=cpm SUBTYPE=attache))
$(eval $(call games_stamp_args,cpm-bondwell,TARGET=cpm SUBTYPE=bondwell))
$(eval $(call games_stamp_args,cpm-bondwell2,TARGET=cpm SUBTYPE=bondwell2 TARGET_CFLAGS="-subtype=bondwell2"))
$(eval $(call games_stamp_args,cpm-rc700,TARGET=cpm SUBTYPE=rc700))
$(eval $(call games_stamp_args,cpm-tim011,TARGET=cpm SUBTYPE=tim011 TARGET_CFLAGS="-subtype=tim011"))
$(eval $(call games_stamp_args,cpm-x820ii,TARGET=cpm SUBTYPE=x820ii))
$(eval $(call games_stamp_args,srr,TARGET=srr))
$(eval $(call games_stamp_args,mz,TARGET=mz))
$(eval $(call games_stamp_args,cpm-mz2500,TARGET=cpm SUBTYPE=mz2500))
$(eval $(call games_stamp_args,abc80,TARGET=abc80 SUBSET=joystick.asm))
$(eval $(call games_stamp_args,abc800,TARGET=abc800 SUBSET=joystick.asm))
$(eval $(call games_stamp_args,ace,TARGET=ace))
$(eval $(call games_stamp_args,aquarius,TARGET=aquarius))
$(eval $(call games_stamp_args,cpm-aussie,TARGET=cpm SUBTYPE=aussie))
$(eval $(call games_stamp_args,bee,TARGET=bee))
$(eval $(call games_stamp_args,svi,TARGET=svi))
$(eval $(call games_stamp_args,msx,TARGET=msx))
$(eval $(call games_stamp_args,mtx,TARGET=mtx))
$(eval $(call games_stamp_args,tvc,TARGET=tvc))
$(eval $(call games_stamp_args,enterprise,TARGET=enterprise))
$(eval $(call games_stamp_args,smc777,TARGET=smc777))
$(eval $(call games_stamp_args,cpm-smc777,TARGET=cpm SUBTYPE=smc777 TARGET_CFLAGS=-subtype=smc777))
$(eval $(call games_stamp_args,cpm-bic,TARGET=cpm SUBTYPE=bic))
$(eval $(call games_stamp_args,cpm-coleco,TARGET=cpm SUBTYPE=coleco))
$(eval $(call games_stamp_args,m5,TARGET=m5))
$(eval $(call games_stamp_args,cpm-mbc200,TARGET=cpm SUBTYPE=mbc200))
$(eval $(call games_stamp_args,mc1000,TARGET=mc1000))
$(eval $(call games_stamp_args,phc25,TARGET=phc25))
$(eval $(call games_stamp_args,nascom,TARGET=nascom))
$(eval $(call games_stamp_args,z1013,TARGET=z1013))
$(eval $(call games_stamp_args,z9001,TARGET=z9001))
$(eval $(call games_stamp_args,kc,TARGET=kc))
$(eval $(call games_stamp_args,hgmc,TARGET=hgmc))
$(eval $(call games_stamp_args,primo,TARGET=primo))
$(eval $(call games_stamp_args,rx78,TARGET=rx78))
$(eval $(call games_stamp_args,cpm-fp1100,TARGET=cpm SUBTYPE=fp1100))
$(eval $(call games_stamp_args,z80tvgame,TARGET=z80tvgame))
$(eval $(call games_stamp_args,multi8,TARGET=multi8))
$(eval $(call games_stamp_args,pasopia7,TARGET=pasopia7))
$(eval $(call games_stamp_args,laser500,TARGET=laser500))
$(eval $(call games_stamp_args,super80,TARGET=super80))
$(eval $(call games_stamp_args,alphatro,TARGET=alphatro))
$(eval $(call games_stamp_args,spc1000,TARGET=spc1000))
$(eval $(call games_stamp_args,pv1000,TARGET=pv1000))
$(eval $(call games_stamp_args,pv2000,TARGET=pv2000))
$(eval $(call games_stamp_args,myvision,TARGET=myvision))
$(eval $(call games_stamp_args,sv8000,TARGET=sv8000))
$(eval $(call games_stamp_args,coleco,TARGET=coleco))
$(eval $(call games_stamp_args,cpm-bit90,TARGET=coleco SUBTYPE=bit90 TARGET_CFLAGS=-subtype=bit90))
$(eval $(call games_stamp_args,pencil2,TARGET=pencil2))
$(eval $(call games_stamp_args,lm80c,TARGET=lm80c))
$(eval $(call games_stamp_args,nabu,TARGET=nabu))
$(eval $(call games_stamp_args,cpm-z80retro,TARGET=cpm SUBTYPE=z80retro))
$(eval $(call games_stamp_args,c128,TARGET=c128))
$(eval $(call games_stamp_args,cpm-pcw,TARGET=cpm SUBTYPE=pcw))
$(eval $(call games_stamp_args,newbrain,TARGET=newbrain))
$(eval $(call games_stamp_args,cpm-northstar,TARGET=cpm SUBTYPE=northstar))
$(eval $(call games_stamp_args,cpm-tiki100,TARGET=cpm SUBTYPE=tiki100))
$(eval $(call games_stamp_args,gal,TARGET=gal))
$(eval $(call games_stamp_args,g800-g815,TARGET=g800 SUBTYPE=g815))
$(eval $(call games_stamp_args,g800-e200,TARGET=g800 SUBTYPE=e200))
$(eval $(call games_stamp_args,g800-g850,TARGET=g800 SUBTYPE=g850))
$(eval $(call games_stamp_args,lynx,TARGET=lynx))
$(eval $(call games_stamp_args,sms,TARGET=sms))
$(eval $(call games_stamp_args,sc3000,TARGET=sc3000))
$(eval $(call games_stamp_args,gb,TARGET=gb))
$(eval $(call games_stamp_args,hector1,TARGET=hector SUBTYPE=hector1))
$(eval $(call games_stamp_args,hectorhr,TARGET=hector SUBTYPE=hectorhr))
$(eval $(call games_stamp_args,cpm-gemini,TARGET=cpm SUBTYPE=gemini))
$(eval $(call games_stamp_args,sam,TARGET=sam))
$(eval $(call games_stamp_args,cpm-einstein,TARGET=cpm SUBTYPE=einstein))
$(eval $(call games_stamp_args,excali64,TARGET=excali64))
$(eval $(call games_stamp_args,alphatp2,TARGET=alphatp2))
$(eval $(call games_stamp_args,gl,TARGET=gl))
$(eval $(call games_stamp_args,gl6000,TARGET=gl SUBTYPE=gl6000 TARGET_CFLAGS=-clib=gl6000sl))
$(eval $(call games_stamp_args,nc,TARGET=nc))
$(eval $(call games_stamp_args,nc100,TARGET=nc SUBTYPE=nc100))
$(eval $(call games_stamp_args,nc200,TARGET=nc SUBTYPE=nc200))
$(eval $(call games_stamp_args,zcn,TARGET=nc SUBTYPE=zcn))
$(eval $(call games_stamp_args,cpc,TARGET=cpc SUBSET=joystick.asm))
$(eval $(call games_stamp_args,trs80,TARGET=trs80))
$(eval $(call games_stamp_args,x07,TARGET=x07))
$(eval $(call games_stamp_args,x1,TARGET=x1))
$(eval $(call games_stamp_args,vg5k,TARGET=vg5k))
$(eval $(call games_stamp_args,sos,TARGET=sos))
$(eval $(call games_stamp_args,osca,TARGET=osca))
$(eval $(call games_stamp_args,pmd85,TARGET=pmd85))
$(eval $(call games_stamp_args,mikro80,TARGET=mikro80))
$(eval $(call games_stamp_args,m100,TARGET=m100))
$(eval $(call games_stamp_args,vector06c,TARGET=vector06c))
$(eval $(call games_stamp_args,lviv,TARGET=lviv))
$(eval $(call games_stamp_args,sol20,TARGET=sol20))
$(eval $(call games_stamp_args,agon,TARGET=agon))
$(eval $(call games_stamp_args,ondra,TARGET=ondra))
$(eval $(call games_stamp_args,homelab,TARGET=homelab))
$(eval $(call games_stamp_args,homelab2,TARGET=homelab2))
$(eval $(call games_stamp_args,krokha,TARGET=krokha))
$(eval $(call games_stamp_args,cpm-nanos,TARGET=cpm SUBTYPE=nanos))

OBJS += $(GAMES_NEWLIB_TARGETS)
CLEAN += games-clean

games: $(GAMES_NEWLIB_TARGETS)

.PHONY: games games-clean

$(eval $(call buildnew,classic/games,z80,-mz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,r2ka,-mr2ka,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,z80n,-mz80n,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,ixiy,-IXIY,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,8080,-m8080,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,8085,-m8085,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,gbz80,-mgbz80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,z180,-mz180,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,classic/games,ez80_z80,-mez80_z80,$(GAMES_NEWLIBGLOBS),$(GAMES_NEWLIBGLOBS_ex)))

games-clean: 
	$(RM) -fr classic/games/obj
