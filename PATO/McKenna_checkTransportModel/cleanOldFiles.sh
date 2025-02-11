for i in {0..5}
do
        for file in $(ls -dt processor${i}/[0-9]*/ | tail -n+6); do mkdir -p __trash__/processor${i}/; mv -v $file __trash__/processor${i}; done
done
rm -rf __trash__

