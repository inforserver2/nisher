<?php
/*
 * ipn.php
 *
 * PHP Toolkit for PayPal v0.51
 * http://www.paypal.com/pdn
 *
 * Copyright (c) 2004 PayPal Inc
 *
 * Released under Common Public License 1.0
 * http://opensource.org/licenses/cpl.php
 *
 */

//get global configuration information
include_once('../includes/global_config.inc.php'); 

//get pay pal configuration file
include_once('../includes/config.inc.php'); 


//decide which post method to use
switch($paypal[post_method]) { 

case "libCurl": //php compiled with libCurl support

$result=libCurlPost($paypal[url],$_POST); 


break;


case "curl": //cURL via command line

$result=curlPost($paypal[url],$_POST); 

break; 


case "fso": //php fsockopen(); 

$result=fsockPost($paypal[url],$_POST); 

break; 


default: //use the fsockopen method as default post method

$result=fsockPost($paypal[url],$_POST);

break;

}


//check the ipn result received back from paypal

if(eregi("VERIFIED",$result)) 
{ include_once('./ipn_success.php'); } 

else 
{ include_once('./ipn_error.php'); } 


?>

