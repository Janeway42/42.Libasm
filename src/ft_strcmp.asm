; int strcmp(const char *s1, const char *s2);
; strcmp()returns an integer less than, equal to, or greater than  zero
;       if  s1  (or  the  first n bytes thereof) is found, respectively, to be less than, to match, or be greater than s2.
;       0, if s1 and s2 are equal, a negative value if s1 is less than s2, a positive value if s1 is greater than s2.


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
; For strcmp() this means: 
; RDI   -> char *s1
; RSI   -> char *s2 
; EAX   -> register used to load the current byte of s1 
; EDX   -> register used to load the current byte of s2
; RAX   -> return value 
; ---------------------------------------------------------------------------------------


section .text
global  ft_strcmp

ft_strcmp:
    xor     rax, rax            ; set RAX (length) counter to 0
                                ; xor stores in the first operand the result of a bitwise exclusive OR 
                                ; (0 if equal bits and 1 for different bits)

.loop:
    movzx   eax, byte [rdi]     ; load first char of s1 as unsigned in eax
    movzx   edx, byte [rsi]     ; load first char of s2 as unsigned in edx
    cmp     eax, edx            ; 
    jne     .calculate_diff     ; if the char's are different get the value
    cmp     eax, 0              ; see if t is the end of the string "\0"
    je      ret                 ; return RAX (previously set at 0)
    inc     rdi                 ; increment RDI (s1)
    inc     rsi                 ; increment RSI(s2)
    jmp     .loop
    