; char *strcpy(char *dest, const char *src);
; strcpy() returns a pointer to the destination string dest.
; strcpy does not set errno

; Registers
; As per the System V AMD64 ABI convention: 
; the first six interger/pointer arguments are passed in the following registers:
; RDI -> first argument
; RSI -> second argument
; RDX -> third argument
; RCX -> fourth argument
; R8 -> fifth argument
; R9 ->  sixth argument
; 
; RAX -> designated return register 
; ---------------------------------------------------------------------------------------
; For strcpy() this means: 
; RDI   -> char *dest
; RSI   -> char *src 
; DL    -> (lower 8 bit of RDX) used to hold the current character being copied  
; (not using AL to hold the copied character in order to preserve the full 64 bit pointer to dest - RAX)
; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------


section .text
global  ft_strcpy

ft_strcpy:
    xor rax, rax

.loop:
    mov dl, BYTE [rsi + rax]	; load one byte (8 bit) from the memory address in RSI (src)
    mov byte [rdi + rax], dl	; store one byte (8 bit) into the memory address in RDI (dest)
    inc rax
    cmp dl, 0			; check if it is the end of the string "\0"
    jne .loop			; if not equal restart the .loop
    jmp .done

.done
    mov rax, rdi
    ret					; return RAX