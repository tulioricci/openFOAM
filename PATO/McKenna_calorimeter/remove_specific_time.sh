#!/bin/bash
#for i in {0..4}
for i in `seq 0 4`
do
        cd processor${i}
	pwd
        rm -rfv 28\.950000
        cd ../
done
