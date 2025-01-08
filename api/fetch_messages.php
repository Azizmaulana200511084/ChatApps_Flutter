<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");
if (mysqli_connect_errno()) {
    echo "Gagal terhubung ke MySQL: " . mysqli_connect_error();
    exit();
}
$receiver_id = $_GET['receiver_id'];
$sender_id = $_GET['sender_id'];
$query = "SELECT messages.*, 
                  sender.username AS sender_username, 
                  receiver.username AS receiver_username 
          FROM messages 
          INNER JOIN users AS sender ON messages.sender_id = sender.id 
          INNER JOIN users AS receiver ON messages.receiver_id = receiver.id
          WHERE (messages.receiver_id = $receiver_id AND messages.sender_id = $sender_id)
             OR (messages.receiver_id = $sender_id AND messages.sender_id = $receiver_id)
          ORDER BY messages.timestamp ASC";
$result = mysqli_query($koneksi, $query);
if (!$result) {
    die("Query failed: " . mysqli_error($koneksi));
}
$messages = array();
while ($row = mysqli_fetch_assoc($result)) {
    $row['timestamp'] = date('Y-m-d H:i:s', strtotime($row['timestamp']));
    $messages[] = $row;
}
header('Content-Type: application/json');
echo json_encode($messages);
mysqli_close($koneksi);
?>