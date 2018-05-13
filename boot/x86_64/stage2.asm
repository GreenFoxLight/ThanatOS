SECTION .text
GLOBAL stage2_entry
stage2_entry: 
    mov ah, 0x0e
    mov al, '2'
    int 0x10
    jmp $
    resb 512 - $ - stage2_entry
