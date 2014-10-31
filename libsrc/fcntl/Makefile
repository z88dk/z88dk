# $Id: Makefile,v 1.20 2014-10-31 07:41:45 stefano Exp $

lcpc:
	cd cpc ; $(MAKE) ; cd ..

lz88:
	cd z88 ; $(MAKE) z88_fcntl ; cd ..

lzx:	
	cd spectrum ; $(MAKE) ; cd ..
	cd dummy    ; $(MAKE) ; cd ..

losca:	
	cd osca ; $(MAKE) ; cd ..

lnc:
	cd nc100 ; $(MAKE) nc_fcntl ; cd ..

lnewbrain:
	@echo ''
	@echo '---> Building NewBrain File library <---'
	@echo ''
	cd newbrain ; $(MAKE) ; cd ..

lcpm:
	@echo ''
	@echo '---> Building CP/M File library <---'
	@echo ''
	cd cpm ; $(MAKE) ; cd ..

lpps:
	@echo ''
	@echo '---> Building P.P.Sprinter File library <---'
	@echo ''
	cd sprinter ; $(MAKE) ; cd ..

lgendos:
	@echo ''
	@echo '---> Generic Random Access File library <---'
	@echo ''
	cd gen_rnd ; $(MAKE) ; cd ..

lzxvgs:
	cd zxvgs ; $(MAKE) ; cd ..

lcpcold:
	cd cpc ; $(MAKE) ; cd ..
	cd dummy ; $(MAKE) ; cd ..

clean:
	$(MAKE) -C cpc clean
	$(MAKE) -C dummy clean
	$(MAKE) -C gen_rnd clean
	$(MAKE) -C spectrum clean
	$(MAKE) -C nc100 clean
	$(MAKE) -C newbrain clean
	$(MAKE) -C sprinter clean
	$(MAKE) -C z88 clean
	$(MAKE) -C zxvgs clean
	$(MAKE) -C cpm clean
	$(MAKE) -C osca clean
	#$(MAKE) -C sos clean
