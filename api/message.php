<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");

$query = "SELECT * FROM messages WHERE status = 'new'";
$result = mysqli_query($koneksi, $query);

$messages = array();
while ($row = mysqli_fetch_assoc($result)) {
    $messages[] = array('message' => $row['message']);
}

$updateQuery = "UPDATE messages SET status = 'read' WHERE status = 'new'";
mysqli_query($koneksi, $updateQuery);

echo json_encode(array('messages' => $messages));

?>