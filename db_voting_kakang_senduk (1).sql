-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2026 at 07:39 AM
-- Server version: 10.11.16-MariaDB
-- PHP Version: 8.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_voting_kakang_senduk`
--

-- --------------------------------------------------------

--
-- Table structure for table `kontestan`
--

CREATE TABLE `kontestan` (
  `id` int(11) NOT NULL,
  `nomor_peserta` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `kategori` enum('Kakang','Senduk') NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `asal_instansi` varchar(150) DEFAULT NULL,
  `tempat_lahir` varchar(100) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `visi` text DEFAULT NULL,
  `misi` text DEFAULT NULL,
  `prestasi` text DEFAULT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kontestan`
--

INSERT INTO `kontestan` (`id`, `nomor_peserta`, `nama`, `kategori`, `foto`, `asal_instansi`, `tempat_lahir`, `tanggal_lahir`, `visi`, `misi`, `prestasi`, `deskripsi`) VALUES
(1, '1', 'Nyoman Ayu Carmenita', 'Senduk', 'e805e30dc27941358b1db9750b71acf4.jpg', 'SMK adasaja', 'jenangan', '2009-12-12', 'Menjadi jembatan komunikasi antara generasi muda dan pemerintah kota dalam menyampaikan ide kreatif untuk kemajuan daerah.', 'Menjadi representasi generasi muda yang inspiratif, berintegritas, dan inovatif dalam memajukan potensi pariwisata, ekonomi kreatif, serta budaya daerah ke kancah regional maupun nasional.', '• Seni Pertunjukan: Pemenang festival tari tradisional, lomba menyanyi lagu daerah, teater, atau pertunjukan musik tradisional.\r\n• Duta atau Ajang Sebelumnya: Pernah terpilih menjadi Duta Sekolah, Duta Kampus, Duta Baca, atau finalis ajang pemilihan putra-putri daerah tingkat kecamatan.\r\n• Karya Kreatif: Juara lomba fotografi destinasi wisata, desain poster budaya, atau pembuat konten kreatif (content creator) bertema kearifan lokal.\r\n', ''),
(2, '2', 'Kim Na-yeon', 'Senduk', '0954c9ed9e5548e1afa5cc24955b1344.jpg', 'SMA sekolah diaja', 'mlarak', '2026-11-12', 'Menjadi representasi generasi muda yang berintegritas dan inovatif dalam memajukan potensi pariwisata serta melestarikan warisan budaya lokal di kancah nasional maupun internasional.', '• Misi:\r\n	• Mengoptimalkan promosi destinasi wisata dan kekayaan budaya daerah melalui konten digital yang edukatif.\r\n	• Mengajak generasi muda untuk mengenal, mencintai, dan melestarikan seni tradisional setempat.\r\n	• Menjalin sinergi dengan dinas terkait dan komunitas budaya dalam menyukseskan agenda festival kota.\r\n', 'Prestasi Kompetisi Seni & Budaya\r\n\r\n• Juara 1 Lomba Tari Tradisional Tingkat Kota/Kabupaten (Tahun 2025).\r\n• Penampil Terbaik Festival Seni Budaya Pelajar Tingkat Provinsi (Tahun 2024).\r\n', ''),
(3, '3', 'Angelina Christy ', 'Senduk', '277f415b84a14bde9634305333ae9feb.jpg', 'SMA Negeri 29 Jakarta', 'jakarta', '2005-12-05', 'Mewujudkan Duta Kota sebagai motor penggerak promosi digital yang kreatif untuk mengangkat daya saing UMKM dan destinasi unggulan daerah.', '• Misi:\r\n	• Membuat kampanye kreatif di media sosial untuk memperkenalkan kuliner khas dan produk kerajinan lokal.\r\n	• Berkolaborasi dengan pelaku UMKM muda dalam memperluas jangkauan pemasaran produk daerah.\r\n	• Mendorong pemanfaatan teknologi digital sebagai sarana informasi wisata yang mudah diakses pengunjung.\r\n', '\r\n. Prestasi Akademik & Kepenulisan\r\n\r\n• Juara Harapan 1 Lomba Karya Tulis Ilmiah (LKTI) bertema Inovasi Pariwisata Daerah Tingkat Provinsi (Tahun 2025).\r\n• Penerima Beasiswa Prestasi Akademik dari Pemerintah Daerah/Institusi Pendidikan (Tahun 2024).\r\n', ''),
(4, '4', 'Michelle Alexandra', 'Senduk', 'd0b9ad95e6c64468b1dd4dc57bc7894e.jpg', 'SMA Negeri 10 Jakarta', 'jakarta', '2009-04-22', 'Menginspirasi masyarakat luas untuk menciptakan lingkungan kota yang bersih, hijau, dan lestari demi mendukung kenyamanan wisata serta kualitas hidup warga', '• Misi:\r\n	• Mengampanyekan gerakan pengurangan sampah plastik dan kepedulian kebersihan di ruang publik serta tempat wisata.\r\n	• Menggerakkan partisipasi pemuda dalam aksi nyata pelestarian lingkungan seperti penanaman pohon dan bank sampah.\r\n	• Mengedukasi masyarakat tentang pentingnya menjaga kelestarian alam sebagai aset utama pariwisata kota.\r\n', '\r\nPrestasi Kepemimpinan & Organisasi\r\n\r\n• Ketua Pelaksana Acara Pentas Seni dan Bazar UMKM dengan lebih dari 500 peserta (Tahun 2025).\r\n• Delegasi Pemuda Kota dalam Forum Pemuda Pelopor Tingkat Provinsi (Tahun 2024).\r\n', ''),
(5, '5', 'faza', 'Kakang', NULL, 'SMK Pgri 2 ponorogo', 'ponorogo', '2011-02-12', 'aksndolq', 'asdad', 'fullstak', '');

