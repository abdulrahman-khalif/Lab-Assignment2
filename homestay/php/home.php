<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	
include_once("dbconnect3.php");
	
	$userid = $_POST['userid'];
  $homename= addslashes($_POST['name']);
	$homedesc= addslashes ($_POST['homedesc']);
	$price= $_POST['price'];
  $state= addslashes($_POST['state']);
  $local= addslashes($_POST['local']);
  $lat= $_POST['lat'];
  $lon= $_POST['lon'];
 $image_one= $_POST['image_one'];
 $image_two= $_POST['image_two'];
 $image_tree= $_POST['image_tree'];

	
	$sqlinsert = "INSERT INTO `homes`(`user_id`, `name`, `home_desc`, `price`, `states`, `local`, `lat`, `lng`) VALUES ('$userid','$homename','$homedesc',$price,'$state','$local','$lat','$lon')";
	
 if ($conn->query($sqlinsert) === TRUE) {
			$decoded_image = base64_decode($image_one);
			$decoded_string = base64_decode($image_two);
			$decoded_tree = base64_decode($image_tree);
			$filename = mysqli_insert_id($conn);
			$path = '../assets/home_images/'.$filename.'.png';
			$path2 = '../assets/home_images/'.$filename.'_2.png';
			$path3 = '../assets/home_images/'.$filename.'_3.png';


			file_put_contents($path, $decoded_image);
			file_put_contents($path2, $decoded_string);
			file_put_contents($path3, $decoded_tree);

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