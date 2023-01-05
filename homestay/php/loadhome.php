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
			$prlist = array();
			$prlist['home_id'] = $row['home_id'];
			$prlist['user_id'] = $row['user_id'];
			$prlist['name'] = $row['name'];
			$prlist['home_desc'] = $row['home_desc'];
			$prlist['price'] = $row['price'];
			$prlist['states'] = $row['states'];
			$prlist['local'] = $row['local'];
			$prlist['lat'] = $row['lat'];
			$prlist['lng'] = $row['lng'];
			$prlist['date'] = $row['date'];
			array_push($homesarray["homes"],$prlist);
			
			
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