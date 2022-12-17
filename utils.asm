    ; io
    extern  GetStdHandle         ; void* GetStdHandle(int32_t nStdHandle)
    extern  WriteFile            ; char WriteFile(void* hFile, const void* lpBuffer, int32_t nNumberOfBytesToWrite, _Out_opt_ int* lpNumberOfBytesWritten, _opt_ OVERLAPPED* lpOverlapped)
    ; memory
    extern  GetProcessHeap       ; void* GetProcessHeap(void)
    extern  HeapAlloc            ; void* HeapAlloc(void* hHeap, uint32_t dwFlags, uint32_t dwBytes)
    extern  HeapFree             ; char HeapFree(void* hHeap, uint32_t dwFlags, void* lpMem)
    ; Win32
	extern  GetLastError         ; uint32_t GetLastError(void)
	extern  FormatMessageA       ; uint32_t FormatMessageA(uint32_t dwFlags, const void* lpSource, uint32_t dwMessageId, uint32_t dwLanguageId, void* lpBuffer, uint32_t nSize, void* Arguments)

    extern  endLine@Util
    extern  length#endLine@Util
    extern  error#1@PrintLastError@Util
    extern  length#error#1@PrintLastError@Util
    extern  error#2@PrintLastError@Util
    extern  length#error#2@PrintLastError@Util

    global  PrintStderr@Util     ; void PrintStderr@Util(void*)
    global  PrintStdout@Util     ; void PrintStdout@Util(void*)
    global  strlen@Util          ; int64_t strlen@Util(char*)
    global  wstrlen@Util         ; int64_t wstrlen@Util(wchar_t*)
    global  memalloc@Util        ; void* memalloc@Util(uint32_t)
    global  memfree@Util         ; void memfree@Util(void*)
    global  itos@Util            ; void* itos(int64_t)
    global  PrintLastError@Util  ; void PrintLastError(void)

section .text
strlen@Util:
    push    rbx
    push    r12
    push    r13
    push    r14

    mov     rdx, 7f7f7f7f7f7f7f7fh
    mov     r8, 0101010101010101h
    mov     r9, 8080808080808080h
    mov     r10d, 0ff000000h
    mov     r11, 0ff00000000h
    mov     r12, 0ff0000000000h
    mov     r13, 0ff000000000000h
    mov     r14, 0ff00000000000000h

    mov     rax, rcx
_loop@strlen@Util:
    mov     rbx, qword[rax]
    add     rax, 8
    and     rbx, rdx
    sub     rbx, r8
    and     rbx, r9
    xor     rbx, 0
    jz      _loop@strlen@Util ; go check next 8 bytes if no potential
    ; there's somewhere could be zero byte
    sub     rax, 8
    mov     rbx, qword[rax]

    test    bl, bl
    je      _end@strlen@Util

    inc     rax
    test    bx, 0ff00h
    je      _end@strlen@Util

    inc     rax
    test    ebx, 0ff0000h
    je      _end@strlen@Util

    inc     rax
    test    ebx, r10d
    je      _end@strlen@Util

    inc     rax
    test    rbx, r11
    je      _end@strlen@Util

    inc     rax
    test    rbx, r12
    je      _end@strlen@Util

    inc     rax
    test    rbx, r13
    je      _end@strlen@Util

    inc     rax
    test    rbx, r14
    jne     _loop@strlen@Util ; 0x7f byte has triggered

_end@strlen@Util:
    sub     rax, rcx
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret


wstrlen@Util:
    push    rbx
    push    r12

    mov     rdx, 7fff7fff7fff7fffh
    mov     r8, 0001000100010001h
    mov     r9, 8000800080008000h
    mov     r10d, 0ffff0000h
    mov     r11, 0ffff00000000h
    mov     r12, 0ffff000000000000h

    mov     rax, rcx

_loop@wstrlen@Util:
    mov     rbx, qword[rax]
    add     rax, 8
    and     rbx, rdx
    sub     rbx, r8
    and     rbx, r9
    xor     rbx, 0
    je      _loop@wstrlen@Util ; go check next 4 words if no potential
    ; there's somewhere could be zero word
    sub     rax, 8
    mov     rbx, qword[rax]

    test    bx, bx
    je      _end@wstrlen@Util

    add     rax, 2
    test    ebx, r10d
    je      _end@wstrlen@Util

    add     rax, 2
    test    rbx, r11
    je      _end@wstrlen@Util

    add     rax, 2
    test    rbx, r12
    jne     _loop@wstrlen@Util ; 0x7fff byte has triggered

_end@wstrlen@Util:
    sub     rax, rcx
    mov     rbx, 2
    div     rbx

    pop     r12
    pop     rbx
    ret


PrintStderr@Util:
    push    rbx
    push    rbp
    sub     rsp, 28h    ; 20h(shadow) + 8h(WriteFile args)

    mov     rbx, rcx    ; lpStr
    mov     rcx, -12    ; STD_ERROR_HANDLE = ((DWORD)-11)
    jmp     _PrintStd@Util

PrintStdout@Util:
    push    rbx
    push    rbp
    sub     rsp, 28h    ; 20h(shadow) + 8h(WriteFile args)

    mov     rbx, rcx    ; lpStr
    mov     rcx, -11    ; STD_OUTPUT_HANDLE = ((DWORD)-11)

_PrintStd@Util:
    call    GetStdHandle

    mov     rcx, rbx
    mov     rbp, rax    ; GetStdHandle(STD_ERROR_HANDLE)
    call    strlen@Util
    mov     rcx, rbp            ;hFile
    mov     rdx, rbx            ;lpBuffer
    mov     r8, rax             ;nNumberOfBytesToWrite
    xor     r9, r9              ;lpNumberOfBytesWritten
    mov     qword[rsp + 20h], 0 ;lpOverlapped
    call    WriteFile

    add     rsp, 28h
    pop     rbp
    pop     rbx
    ret


