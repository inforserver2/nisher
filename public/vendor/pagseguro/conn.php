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
  echo "fatura não encontrada";
  exit();
}
	
	$fatura_pag='
	<html>
	<head>
	<title>PagSeguro</title>
	</head>
	<body>
	<form name="pagseguro" action="https://pagseguro.uol.com.br/security/webpagamentos/webpagto.aspx" method="post">
	  <input type="hidden" name="email_cobranca" value="'.$cfg["pagseguro"]["account"].'"  />
	  <input type="hidden" name="tipo" value="CP"  />
	  <input type="hidden" name="moeda" value="BRL"  />
	  <input type="hidden" name="item_id_1" value="33"  />
	  <input type="hidden" name="item_descr_1" value="'.$jo->order_desc.'"  />
	  <input type="hidden" name="item_quant_1" value="1"  />
	  <input type="hidden" name="item_valor_1" value="'.number_format($jo->order_price, 2).'"  />
	  <input type="hidden" name="item_peso_1" value="2"  />
	<script language="JavaScript">document.pagseguro.submit();</script>
	</body>
	</html>
	';
	
	die("$fatura_pag");	

?>
