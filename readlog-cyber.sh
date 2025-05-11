#!/bin/bash

##criado por Carlos Eduardo
## 17-04-25
##Brasil
##Script para ler arquivos de log

data1=$(date '+%d-%m-%Y %H:%M:%S')

echo "Informe o nome do arquivo de log"
read arquivo1

echo "Selecione uma das opções abaixo:"
echo "0 - Possíveis ataques de XSS detectados"
echo "1 - Detectar tentativas de SQL Injection"
echo "2 - Detectar varredura de diretórios (Directory Traversal)"
echo "3 - Detectar possíveis ataques por scanners (User-Agent suspeito)"
echo "4 - Identificar tentativas de acesso a arquivos sensíveis (.env, .git, etc.)"
echo "5 - Detectar possíveis ataques de força bruta a arquivos/pastas"
echo "6 - Listar os ips e verificar o numero de requisições"
echo "7 - Mostrar o primeiro e ultimo acesso de um IP suspeito"
echo "8 - Localizar user-agent utilizado por um IP suspeito"
echo "9 - Localizar acesso a um determinado arquivo sensível"
read -n 1 -s n
case $n in
  0) grep -iE "<script|%3Cscript" $arquivo1 ;;
  1) read -p "informe o nome do termo para pesquisa (union|select|insert|drop): " sql1
	 grep -w -iE $sql1 $arquivo1 ;;
  2) grep -E "\.\./|\.\.%2f" $arquivo1 ;;
  3) read -p "informe o User-Agent para pesquisar: " useragent1
	 grep -iE $useragent1 $arquivo1 ;;
  4) read -p "Informe o nome do arquivo sensível: " sensivel1
	grep -iE $sensivel1 $arquivo1 ;;
  5) grep " 404 " access.log | cut -d " " -f 1 | sort | uniq -c | sort -nr | head ;;
  6) cat $arquivo1 | cut -d " " -f 1 | sort | uniq -c ;;
  7) grep "IP" $arquivo1 | head -n1
     grep "IP" $arquivo1 | tail -n1 ;;
  8) read -p "Informe o IP: " ip_suspeito1
	grep $ip_suspeito1 $arquivo1 | cut -d '"' -f 6 | sort | uniq ;;
  9) read -p "Informe o nome do arquivo sensível: " sensivel2
	grep $sensivel2 $arquivo1 ;;
esac
echo Usuário que executou o script $USER
echo Gerado em $data1

read -p "Pressione o enter para retornar"
exec /bin/bash "$0" "$@"
      done
