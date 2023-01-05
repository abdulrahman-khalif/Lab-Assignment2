try {
		if ($conn->query($sqlinsert) === TRUE) {
			
			$response = array('status' => 'success', 'data' => $sqlinsert);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();