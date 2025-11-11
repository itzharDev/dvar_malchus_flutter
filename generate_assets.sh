filePath=lib/core/constants/assets.dart

rm -f $filePath &

icons=$(ls assets/icons)
images=$(ls assets/images)

array=($icons)
assets="class DvarMalchusIcons {\n"
MYCUSTOMTAB='                           '
for element in ${icons}
do
    assets+="$MYCUSTOMTAB static const ${element%.*} = 'assets/icons/$element';\n"
done
assets+="}\n\n"

assets+="class DvarMalchusImages {\n"
for element in ${images}
do
    assets+="$MYCUSTOMTAB static const ${element%.*} = 'assets/images/$element';\n"
done
assets+="}"

echo $assets | tee $filePath