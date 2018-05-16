;;; **************************************
;;; Stage 2 loader
;;; Responsible for detecting hardware
;;; configuration, setting up long mode
;;; and loading the kernel
;;; **************************************

ORG 0x7e00
BITS 16
stage2_entry: 
    ; Setup a stack and segments
    xor ax, ax 
    mov ds, ax
    mov es, ax
    ; Reuse stage1 as stack space :-)
    mov ax, 0x07c0
    mov ss, ax
    add ax, 512
    mov sp, ax 
   
    mov si, hellostr 
    call puts
     
.lHang:
    jmp .lHang

; Params: 
;   si: Pointer to zero terminated string
puts:                   
    mov ah, 0Eh             ; int 10h 'print char' function
    mov bh, 0x00
    mov bl, 0x03
.repeat:
    lodsb                   ; Get character from string
    cmp al, 0
    je .done                ; If char is zero, end of string
    int 10h                 ; Otherwise, print it
    jmp .repeat
.done:
    ret
    
hellostr: db 'Hello, world!', 0
