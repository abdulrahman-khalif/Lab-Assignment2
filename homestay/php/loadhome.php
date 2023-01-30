<?php
error_reporting(0);
if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	
	$userid = $_GET['userid'];
	include_once("dbconnect3.php");
	$sqlloadproduct = "SELECT * FROM homes WHERE user_id = '$userid' ORDER BY date DESC";
	$result = $conn->query($sqlloadproduct);
	
	if ($result->num_rows > 0) {
		$homesarray["homes"] = array();
		while ($row = $result->fetch_assoc()) {
			$holist = array();
			$holist['home_id'] = $row['home_id'];
			$holist['user_id'] = $row['user_id'];
			$holist['name'] = $row['name'];
			$holist['home_desc'] = $row['home_desc'];
			$holist['price'] = $row['price'];
			$holist['states'] = $row['states'];
			$holist['local'] = $row['local'];
			$holist['lat'] = $row['lat'];
			$holist['lng'] = $row['lng'];
			$holist['date'] = $row['date'];
			array_push($homesarray["homes"],$holist);
			
			
		}
$response = array('status' => 'success', 'data' => $homesarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
		
	

?>