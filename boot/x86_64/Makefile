x86_64-boot.bin: stage1.bin stage2.bin 
	cat $^ > $@		

stage1.bin: stage1.asm stage2nsecs.inc
	nasm -f bin -o $@ stage1.asm

stage2nsecs.inc: stage2.bin
	./scripts/num_sectors.sh stage2.bin > stage2nsecs.inc

stage2.bin: stage2.asm
	nasm -f bin -o $@ $^


clean:
	rm -f stage2nsecs.inc stage1.bin stage2.bin x86_64-boot.bin
