<?php
// Koneksi ke database
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");

// Periksa koneksi
if (mysqli_connect_errno()) {
    echo "Gagal terhubung ke MySQL: " . mysqli_connect_error();
    exit();
}

// Ambil query pencarian dari parameter GET
$query = $_GET['query'];

// Query untuk mencari pengguna berdasarkan username atau email
$searchQuery = "SELECT * FROM users WHERE username LIKE '%$query%' OR email LIKE '%$query%'";
$result = mysqli_query($koneksi, $searchQuery);

if (!$result) {
    die("Query failed: " . mysqli_error($koneksi));
}

$users = array();

while ($row = mysqli_fetch_assoc($result)) {
    $users[] = $row;
}

// Encode hasil ke format JSON dan kirimkan sebagai respons
header('Content-Type: application/json');
echo json_encode($users);

// Tutup koneksi
mysqli_close($koneksi);
?>
