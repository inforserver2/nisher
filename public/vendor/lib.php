<?php
$place=$_SERVER['DOCUMENT_ROOT'];
$place=explode("/", $place);
array_pop($place);
$place=implode("/", $place);

require_once "spyc-0.5/spyc.php";
$cfg = Spyc::YAMLLoad("{$place}/config/sys.yml");

?>
