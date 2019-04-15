OPCION='d'
while getopts a:un opcion
  do
    case "${opcion}" in
      a) ARCHIVO=${OPTARG};;
      u) OPCION='u';;
      n) OPCION='n';;
      *) exit;;
    esac
done

if [ -z $ARCHIVO ]
then
    echo "Ejecutar: ./getshcode.sh -a <archivo_ELF> [-u|-n]"
    exit
fi
if [ $OPCION = 'u' ]
    then
        OPC='\\u'
elif [ $OPCION = 'n' ]
	then
        OPC=''
elif [ $OPCION = 'd' ]
    then
        OPC='\\x'
fi
if [ $OPCION = 'u' ]
then
  objdump -d -j .text $ARCHIVO | grep -e '^ ' | tr '[[:space:]]' '\n' | egrep '^[[:alnum:]]{2}$' | xargs | sed "s/ \(..\)/ \1\1/g" | sed "s/^\(..\)/\1\1/g" | sed "s/ /$OPC/g" | sed -e "s/^/$OPC/g" |  sed 's/\\.j.//g'
else
  objdump -d -j .text $ARCHIVO | grep -e '^ ' | tr '[[:space:]]' '\n' | egrep '^[[:alnum:]]{2}$' | xargs | sed "s/ /$OPC/g" | sed -e "s/^/$OPC/g" |  sed 's/\\.j.//g'
fi