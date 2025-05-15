.model small
.stack 100h
.data
    password db "hello", 0        ; Correct password
    input    db 6 dup(?)          ; User input buffer (5 chars + null)
    msg_prompt db "Enter password: $"
    msg_granted db 13,10, "Access Granted$", 0
    msg_denied  db 13,10, "Access Denied$", 0    
    
    
    
.code
main:
    mov ax, @data
    mov ds, ax

start:
    ; Print prompt
    lea dx, msg_prompt
    mov ah, 09h
    int 21h

    ; Read password (5 characters max)
    mov si, 0
read_loop:
    mov ah, 01h       ; Read character from input
    int 21h
    cmp al, 13        ; Enter key (carriage return)?
    je  check_input
    mov input[si], al
    inc si
    cmp si, 5         ; Max 5 chars
    jl  read_loop

check_input:
    ; Null-terminate input
    mov input[si], 0

    ; Compare input with password
    lea si, input
    lea di, password
compare_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne denied
    cmp al, 0
    je granted
    inc si
    inc di
    jmp compare_loop

granted:
    lea dx, msg_granted
    mov ah, 09h
    int 21h
    jmp exit

denied:
    lea dx, msg_denied
    mov ah, 09h
    int 21h
    jmp exit

exit:
    mov ah, 4Ch
    int 21h
end main
