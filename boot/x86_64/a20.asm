; Check if the A20 line is enabled
; Params: None
; Return: AX = 0 a20 is enabled, AX = 1 a20 is  disabled 
check_a20:
    push ds
    push es
    ; Read the bootsignature at 0x07DFE
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax
    mov di, 0x7dfe 
    mov ax, WORD [es:di] 
    ; Read the value 1MB higher, at 0x07DFE
    mov di, 0x7e0e
    mov bx, WORD [ds:di]
    cmp ax, bx
    jne .a20_enabled
    shl ax, 8 
    mov WORD [es:di], ax
    mov bx, WORD [ds:di]
    cmp ax, bx
    jne .a20_enabled
    jmp .a20_disabled
.a20_enabled:
    mov ax, 0
    jmp .out
.a20_disabled:
    mov ax, 1
.out:
    pop es 
    pop ds
    ret
    

; Enables the A20 line 
; Params: None
; Return: AX = 0 success, AX = 1 failure
enable_a20:
    ; Not implemented yet
    mov ax, 1
    ret
