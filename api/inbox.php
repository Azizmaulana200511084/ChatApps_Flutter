<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");
$receiver_id = $_GET['receiver_id'];
$lastTimestamp = isset($_GET['last_timestamp']) ? $_GET['last_timestamp'] : null;
$query = "SELECT messages.*, users.username AS sender_username
          FROM messages
          INNER JOIN users ON messages.sender_id = users.id
          WHERE messages.receiver_id = $receiver_id";
if ($lastTimestamp) {
    $query .= " AND messages.timestamp > '$lastTimestamp'";
}
$query .= " ORDER BY messages.timestamp DESC";
$result = mysqli_query($koneksi, $query);
if (!$result) {
    die("Query failed: " . mysqli_error($koneksi));
}
$messages = array();
while ($row = mysqli_fetch_assoc($result)) {
    $messages[] = $row;
}
header('Content-Type: application/json');
echo json_encode($messages);
mysqli_close($koneksi);
?>