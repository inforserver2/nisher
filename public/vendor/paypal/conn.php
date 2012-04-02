<?
	
include "../lib.php";
//var_dump($cfg);
$jsonurl = $cfg["prot"]."/via/order/".$_GET["id"]."/".$_GET["token"].".json";
//var_dump($jsonurl);

$json = file_get_contents($jsonurl,0,null,null);
//var_dump($json);
$jo = json_decode($json);
//var_dump($jo);
//
if ($jo==NULL){
  echo "boleto não encontrado";
  exit();
}
	
	$fatura_pag='
	<html>
	<head>
	<title>Paypal</title>
	</head>
	<body>
	<form action="process.php" method="post" name="paypal">
	<input name="firstname" type="hidden" id="firstname" value="'.$jo->user_name.'" size="40">
	<input name="email" type="hidden" id="email" value="'.$jo->user_email1.'" size="40">
	<input name="item_name" type="hidden" id="item_name" value="'.$jo->order_desc.'" size="40"> 
	<input name="item_number" type="hidden" id="item_number" value="'.$jo->order_id.'" size="40">
	<input name="amount" type="hidden" id="amount" value="'.$jo->order_price.'" size="40">
	<script language="JavaScript">document.paypal.submit();</script>
	</body>
	</html>
	';
	
	die("$fatura_pag");	


?>
