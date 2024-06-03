; PROJEK MENGKONVERSI NILAI PANJANG
; ANGGOTA = ALFARISY NAFARO GYMNASTIAR NPM = 140810230020
;         = HAMUD ABDUL AZIZ           NPM = 140810230042
;         = ARYA MUHAMMAD RAFI RAHARJO NPM = 140810230072

org 0x100

section .data
msgKm db "Masukan nilai panjang dalam satuan km   : $"             ; mendeklarasikan input untuk panjang Km
msgHm db " panjang dalam satuan hm      : $"             ; mendeklarasikan pesan untuk output hm
msgDam db " panjang dalam satuan dam     : $"             ; mendeklarasikan pesan untuk output dam
msgm db " panjang dalam satuan m       : $"             ; mendeklarasikan pesan untuk output m
buffer db 10, 0    ; Buffer untuk input dan output
km dw 0            ; Mendeklarasikan variabel 'km' dan menginisialisasinya dengan nilai 0
hm dw 0            ; Mendeklarasikan variabel 'hm' dan menginisialisasinya dengan nilai 0
dam dw 0           ; Mendeklarasikan variabel 'dam' dan menginisialisasinya dengan nilai 0
m dw 0             ; Mendeklarasikan variabel 'm' dan menginisialisasinya dengan nilai 0
newline db 0x0D, 0x0A, '$' ; untuk menambahkan baris baru

section .text

start:
; fungsi untuk membaca string
mov dx, msgKm
mov ah, 0x9
int 0x21

; fungsi untuk membaca input dan memuat alamat buffer ke dx
mov dx, buffer  ; memuat alamat buffer ke dalam register dx
mov ah, 0xA     ; fungsi untuk membaca input string
int 0x21        ; interrupt untuk membaca input

; fungsi konversi string ke angkmov dx, buffera
mov si, buffer + 2 ; memuat buffer + 2 dan pointer si menunjuk ke buffer
xor ax, ax ; mengosongkan ax

konversi_angka:
mov cl, [si] ; memasukan value dari pointer yang ditunjuk si ke dalam cl
cmp cl, '0' ; membandingkan isi dari cl dengan ASCII dari 0 
jb konversi_selesai ; jika cl < dari ASCII 0 maka akan jump ke fungsi konversi_selesai
cmp cl, '9' ; membandingkan isi dari cl dengan ASCII dari 0
ja konversi_selesai ; jika cl > dari ASCII 9 maka akan jump ke fungsi konversi_selesai
sub cl, '0' ; melakukan pengurangan dari ASCII cl dengan ASCII dari 0
mov bx, 10 ; memasukan nilai 10 ke dalam bx
mul bx ; melakukan perkalian ax x bx dan menyimpannya di ax, ini berfungsi bila kita menginput lebih dari 1 karakter
add ax,cx ; menjumlahkan nilai dari cl/cx dengan ax dan hasilnya disimpan di ax
inc si ; mengincrement pointer si yang berfungsi untuk menggeser karakter bila input lebih dari 1 karakter
jmp konversi_angka ; melakukan jmp ke konversi angka bila masih ada karakter yang belum terkonversi

konversi_selesai:
mov [km], ax ; memasukan hasil konversi ke dalam variabel km

konversi_panjang:

;Menampilkan nilai km
mov dx, msgKm ; memasukan string dari variabel msgkm kedalam dx
mov ah, 0x9 ; mov ah 0x9 digunakan untuk bisa menampilkan string
int 0x21 ; interupt ini digunakan untuk menampilkan string
mov ax, [km] ; memasukan value dari km kedalam register ax
call print ; memanggil fungsi dari print
mov dx, newline ; memuat alamat newline kedalam dx
int 0x21 ; memanggl interupt yang digunakan untuk bisa menambah garis baru

;konversi hm
mov ax, [km] ; memasukan value dari km kedalam register ax
mov bx, 10 ; memasukan nilai 10 ke dalam register bx
mul bx ; melakukan perkalian terhadap ax dan menyimpan hasilnya di register ax
mov [hm], ax ; menyimpan value dari ax kedalam variabel hm

;konversi dam
mov ax, [km] ; memasukan value dari km kedalam register ax
mov bx, 100 ; memasukan nilai 100 kedalam register bx
mul bx ; melakukan perkalian ax dengan bx
mov [dam], ax ; menyimpan hasil ax ke dalam variabel dam

;konversi m
mov ax, [km] ; memasukan value dari km kedalam register ax
mov bx, 1000 ; memasukan nilai 1000 kedalam register bx
mul bx ; melakukan perkalian ax dengan bx
mov [m], ax ; menyimpan hasil ax kedalam variabel m

;menampilkan hasil konversi

mov dx, msgHm ; memuat string msg kedalam register dx
mov ah, 0x9 ; mengatur fungsi dos untuk menampilkan string
int 0x21 ; memanggil interupt untuk menampilkan string 
mov ax, [hm] ; memasukan value dari hm kedalam register ax
call print ; memanggil fungsi print
mov dx, newline ; memasukan alamat dari newline kedalam register dx
int 0x21 ; memanggil interupt untuk membuat newline

mov dx, msgDam ; memuat string msg kedalam register dx
mov ah, 0x9 ; mengatur fungsi dos untuk menampilkan string
int 0x21 ; memanggil interupt untuk menampilkan string
mov ax, [dam] ; memasukan value dari dam kedalam register ax
call print ; memanggil fungsi print
mov dx, newline ; memasukan alamat dari newline kedalam register dx
int 0x21 ; memanggil interupt untuk membuat newline

mov dx, msgm ; memuat string msg kedalam register dx
mov ah, 0x9 ; mengatur fungsi dos untuk menampilkan string
int 0x21 ; memanggil interupt untuk menampilkan string
mov ax, [m] ; memasukan value dari hm kedalam register ax
call print ; memanggil fungsi print
mov dx, newline ; memasukan alamat dari newline kedalam register dx
int 0x21 ; memanggil interupt untuk membuat newline

endofprogram:
mov ah, 0x4C ; mengatur fungsi dos untuk keluar dari program
int 0x21 ; memanggil interupt untuk menjalankan fungsi keluar dari program

print:
mov bx, 10 ; memasukan nilai 10 ke dalam register bx
mov di, buffer + 30 ; pointer di menunjukan ke buffer + 100
mov byte[di], '$' ; memasukan $ kedalam pointer di
dec di ; mendcrement di untuk menyimpan karakter berikutnya

konversi_ke_string: 
    xor dx, dx ; mengosongkan register dx          
    div bx ; melakukan pembagian ax dan bx              
    add dl, '0' ; melakukan penjumlahan dl dan juga ASCII dari 0 dan menyimpannya di register dl         
    mov [di], dl ; memasukan nilai dl kedalam pointer di         
    dec di ; mendcrement di untuk pindah ke karakter selanjutnya               
    test ax, ax ; mengecek value dalam ax         
    jnz konversi_ke_string ; bila ax tidak bernilai 0 maka akan dilakukan jump lagi ke koversi_ke_string
    inc di ; mengincrement di untuk mengatur ulang posisi ke awal string             
    mov dx, di ; mengatur dx ke awal string          
    mov ah, 0x9 ; fungsi dos untuk bisa menampilkan string         
    int 0x21 ; memanggil interupt untuk bisa menampilkan string
    ret ; mengembalikan fungsi ke pemanggil