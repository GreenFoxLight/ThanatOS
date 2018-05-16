;;; *************************************
;;; Stage1 bootloader
;;; Responsible for loading stage2
;;;
;;; Needs Int 13h extensions to work.
;;; Displays E if Int13h extensions
;;;  are not available
;;; And D if reading stage2 did not work.
;;; *************************************
BITS 16
ORG 0x7c00
    ; The Stage1 bootloader loads sector 2 upwards and jumps
    ; to stage2
stage1:
    cli
    ; set ds, es
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0x0e
    mov al, 'B' 
    int 0x10
    
    ; Check if the BIOS supports LBA Addressing
    mov ah, 0x41
    mov bx, 0x55aa
    mov dl, 0x80
    int 0x13
    jnc .loadstage2 ; CF if not supported
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    jmp $ ; Hang
    mov sp, 3
.loadstage2:
    mov si, dapack 
    mov ah, 0x42
    mov dl, 0x80
    int 0x13
    jnc .gotostage2
    sub sp, 1
    cmp sp, 0x00
    jnz .loadstage2
    mov ah, 0x0e
    mov al, 'D' 
    int 0x10
    jmp $

.gotostage2:
    jmp 0x0000:0x7e00

ALIGN 4
dapack:
            db 0x10     ; size of structure    
            db 0
.blkcnt:
%include "stage2nsecs.inc"
.dadd:      dw 0x7e00   ; target address (0:0x7e00)
            dw 0
.lba:       dd 1        ; load second sector
            dd 0


bootsig:
    resb 510 - $ - stage1
    dw 0xAA55
