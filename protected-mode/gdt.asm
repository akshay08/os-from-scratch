; GDT - Global Descriptor Table (contains 8-byte segment descriptors)

gdt_start:

gdt_null:
dd 0x0
dd 0x0 ; null (invalid) segment descriptor of 8 bytes

; segment_limit = 20 bits = 1 MB Max
; expanded by 4096 times, by setting granularity = 1
; so segment_limit = 1 MB * 4096 = 4 GB
; we set this as segment_limit for both code and data segments

; base_address = start address of segment
; we set base_address = 0x0 for both code and data segments

; both code and data segments span the entire 4GB memory address space
gdt_code:
dw 0xffff ; segment_limit-first 16 bits [0, 15]-of segment descriptor
dw 0x0000 ; base_address of segment first 16 bits [16, 31]
db 0x00 ; base_address of segment 2nd 8 bits [32, 39]
db 10011010b ; [40, 47] segment present (1), descrptor privilege level (00), descriptor type (1 - code/data),  type-code (1-code), type-conforming (0), type-readable (1), type-accessed (0)
db 11001111b ; [48, 55], granularity (1), default operation size (1 - 32-bit), 64-bit segment (0), available (0), segment_limit next 4 bits [48, 51]
db 0x00 ; base_address 3rd 8 bits [56, 63]

gdt_data:
dw 0xffff ; segment_limit-first 16 bits [0, 15]-of segment descriptor
dw 0x0000 ; base_address of segment first 16 bits [16, 31]
db 0x00 ; base_address of segment 2nd 8 bits [32, 39]
db 10010010b ; [40, 47] segment present (1), descrptor privilege level (00), descriptor type (1 - code/data),  type-code (0-data), type-expand-down (0), type-writable (1), type-accessed (0)
db 11001111b ; [48, 55], granularity (1), default operation size (1 - 32-bit), 64-bit segment (0), available (0), segment_limit next 4 bits [48, 51]
db 0x00 ; base_address 3rd 8 bits [56, 63]

gdt_end:

; GDT descriptor, containing size (16-bits) and start location (32-bits) of GDT
gdt_descriptor:
	dw gdt_end - gdt_start - 1; Size of our GDT , always less one (byte) of the true size (why?) - maybe this is the last index of gdt, rather than the size?
	dd gdt_start ; start address, dd -> double word = 32 bits (because currently we're in 16-bit mode, so word = 16 bits, double word = 32 bits)


; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0 x0 -> NULL ; 0 x08 -> CODE ; 0 x10 -> DATA )
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start