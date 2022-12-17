    extern  GetMessageW         ; BOOL GetMessageW(void* lpMsg, void* hWnd, unsigned int wMsgFilterMin, unsigned int wMsgFilterMax)
    extern  TranslateMessage    ; BOOL TranslateMessage(void* lpMsg)
    extern  DispatchMessageW    ; LRESULT DispatchMessageW(void* lpMsg)

    global  mainLoop

section .text
mainLoop:
    ;MSG(30h)
    ;    hwnd(0h) size(8h)
    ;    message(8h) size(4h)
    ;    wParam(10h) size(8h)
    ;    lParam(18h) size(8h)
    ;    time(20h) size(4h)
    ;    pt(24h) size(8h)
    sub     rsp, 58h ; 20h(shadow) + 30h(MSG)
_loopstart@mainLoop:
    lea     rcx, [rsp + 20h]
    xor     rdx, rdx
    xor     r8, r8
    xor     r9, r9
    call    GetMessageW
    test    eax, eax
    je      _loopend@mainLoop
    cmp     eax, -1
    je      _loopend@mainLoop
    lea     rcx, [rsp + 20h]
    call    TranslateMessage
    lea     rcx, [rsp + 20h]
    call    DispatchMessageW
    jmp     _loopstart@mainLoop

_loopend@mainLoop:
    add     rsp, 58h
    ret
