Pure x86 Assembly Triangle Area Calculator

A low-level, bare-metal 32-bit x86 Assembly program designed for Linux environments that calculates the area of a triangle. The program directly interfaces with the Linux kernel using software interrupts, operating entirely without high-level language wrappers or standard C libraries (`libc`).

---

Features:

100% Pure Assembly: Built completely from scratch using Intel x86 assembly instructions and direct Linux system calls (`SYS_WRITE`, `SYS_READ`, `SYS_EXIT`).
Custom Low-Level I/O: Features a custom routine (`read_two_digit_num`) that reads raw ASCII strings from the terminal, filters character boundaries, and converts them into numbers for mathematical processing.
No Dependencies: Does not link against `printf`, `scanf`, or any external libraries. Memory allocation, stack manipulation, and kernel communication are handled via custom macro architectures.

---

Technical Bounds:

Input Limitations: The custom parsing engine is tailored specifically to accept and compute up to 2-digit integer* for both the base and the height of the triangle.
Output Limitations: Numerical results are designed to match the 2-digit processing constraints of the custom display buffers.

---

Installation:

1. Clone the Repository
```
git clone [https://github.com/deniska-design/area_of_triangle.git](https://github.com/deniska-design/area_of_triangle.git)
```
```
cd area_of_triangle
```

2. Execution

```
./prog
```

---

Execution:

<img width="857" height="172" alt="image" src="https://github.com/user-attachments/assets/417ce2dc-9089-4057-8c34-71d861d051c2" />

---

License
This project is open-source. Anyone is completely free to download, modify, use, and distribute this software for personal or educational purposes.
