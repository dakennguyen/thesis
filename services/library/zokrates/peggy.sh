# ./peggy.sh name_hash uni_hash name uni

NAME="$(./stringToDec.sh $3)"
TMP="$(echo $1 | cut -c 3-34)"
HASH1="$(./hexToDec.sh $TMP)"
TMP="$(echo $1 | cut -c 35-66)"
HASH2="$(./hexToDec.sh $TMP)"

UNI="$(./stringToDec.sh $4)"
TMP="$(echo $2 | cut -c 3-34)"
HASH3="$(./hexToDec.sh $TMP)"
TMP="$(echo $2 | cut -c 35-66)"
HASH4="$(./hexToDec.sh $TMP)"

TMP="$(zokrates compute-witness -a $NAME $UNI $HASH1 $HASH2 $HASH3 $HASH4 | tail -n 1)"
echo $TMP
if [ "$TMP" = "[true]" ]; then
    zokrates generate-proof
fi
