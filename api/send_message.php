<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];
if ($method == 'POST') {
    $senderId = $_POST['sender_id'];
    $message = $_POST['message']; 
    $receiverId = $_POST['receiver_id']; 
    $insertQuery = "INSERT INTO messages (receiver_id, sender_id, message) VALUES (?, ?, ?)";
    $stmt = mysqli_prepare($koneksi, $insertQuery);
    if ($stmt) {
        mysqli_stmt_bind_param($stmt, "iis", $senderId, $receiverId, $message);
        $result = mysqli_stmt_execute($stmt);
        if ($result) {
            echo json_encode(array('success' => true));
        } else {
            echo json_encode(array('success' => false, 'error' => mysqli_error($koneksi)));
        }
        mysqli_stmt_close($stmt);
    } else {
        echo json_encode(array('success' => false, 'error' => mysqli_error($koneksi)));
    }
}
mysqli_close($koneksi);
?>