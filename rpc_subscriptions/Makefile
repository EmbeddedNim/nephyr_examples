
ifdef SENSOR_TYPE 
NIM_FLAGS += -d:${SENSOR_TYPE}
endif

config: 
	west build -p always -b ${BOARD} -d build_${BOARD} --cmake-only -c

nim: config
	cd src && \
	rm -Rf output/ && \
	mkdir output && \
	cp -fv ~/.choosenim/toolchains/nim-\#devel/lib/nimbase.h build && \
	nim c --compileOnly --nimcache:build/ --os:zephyr --nomain --cpu:arm ${NIM_FLAGS} \
		main.nim

linux: 
	cd src && \
	nim c --os:linux --nomain -d:use_malloc \
	linux_run.nim

signed: build_${BOARD}/zephyr/zephyr.bin
	$(MCUBOOT)/scripts/imgtool.py sign \
		--key $(MCUBOOT)/root-rsa-2048.pem \
		--header-size 0x200 \
		--align 8 \
		--version $(shell cat VERSION) \
		--slot-size 0x67000 \
		--pad build_${BOARD}/zephyr/zephyr.bin \
		build_${BOARD}/image.signed.bin
	sha256sum build_${BOARD}/image.signed.bin
	ls -l build_${BOARD}/image.signed.bin

linux-lite: 
	cd src && \
	nim c --os:linux --nomain -d:use_malloc \
	-d:nimNetLite \
	linux_run.nim

build: nim
	west build -p auto -d build_${BOARD}
	ls -l build_${BOARD}/zephyr/zephyr.bin

flash:
	west -v flash -d build_$(BOARD) -r jlink

clean:
	rm -Rf build_$(BOARD)

FORCE:
