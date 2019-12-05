AGE="$(./stringToDec.sh $2)"

TMP="$(echo $1 | cut -c 1-32)"
HASH1="$(./hexToDec.sh $TMP)"

TMP="$(echo $1 | cut -c 33-64)"
HASH2="$(./hexToDec.sh $TMP)"

zokrates compute-witness -a $AGE $HASH1 $HASH2 | tail -n 3
