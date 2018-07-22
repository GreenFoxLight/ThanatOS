; gets the memory map, using int 0x15
; Param: di - target address
; Return: AX = 0, if successfull, AX = 1 if not
gather_mmap: 
    xor ebx, ebx
    mov edx, 0x534d4150
    mov eax, 0x0000e820
    mov ecx, 24
    int 0x15
    jc .mmap_failed
    cmp eax, 0x534d4150
    jne .mmap_failed
    cmp ebx, 0
    je .mmap_failed
.mmap_loop:
    cmp cl, 20
    je .normal_entry
    ; extended 24 byte entry.
    mov eax, 0x1
    mov DWORD [di + 20], eax
.normal_entry:
    mov eax, 0x0000e820
    mov ecx, 24
    add di, 24
    int 0x15
    jc .done
    cmp ebx, 0
    je .done 
.done:
    mov ax, 0
    ret

.mmap_failed:
    mov ax, 1
    ret

