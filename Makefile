currentRelease = 0.0
nextRelease = 0.1
gpgkey=47CBC05C

src:
	git clone https://github.com/ffrouin/suspicious
	mv suspicious suspicious_0.0

all: release-check

update: release-new orig-pkg release-src release-bin release-ppa

release-new:
	@mv suspicious_$(currentRelease) suspicious_$(nextRelease)
	@cd suspicious_$(nextRelease) && dch -i
	@tar cjvf suspicious_$(nextRelease).tar.bz2 suspicious_$(nextRelease)
	@cd suspicious_$(nextRelease)/ && make

clean:
	@cd suspicious_$(nextRelease) && make clean
	@rm suspicious_$(nextRelease)-1_*
	@rm *.orig.tar.*

release-check:

orig-pkg:
	tar czvf suspicious_$(nextRelease).orig.tar.gz suspicious_$(nextRelease)

release-src:
	cd suspicious_$(nextRelease) && debuild -S -sa -k$(gpgkey)

release-update:
	cd suspicious_$(nextRelease) && debuild -S -sd -k$(gpgkey)

release-all:
	cd suspicious_$(nextRelease) && debuild -i -b -us -uc

