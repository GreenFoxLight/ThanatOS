BITS 16
SECTION .text
    ; The Stage1 bootloader loads sector 2 upwards and jumps
    ; to stage2
stage1:
    mov ah, 0x0e
    mov al, 'B' 
    int 0x10

    ; Get drive geometry
    mov ah, 0x08
    mov dl, 0x80
    int 0x13
    ; dh is number of heads - 1
    ; cl & 0x3f is sectors per track
    inc dh
    mov BYTE [.number_of_heads], dh
    and cl, 0x3f
    mov BYTE [.sectors_per_track], cl
    
    ; Load stage2
    xor ax, ax
    mov es, ax
    mov bx, 0x7e00 
    mov sp, 3
; Params: es:bx target address
;         dx    LBA (1 based)
.read_sectors:
    mov ah, 0x02    ; BIOS read sector function
    mov al, 1       ; Read 1 sector
    mov ch, 0x00    ; Select cylinder 0
    mov dh, 0x00    ; Select head 0
    mov cl, 0x02    ; Start reading from second sector ( i.e.
                    ; after the boot sector )
    mov dl, 0x80
    int 0x13
    jnc SHORT .gotostage2
    dec sp
    cmp sp, 0x00
    jz .read_sectors
    jmp .transfer_error
    ;cmp ah, 0
    ;jne .transfer_error
.gotostage2:
    jmp 0x0000:0x7e00
.transfer_error:
    dec sp
    cmp sp, 0
    jne .read_sectors
    mov ah, 0x0e
    mov al, 'E' 
    int 0x10
    jmp $ 

ALIGN 4
.number_of_heads:   db 0
.sectors_per_track: db 0

bootsig:
    resb 510 - $ - stage1
    dw 0xAA55
