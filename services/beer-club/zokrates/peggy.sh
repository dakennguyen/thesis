# ./peggy.sh age_hash age

AGE="$(./stringToDec.sh $2)"

TMP="$(echo $1 | cut -c 3-34)"
HASH1="$(./hexToDec.sh $TMP)"

TMP="$(echo $1 | cut -c 35-66)"
HASH2="$(./hexToDec.sh $TMP)"

TMP="$(zokrates compute-witness -a $AGE $HASH1 $HASH2 | tail -n 1)"
echo $TMP
if [ "$TMP" = "[true]" ]; then
    zokrates generate-proof
fi
