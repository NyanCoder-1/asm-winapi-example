    extern  Register@MainWindow
    extern  Create@MainWindow
    extern  PrintStdout@Util
    extern  mainLoop
    extern  ExitProcess      ; void ExitProcess(unsigned int uExitCode)

    global  _start

section .text
_start:
    sub     rsp, 28h

    call    Register@MainWindow
    test    rax, rax
    je      _end@_start
    call    Create@MainWindow
    test    rax, rax
    je      _end@_start
    call    mainLoop

_end@_start:
    xor     rcx, rcx
    call    ExitProcess

    xor     rax, rax
    add     rsp, 28h
    ret
