    global endLine@Util
    global length#endLine@Util
    global error#1@PrintLastError@Util
    global length#error#1@PrintLastError@Util
    global error#2@PrintLastError@Util
    global length#error#2@PrintLastError@Util
    global messageCannotCreateWindow@MainWindow
    global length#messageCannotCreateWindow@MainWindow
    global ClassName@MainWindow
    global length#ClassName@MainWindow
    global Title@MainWindow
    global length#Title@MainWindow

section .rodata
    endLine@Util: db 10, 0
    _end#endLine@Util: db 0, 0, 0, 0, 0, 0
    error#1@PrintLastError@Util: db 'Error (', 0
    _end#error#1@PrintLastError@Util:
    error#2@PrintLastError@Util: db '): ', 0
    _end#error#2@PrintLastError@Util: db 0, 0, 0, 0
    messageCannotCreateWindow@MainWindow: db 'Something', 39, 's went wrong: the window didn', 39, 't created', 10, 0
    _end#messageCannotCreateWindow@MainWindow: db 0, 0, 0, 0, 0
    ClassName@MainWindow: dw 'M', 'a', 'i', 'n', 'W', 'i', 'n', 'd', 'o', 'w', 0
    _end#ClassName@MainWindow: dw 0
    Title@MainWindow: dw 'W', 'i', 'n', 'A', 'P', 'I', ' ', 'w', 'i', 'n', 'd', 'o', 'w', ' ', 'e', 'x', 'a', 'm', 'p', 'l', 'e', ' ', 'o', 'n', ' ', 'n', 'a', 's', 'm', 0
    _end#Title@MainWindow: dw 0, 0
    length#endLine@Util: dq _end#endLine@Util - endLine@Util
    length#error#1@PrintLastError@Util: dq _end#error#1@PrintLastError@Util - error#1@PrintLastError@Util
    length#error#2@PrintLastError@Util: dq _end#error#2@PrintLastError@Util - error#2@PrintLastError@Util
    length#messageCannotCreateWindow@MainWindow: dq _end#messageCannotCreateWindow@MainWindow - messageCannotCreateWindow@MainWindow
    length#ClassName@MainWindow: dq _end#ClassName@MainWindow - ClassName@MainWindow
    length#Title@MainWindow: dq _end#Title@MainWindow - Title@MainWindow
