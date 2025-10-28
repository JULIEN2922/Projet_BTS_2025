echo off
echo 0
javac -cp "lib/opencv-4100.jar" -d "bin" src/thread/*.java src/util/*.java src/*.java
echo 1
java -Djava.library.path="lib" -cp "lib/opencv-4100.jar;bin" _start_traitement
