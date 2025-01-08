<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");

if (!$koneksi) {
    die("Connection failed: " . mysqli_connect_error());
}

$data = json_decode(file_get_contents("php://input"));

if (empty($data->username) || empty($data->password) || empty($data->email)) {
    http_response_code(400);
    echo json_encode(array('status' => 'error', 'message' => 'Username, password, and email are required'));
    exit;
}
$query_check_username = "SELECT * FROM users WHERE username = '$data->username'";
$result_check_username = mysqli_query($koneksi, $query_check_username);
if (mysqli_num_rows($result_check_username) > 0) {
    http_response_code(400);
    echo json_encode(array('status' => 'error', 'message' => 'Username already exists'));
    exit;
}
$query = "INSERT INTO users (username, password, email) VALUES ('$data->username', '$data->password', '$data->email')";
if (mysqli_query($koneksi, $query)) {
    http_response_code(200);
    echo json_encode(array('status' => 'success', 'message' => 'User registered successfully'));
} else {
    http_response_code(500);
    echo json_encode(array('status' => 'error', 'message' => 'Failed to register user: ' . mysqli_error($koneksi)));
}
mysqli_close($koneksi);
?>