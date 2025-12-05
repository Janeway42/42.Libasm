; size_t strlen(const char *s);
; strlen() returns the number of bytes in the string pointed to by s.
; strlen does not set errno

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
; For strlen() this means: 
; RDI   -> char *s
; DL    -> (lower 8 bit of RDX) used to hold the current character being copied  
; (not using AL to hold the copied character in order to preserve the full 64 bit pointer to dest - RAX)
; RAX   -> return value = number of bytes in string s
; ---------------------------------------------------------------------------------------

section .text
global  ft_streln

ft_strlen:
    xor	rax, rax            ; set RAX  to 0 - default return register in this case used as length counter
							; xor stores in the first operand the result of a bitwise exclusive OR 
                            ; (0 if equal bits and 1 for different bits)
								
.loop:
    cmp	byte [rdi + rax], 0 ; compare current byte with 0
    je	.done               ; if 0 ('\0') jump to .done
    inc	rax                 ; increment RAX
    jmp	.loop               ; restart .loop    

.done:
    ret     