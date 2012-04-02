<?
/*
  cotacaoDolar.php - script usado para extrair a cotação atual do dólar junto ao
  banco central do governo federal

  Autor: Fábio Berbert de Paula <fabio@vivaolinux.com.br>
  http://www.vivaolinux.com.br
*/

// o fopen também funciona para arquivos da rede, uau !
if(!$fp=fopen("http://cotacao.republicavirtual.com.br/web_cotacao.php?formato=query_string " ,"r" )) {
    echo "Erro ao abrir a página de cotação" ;
    exit ;
}
  
$conteudo = '';
while(!feof($fp)) { // leia o conteúdo da página
   $conteudo .= fgets($fp,1024);
}
fclose($fp);

//var_dump($conteudo);

parse_str($conteudo);
echo $dolar_paralelo_venda; //will output 1


?>