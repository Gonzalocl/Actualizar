#rm -r AEC AED1 ALF POO ISO
mkdir ref
cd ref
mkdir AEC AED1 ALF POO ISO
echo 1 > AEC/ha
echo 2 > AEC/hola
echo 3 > AEC/hi
mkdir AEC/hu
cp AEC/* AEC/hu
echo 1 > AEC/hh
cd ..
rm ref/AEC/hi ref/AEC/hu/hi
echo re > ref/AEC/gu
