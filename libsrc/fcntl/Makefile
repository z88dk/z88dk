# $Id: Makefile,v 1.17 2014-01-14 07:48:40 stefano Exp $

lcpc:
	cd cpc ; $(MAKE) ; cd ..

lz88:
	cd z88 ; $(MAKE) z88_fcntl ; cd ..

lzx:	
	cd spectrum ; $(MAKE) ; cd ..
	cd dummy    ; $(MAKE) ; cd ..

losca:	
	cd osca ; $(MAKE) ; cd ..

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
	cd cpm ; $(MAKE) clean ; cd ..
	cd dummy ; $(MAKE) clean ; cd ..
	cd gen_rnd ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
	cd newbrain ; $(MAKE) clean ; cd ..
	cd sprinter ; $(MAKE) clean ; cd ..
	cd z88 ; $(MAKE) clean ; cd ..
	cd zxvgs ; $(MAKE) clean ; cd ..
	cd cpc ; $(MAKE) clean ; cd ..
	cd osca ; $(MAKE) clean ; cd ..
	cd sos ; $(MAKE) clean ; cd ..
