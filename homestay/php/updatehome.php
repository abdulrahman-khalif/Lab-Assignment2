<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	
include_once("dbconnect3.php");
	$homeid = $_POST['homeid'];
	$userid = $_POST['userid'];
  $onername= addslashes($_POST['name']);
	$homedesc= addslashes ($_POST['homedesc']);
	$price= $_POST['price'];
  

	
	$sqlupdate = "UPDATE `homes` SET `name`='$onername',`home_desc`='$homedesc',`price`= $price WHERE `home_id` = '$homeid' AND `user_id` = '$userid'";
	
 if ($conn->query($sqlupdate) === TRUE) {
			
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>