; char *strcpy(char *dest, const char *src);
; strcpy() returns a pointer to the destination string dest.


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
    mov     rax, rdi        ; save destination pointer (return value) in RAX

.loop:
    mov     dl, byte [rsi]  ; load byte from src
    move    byte [rdi], dl  ; store byte into dest
    inc     rsi             ; advance src pointer
    inc     rdi             ; advance dest pointer
    cmp     dl, 0           ; check if it is the end of the string "\0"
    jne     .loop           ; if not equal restart the .loop
    ret                     ; return RAX
