x86_64-boot.bin: stage1.bin stage2.bin 
	cat $^ > $@		

stage1.bin: stage1.asm
	nasm -f bin -o $@ $^

stage2.bin: stage2.asm
	nasm -f bin -o $@ $^


clean:
	rm -f stage1.bin stage2.bin x86_64-boot.bin
