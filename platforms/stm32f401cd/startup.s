.cpu cortex-m4
.thumb

// end of RAM
.word 0x20018000
.word _reset
.thumb_func
_reset:
    bl main
    b .