memalloc@Util:
    push    rbp
    sub     rsp, 20h
    mov     rbp, rcx
    call    GetProcessHeap
    test    rax, rax
    je      _fail@memalloc@Util
    mov     rcx, rax
    xor     rdx, rdx
    mov     r8, rbp
    call    HeapAlloc
    jmp     _end@memalloc@Util
_fail@memalloc@Util:
    xor     rax, rax
_end@memalloc@Util:
    add     rsp, 20h
    pop     rbp
    ret


memfree@Util:
    push    rbp
    sub     rsp, 20h
    mov     rbp, rcx
    call    GetProcessHeap
    test    rax, rax
    je      _end@memfree@Util
    mov     rcx, rax
    xor     rdx, rdx
    mov     r8, rbp
    call    HeapFree
_end@memfree@Util:
    add     rsp, 20h
    pop     rbp
    ret


itos@Util:
    mov     qword[rsp + 8h], rbx
    mov     qword[rsp + 10h], rbp
    mov     qword[rsp + 18h], rdi
    sub     rsp, 20h

    ; count str length
    mov     rbx, rcx
    mov     rax, rcx ; numTemp = num
    mov     rcx, 8000000000000000h
    test    rax, rcx ; (numTemp & 8000000000000000h) == 0
    mov     rcx, 10
    je      _countNotNegative@itos@Util
    neg     rax ; numTemp = -numTemp
    mov     rbp, 2
    jmp     _count@itos@Util
_countNotNegative@itos@Util:
    mov     rbp, 1
_count@itos@Util:
    inc     rbp ; count++
    xor     rdx, rdx
    div     rcx ; numTemp /= 10
    test    rax, rax
    jne     _count@itos@Util
_countEnd@itos@Util:
    ; rbp == count
    ; rbx == num

    ; allocate str
    mov     rcx, rbp
    call    memalloc@Util
    test    rax, rax
    je      _end@itos@Util ;jump to _end@itos@Util if _memalloc returned nullptr
    dec     rbp
    mov     byte[rax + rbp], 0 ; make str null-terminated

    ; migrate key values to safe registers
    mov     rdi, rax ; rbx = str
    mov     rax, rbx ; rax = num

    mov     rcx, 8000000000000000h
    test    rax, rcx ; (num & 8000000000000000h) == 0
    mov     rcx, 10
    je      _write@itos@Util
    mov     byte[rdi], '-' ; str[0] = '-'
    neg     rax ; num = -num
_write@itos@Util:
    xor     rdx, rdx ; rdx = 0
    div     rcx
    dec     rbp
    add     rdx, '0'
    mov     byte[rdi + rbp], dl
    test    rax, rax
    jne     _write@itos@Util

    mov     rax, rdi
_end@itos@Util:
    add     rsp, 20h
    mov     rbx, [rsp + 8h]
    mov     rbp, [rsp + 10h]
    mov     rdi, [rsp + 18h]
    ret


PrintLastError@Util:
    push    rbx
    push    rbp
    push    rdi
    sub     rsp, 40h    ; 20h(shadow) + 18h(FormatMessageA args) + 8h(messageBufferPtr)
    mov     rcx, -12    ; STD_ERROR_HANDLE == ((DWORD)-12)
    call    GetStdHandle
    mov     rbx, rax    ; hFile
    call    GetLastError
    test    eax, eax
    je      _end@PrintLastError@Util
    mov     ebp, eax    ; errorId

    ; sort of like fprintf(STDERR, "Error (%d): ", GetLastError())
    mov     rcx, rbx
    lea     rdx, [error#1@PrintLastError@Util]
    mov     r8, [length#error#1@PrintLastError@Util]
    mov     r9, 0
    mov     qword[rsp + 20h], 0
    call    WriteFile
    mov     ecx, ebp
    call    itos@Util
    mov     rdi, rax    ; errorIdStr
    mov     rcx, rax
    call    strlen@Util
    mov     r8, rax
    mov     rcx, rbx
    mov     rdx, rdi
    mov     r9, 0
    mov     qword[rsp + 20h], 0
    call    WriteFile
    mov     rcx, rdi
    call    memfree@Util
    mov     rcx, rbx
    lea     rdx, [error#2@PrintLastError@Util]
    mov     r8, [length#error#2@PrintLastError@Util]
    mov     r9, 0
    mov     qword[rsp + 20h], 0
    call    WriteFile

    mov     rcx, 1300h              ; dwFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS
    xor     rdx, rdx                ; lpSource
    mov     r8d, ebp                ; dwMessageId
    mov     r9d, 409h               ; dwLanguageId = MAKELANGID(LANG_ENGLISH, SUBLANG_DEFAULT)
    lea     rax, [rsp + 38h]
    mov     qword[rsp + 20h], rax   ; lpBuffer
    mov     qword[rsp + 28h], 0     ; nSize
    mov     qword[rsp + 30h], 0     ; Arguments
    call    FormatMessageA

    mov     rcx, rbx
    mov     rdx, [rsp + 38h]
    mov     r8, rax
    mov     r9, 0
    mov     qword[rsp + 20h], 0
    call    WriteFile
    mov     rcx, rbx
    lea     rdx, [endLine@Util]
    mov     r8, [length#endLine@Util]
    mov     r9, 0
    mov     qword[rsp + 20h], 0
    call    WriteFile

_end@PrintLastError@Util:
    add     rsp, 40h
    pop     rdi
    pop     rbp
    pop     rbx
    ret
