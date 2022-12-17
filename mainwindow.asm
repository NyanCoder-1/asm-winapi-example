    extern  PrintStderr@Util
    extern  PrintStdout@Util
    extern  PrintLastError@Util
    extern  __imp_GetModuleHandleW
    extern  __imp_LoadCursorW
    extern  __imp_RegisterClassExW
    extern  __imp_GetModuleHandleW
    extern  __imp_CreateWindowExW
    extern  __imp_ShowWindow
    extern  __imp_PostQuitMessage
    extern  __imp_DefWindowProcW

    extern  messageCannotCreateWindow@MainWindow
    extern  ClassName@MainWindow
    extern  Title@MainWindow

    global  Register@MainWindow
    global  Create@MainWindow

section .text
Register@MainWindow:
    ;WNDCLASSEXW(50h)
    ;    DWORD cbSize(0h) size(4)
    ;    DWORD style(4h) size(4)
    ;    QWORD lpfnWndProc(8h) size(8)
    ;    DWORD cbClsExtra(10h) size(4)
    ;    DWORD cbWndExtra(14h) size(4)
    ;    QWORD hInstance(18h) size(8)
    ;    QWORD hIcon(20h) size(8)
    ;    QWORD hCursor(28h) size(8)
    ;    QWORD hbrBackground(30h) size(8)
    ;    QWORD lpszMenuName(38h) size(8)
    ;    QWORD lpszClassName(40h) size(8)
    ;    QWORD hIconSm(48h) size(8)
    push    rbx
    sub     rsp, 80h ; 20h(shadow) + 50h(WNDCLASSEXW)

    ;xor     rcx, rcx
    ;call    GetModuleHandleW
    xor     ecx, ecx
    mov     edx, 7f00h ; IDC_ARROW
    call    qword[__imp_LoadCursorW]
    mov     qword[rsp + 48h], rax                   ; wcex.hCursor
    mov     dword[rsp + 20h], 50h                   ; wcex.cbSize
    mov     dword[rsp + 24h], 0                     ; wcex.style
    mov     qword[rsp + 28h], WndProc@MainWindow    ; wcex.lpfnWndProc
    mov     dword[rsp + 30h], 0                     ; wcex.cbClsExtra
    mov     dword[rsp + 34h], 0                     ; wcex.cbWndExtra
    xor     rax, rax
    mov     qword[rsp + 38h], rax                   ; wcex.hInstance
    mov     qword[rsp + 40h], rax                   ; wcex.hIcon
    mov     qword[rsp + 50h], 6 ; COLOR_WINDOW + 1  ; wcex.hbrBackground
    mov     qword[rsp + 58h], rax                   ; wcex.lpszMenuName
    mov     qword[rsp + 60h], ClassName@MainWindow  ; wcex.lpszClassName
    mov     qword[rsp + 68h], rax                   ; wcex.hIconSm
    lea     rcx, [rsp + 20h]
    call    qword[__imp_RegisterClassExW]
    test    eax, eax
    jne     _end@Register@MainWindow
    call    PrintLastError@Util
    xor     rax, rax
_end@Register@MainWindow:
    add     rsp, 80h
    pop     rbx
    ret


Create@MainWindow:
    push    rbx
    sub     rsp, 60h ; 20h(shadow) + 40h(CreateWindowExW args)

    ;xor     ecx, ecx
    ;call    GetModuleHandleW
    mov     qword[rsp + 50h], 0                         ; hInstance
    xor     ecx, ecx                                    ; dwExStyle
    mov     rdx, ClassName@MainWindow                   ; lpClassName
    mov     r8, Title@MainWindow                        ; lpWindowName
    mov     r9d, 0CF0000h ; WS_OVERLAPPEDWINDOW         ; dwStyle
    mov     rax, 80000000h
    mov     qword[rsp + 20h], rax ; CW_USEDEFAULT ; X
    mov     qword[rsp + 28h], rax ; CW_USEDEFAULT ; Y
    mov     qword[rsp + 30h], 500h                      ; nWidth
    mov     qword[rsp + 38h], 2d0h                      ; nHeight
    mov     qword[rsp + 40h], 0                         ; hWndParent
    mov     qword[rsp + 48h], 0                         ; hMenu
    mov     qword[rsp + 58h], 0                         ; lpParam
    call    qword[__imp_CreateWindowExW]
    test    rax, rax
    je      _fail@Create@MainWindow
    mov     rbx, rax    ; hwnd
    mov     rcx, rbx
    mov     rdx, 5
    call    qword[__imp_ShowWindow]
    mov     rax, rbx
    jmp     _end@Create@MainWindow

_fail@Create@MainWindow:
    lea     rcx, [messageCannotCreateWindow@MainWindow]
    call    PrintStderr@Util
    xor     rax, rax
_end@Create@MainWindow:
    add     rsp, 60h
    pop     rbx
    ret


WndProc@MainWindow:
    sub     rsp, 28h
    mov     qword[rsp + 8h], rcx
    mov     qword[rsp + 10h], rdx
    mov     qword[rsp + 18h], r8
    mov     qword[rsp + 20h], r9
    cmp     edx, 2  ; WM_DESTROY
    je      _WM_DESTROY@WndProc@MainWIndow
_default@WndProc@MainWindow:
    mov     rcx, [rsp + 8h]
    mov     rdx, [rsp + 10h]
    mov     r8, [rsp + 18h]
    mov     r9, [rsp + 20h]
    call    qword[__imp_DefWindowProcW]
    jmp     _end@WndProc@MainWindow
_WM_DESTROY@WndProc@MainWIndow:
    xor     rcx, rcx
    call    qword[__imp_PostQuitMessage]
    jmp     _default@WndProc@MainWindow
_return0@WndProc@MainWindow:
    xor     rax, rax
_end@WndProc@MainWindow:
    add     rsp, 28h
    ret
