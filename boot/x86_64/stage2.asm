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
    mov fs, ax
    mov gs, ax
    ; Use space below stage1  as stack space
    mov ss, ax
    mov ax, 0x07c00
    mov sp, ax 

    jmp stage2_main

stage2_main:
    mov si, gathermmapmsg 
    call puts

    ; Gather memory map
    ; Put this at 0x0600; its unlikely that it will
    ; grow to hit our stack
    mov di, 0x0600
    call gather_mmap
    cmp ax, 0
    je .gather_mmap_ok
    ; Gathering mmap failed
    mov si, failedmsg
    call puts
    jmp .lHang
.gather_mmap_ok:
    mov si, okmsg
    call puts

.lHang:
    jmp .lHang

%include "mmap.asm"

; Params: 
;   si: Pointer to zero terminated string
puts:                   
    mov ah, 0x0e            ; int 10h 'print char' function
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

gathermmapmsg:
    db 13, 10, 'Gathering memory map... ', 0
failedmsg:
    db 'Failed', 13, 10, 0
okmsg:
    db 'Ok', 13, 10, 0
