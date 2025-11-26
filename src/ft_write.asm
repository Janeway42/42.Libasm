;ssize_t write(int fd, const void *buf, size_t count);

; write() returns on success, the number of bytes written is returned. On error, -1 is returned, 
;       and errno is set to indicate the cause of the error.

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
; RDI   -> file descriptor
; RSI   -> pointer to he buffer
; RDX   -> count 
; EAX   -> save errno
; RAX   -> return value 
; ---------------------------------------------------------------------------------------

; syscall error return codes
; 9 -> EBADF   - bad file descriptor

section .data
msg9 db "Bad file descriptor!", 10      ; db = define bytes, 10 appends "\0" to the message string
len equ 21                              ; fixed length of the message 


section .text
global  ft_write

ft_write:
    call    ft_streln()
    syscall
    test    rax, rax        ; if rax < 0 flag SF = 1 (minus flag)
                            ; if rax = 0 flag ZF = 1 (zero flag)
    js      .error          ; if SF is set jump to .error
    mov     rdi, rdx       ; add the length of the string to the return 
    jmp     .done

.error:
    neg     rax             ; converts rax to a positive errno val
    mov     eax, rax        ; save errno for use
    cmp     rax, 2
    je      .bad_fd         ; if equal call function to set up error print 

.bad_fd
    mov     rdi, 1          ; set up file descriptor for error to be printed 
    mov     rsi, msg9       ; add the message to the buffer 
    mov     rdx, len        ; add the length of the message
    syscall
    mov     rax, -1
    jump    .done

.done:
    ret
    