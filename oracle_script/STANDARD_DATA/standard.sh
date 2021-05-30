sqlplus $1/$2 @./STANDARD_DATA/toggleFKs.sql disable > ./STANDARD_DATA/disableFKs.out
sqlplus $1/$2 @./STANDARD_DATA/toggleTriggers.sql disable > ./STANDARD_DATA/disableTriggers.out

# if not slave, load czar data
if test $3 != y
then
  imp userid = $1/$2 file = ./STANDARD_DATA/standardData.dmp ignore = Y grants = N indexes = N rows = Y fromuser = \(standard,standard_czar\) touser = \($1,$1\)  log = ./STANDARD_DATA/standardCzarDataImp.log 
else
  imp userid = $1/$2 file = ./STANDARD_DATA/standardData.dmp ignore = Y grants = N indexes = N rows = Y fromuser = standard touser = $1  log = ./STANDARD_DATA/standardDataImp.log 
fi

sqlplus $1/$2 @./STANDARD_DATA/toggleFKs.sql enable > ./STANDARD_DATA/enableFKs.out
sqlplus $1/$2 @./STANDARD_DATA/toggleTriggers.sql enable > ./STANDARD_DATA/enableTriggers.out

# now do the standard data load for DECODES

sqlplus decodes/decodes @./STANDARD_DATA/toggleFKs.sql disable > ./STANDARD_DATA/disabledecodesFKs.out
sqlplus decodes/decodes @./STANDARD_DATA/toggleTriggers.sql disable > ./STANDARD_DATA/disabledecodesTriggers.out

  imp userid = decodes/decodes file = ./STANDARD_DATA/standardData.dmp ignore = Y grants = N indexes = N rows = Y fromuser = standard_decodes touser = decodes  log = ./STANDARD_DATA/standardDecodesDataImp.log 

sqlplus decodes/decodes @./STANDARD_DATA/toggleFKs.sql enable > ./STANDARD_DATA/enableDecodesFKs.out
sqlplus decodes/decodes @./STANDARD_DATA/toggleTriggers.sql enable > ./STANDARD_DATA/enableDecodesTriggers.out


