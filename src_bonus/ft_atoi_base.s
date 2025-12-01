; int ft_atoi_base(char *str, char *base);
; atoi() returns the converted value or 0 on error

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
; For ft_atoi_base() this means: 
; RDI   -> char *str
; RSI   -> char *base

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

section .text
global  ft_atoi_base

ft_atoi_base:



.done
    ret
