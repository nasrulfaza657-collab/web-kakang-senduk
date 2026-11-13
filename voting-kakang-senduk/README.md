# Voting Pemilihan Kakang Senduk Ponorogo (Python)

Aplikasi berbasis **Python Flask + MySQL**. Antarmuka menggunakan template HTML/CSS yang dirender Flask; seluruh logika aplikasi ditulis dengan Python.

## Fitur
- Beranda, daftar kontestan, detail profil, pencarian dan filter kategori.
- Registrasi/login pemilih dengan hash password.
- Voting satu kali per kategori (satu Kakang dan satu Senduk), hanya saat periode aktif.
- Pembatasan voting ganda dijaga oleh UNIQUE KEY `(user_id, kategori)` di MySQL.
- Klasemen terpisah, ranking, total dan persentase suara.
- Admin: dashboard statistik, CRUD kontestan + upload foto, daftar pemilih, periode voting, hasil dan ekspor CSV.

## Instalasi Windows (XAMPP untuk MySQL)
1. Instal Python 3.10+ dan XAMPP. Jalankan **MySQL** dari XAMPP (Apache tidak diperlukan).
2. Buka phpMyAdmin (`http://localhost/phpmyadmin`), pilih **Import**, lalu impor `schema.sql`.
3. Ekstrak folder proyek, buka terminal di folder `voting-kakang-senduk`.
4. Buat virtual environment dan instal dependensi:
   ```bash
   py -m venv venv
   venv\Scripts\activate
   pip install -r requirements.txt
   ```
5. Salin `.env.example` menjadi `.env`. Sesuaikan DB_HOST, DB_USER, DB_PASSWORD dengan MySQL lokal. Konfigurasi XAMPP umumnya user `root` dan password kosong.
6. Buat akun admin:
   ```bash
   py seed_admin.py
   ```
   Masukkan nama, email, dan password admin ketika diminta.
7. Jalankan aplikasi:
   ```bash
   py app.py
   ```
8. Buka `http://127.0.0.1:5000`.

## Alur penggunaan awal
1. Login admin melalui menu Login menggunakan akun yang dibuat oleh `seed_admin.py`.
2. Tambahkan kontestan Kakang dan Senduk di menu Admin → Kontestan.
3. Buat periode di Admin → Periode. Isi waktu mulai dan selesai. Aktifkan status periode. Voting hanya terbuka saat waktu server berada di antara dua waktu tersebut.
4. Logout admin, registrasikan akun pemilih, login, lalu pilih satu kontestan pada masing-masing kategori di menu Voting.
5. Lihat klasemen publik atau hasil admin.

## Catatan
- Gunakan password admin yang kuat dan ganti `SECRET_KEY` sebelum aplikasi dipasang di server.
- Folder `static/uploads` menyimpan foto kontestan. Format yang diterima PNG/JPG/JPEG/WEBP, maksimal 4 MB.
- Database menyimpan satu suara per pemilih per kategori. Suara yang telah masuk tidak dapat diubah oleh pemilih.
- Hapus kontestan yang sudah memiliki suara akan ditolak oleh relasi foreign key agar riwayat suara tidak rusak.
- Untuk deployment publik, matikan `debug=True`, gunakan HTTPS, dan tambahkan perlindungan CSRF serta pembatasan percobaan login.
