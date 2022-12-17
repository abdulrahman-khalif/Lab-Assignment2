<?php
if (!isset($_POST['register'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();		
}

include_once("dbconnect2.php");
		
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);
$address = "na";


$users = "INSERT INTO `users`(`user_email`,`user_name`, `user_phone`, `user_address`,`user_password`, `otp`) 
VALUES ('$email','$name','$phone','$address','$password','$otp')";


try{		
if ($conn->query($users) === TRUE) {
$response = array('status' => 'success', 'data' => null);

sendJsonResponse($response);
}else{
$response = array('status' => 'failed', 'data' => null);
sendJsonResponse($response);
}
}catch (Exception $e){
    $response = array('status' => 'failed', 'data' => null);
sendJsonResponse($response);

}	
$conn->close();	



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
