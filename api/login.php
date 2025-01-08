<?php
$koneksi = mysqli_connect("localhost", "root", "", "chat_app");
$username = $_POST['username'];
$password = $_POST['password'];
$response = array();
if(isset($_POST['username']) && isset($_POST['password'])) {
    $username = mysqli_real_escape_string($koneksi, $_POST['username']);
    $password = mysqli_real_escape_string($koneksi, $_POST['password']);
    $query = "SELECT * FROM users WHERE username='$username' AND password='$password'";
    $result = mysqli_query($koneksi, $query);
    if(mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $user_id = $row['id'];
        echo json_encode(array("user" => array("id" => $user_id)));
    } else {
        http_response_code(401);
        echo json_encode(array("error" => "Invalid username or password"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("error" => "Username and password are required"));
}
?>