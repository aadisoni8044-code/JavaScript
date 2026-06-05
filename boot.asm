;====================================================================
;                 SPEEDY OPERATING SYSTEM (JSDOS VERSION)
;          DIRECT EXECUTIVE RUN FOR MASM/TASM - BY AADI SONI
;====================================================================

.MODEL SMALL            ; DOS mode ke liye small model use karenge
.STACK 100h             ; Stack memory allocate ki
.DATA                                                                                                     ; Data section jahan saari strings hain

    ; Yeh hai aapke Speedy OS ka bada naam:
    MSG_BIG_NAME DB '  ____  ____  _____ _____ ______     __   ____   ____ ', 0Dh, 0Ah
                 DB ' / ___||  _ \| ____| ____|  _ \ \   / /  / ___| / ___|', 0Dh, 0Ah
                 DB ' \___ \| |_) |  _| |  _| | | | \ \ / /  | |  ||  \___ \', 0Dh, 0Ah
                 DB '  ___) |  __/| |___| |___| |_| |\ V /   | |_| |  ___) |', 0Dh, 0Ah
                 DB ' |____/|_|   |_____|_____|____/  |_|     \____| |____/ ', 0Dh, 0Ah, 0Dh, 0Ah, '$'

    MSG_BANNER   DB '======================================================', 0Dh, 0Ah
                 DB '   SPEEDY OS SYSTEM CORE v1.2 - DOS ENVIRONMENT      ', 0Dh, 0Ah
                 DB '======================================================', 0Dh, 0Ah, '$'

    MSG_WELCOME  DB 'Loading environment data... DONE!', 0Dh, 0Ah
                 DB 'Hardware status: Jsdos Virtualization SUCCESSFUL.', 0Dh, 0Ah, 0Dh, 0Ah, '$'

    MSG_PROMPT   DB 'SpeedyOS_Kernel> ', '$'
    MSG_NEWLINE  DB 0Dh, 0Ah, '$'

.CODE                                                   ; Code section shuru
    start:
                       mov   ax, @DATA                  ; Data segment ko AX mein initialize kiya
                       mov   ds, ax                     ; DS register ko setup kiya

    init_video:
                       mov   ah, 00h                    ; BIOS Set Video Mode function
                       mov   al, 03h                    ; 80x25 screen mode text
                       int   10h                        ; Video Interrupt call kiya

    print_big_name:
                       ; Green color mein bada naam print karne ke liye settings
                       mov   si, OFFSET MSG_BIG_NAME
                       mov   bl, 0Ah                    ; 0Ah = Light Green color
                       call  print_string_color

    print_system_info:
                       ; Cyan color mein baki details print karne ke liye settings
                       mov   si, OFFSET MSG_BANNER
                       mov   bl, 03h                    ; 03h = Cyan color
                       call  print_string_color

                       mov   si, OFFSET MSG_WELCOME
                       mov   bl, 03h
                       call  print_string_color

                       mov   si, OFFSET MSG_PROMPT
                       mov   bl, 03h
                       call  print_string_color

    kernel_loop:
                       mov   ah, 00h                    ; Keypress capture interrupt
                       int   16h

                       cmp   al, 0Dh                    ; Check if user pressed "ENTER"
                       je    on_enter

                       mov   ah, 0Eh                    ; Character print output mode
                       mov   bl, 0Bh                    ; Light Cyan for typed text
                       int   10h
                       jmp   kernel_loop

    on_enter:
                       mov   si, OFFSET MSG_NEWLINE
                       mov   bl, 03h
                       call  print_string_color
                       mov   si, OFFSET MSG_PROMPT
                       mov   bl, 03h
                       call  print_string_color
                       jmp   kernel_loop

;--------------------------------------------------------------------
; CORE FUNCTION: UNIVERSAL COLOR STRING PRINTER
;--------------------------------------------------------------------
print_string_color PROC
                       push  ax
                       push  bx
    _loop:
                       lodsb
                       cmp   al, '$'                    ; DOS mode mein string end check karne ka tarika
                       je    _done
                       mov   ah, 0Eh                    ; Teletype function active
                       int   10h                        ; BL register holds the color already
                       jmp   _loop
    _done:
                       pop   bx
                       pop   ax
                       ret
print_string_color ENDP

    exit_program:
                       mov   ah, 4Ch                    ; DOS control back instruction
                       int   21h

END start               ; Code ends safely