-- --------------------------------------------------------

--
-- Table structure for table `periode_voting`
--

CREATE TABLE `periode_voting` (
  `id` int(11) NOT NULL,
  `nama_periode` varchar(100) NOT NULL,
  `tanggal_mulai` datetime NOT NULL,
  `tanggal_selesai` datetime NOT NULL,
  `status` enum('Aktif','Nonaktif') NOT NULL DEFAULT 'Nonaktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `periode_voting`
--

INSERT INTO `periode_voting` (`id`, `nama_periode`, `tanggal_mulai`, `tanggal_selesai`, `status`) VALUES
(1, 'kakang senduk 2026', '2026-11-12 10:00:00', '2026-11-12 12:00:00', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','pemilih') NOT NULL DEFAULT 'pemilih',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `no_hp`, `password`, `role`, `created_at`) VALUES
(1, 'faza', 'nasrulfaza657@gmail.com', '085746863781', 'scrypt:32768:8:1$HvcO11KGbwfxGEeE$3ff78e76d253eeb7acf8d5d471f19a03cd6158946445dc02f263c4d5aaa5ef72e88ebcc2578ba3332a6c59fbb2cc84c0f1a583940a9a1918a599fc0e22f140e9', 'pemilih', '2026-11-12 02:22:29'),
(2, 'Administrator', 'admin@voting.local', NULL, 'scrypt:32768:8:1$N3ikAA8pgdCsb6Cs$b35fd5bd5a13ceb7b08ab2787488c40b1dd755ba167b3bd5b916a3b1393ba24c8a43ff426a31dca1d538529af433f3a3f57041a06c2abb493c3a133eaecc24ea', 'admin', '2026-11-12 02:37:02');

-- --------------------------------------------------------

--
-- Table structure for table `voting`
--

CREATE TABLE `voting` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `kontestan_id` int(11) NOT NULL,
  `kategori` enum('Kakang','Senduk') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voting`
--

INSERT INTO `voting` (`id`, `user_id`, `kontestan_id`, `kategori`, `created_at`) VALUES
(1, 1, 1, 'Senduk', '2026-11-12 10:17:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kontestan`
--
ALTER TABLE `kontestan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_nomor_kategori` (`nomor_peserta`,`kategori`);

--
-- Indexes for table `periode_voting`
--
ALTER TABLE `periode_voting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `voting`
--
ALTER TABLE `voting`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_kategori` (`user_id`,`kategori`),
  ADD KEY `idx_voting_kontestan` (`kontestan_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kontestan`
--
ALTER TABLE `kontestan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `periode_voting`
--
ALTER TABLE `periode_voting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `voting`
--
ALTER TABLE `voting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `voting`
--
ALTER TABLE `voting`
  ADD CONSTRAINT `fk_voting_kontestan` FOREIGN KEY (`kontestan_id`) REFERENCES `kontestan` (`id`),
  ADD CONSTRAINT `fk_voting_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
