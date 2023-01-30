<?php
error_reporting(0);

	
	include_once("dbconnect3.php");
	$search  = $_GET["search"];
	$results_per_page = 5;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	
	if ($search =="all"){
	$sqlloadhome = "SELECT * FROM homes ORDER BY date DESC";

	}else{
	$sqlloadhome = "SELECT * FROM homes WHERE name LIKE '%$search%' ORDER BY date DESC";
	}
	$result = $conn->query($sqlloadhome);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloadhome = $sqlloadhome . " LIMIT $page_first_result , $results_per_page";
	$result = $conn->query($sqlloadhome);


	
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
$response = array('status' => 'success','numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result", 'data' => $homesarray);
    sendJsonResponse($response);
	
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
		
	

?>