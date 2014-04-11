#!/bin/bash
# This script pulls in the Developer Documetnation and Guidance to build the full iatistandard.org website
./gen_rst.sh || exit $?

cd docs || exit 1

mkdir en/developer
cp -n ../../IATI-Developer-Documentation/*.rst en/developer
cp -rn ../../IATI-Developer-Documentation/*/ en/developer
cp -n ../..//IATI-Guidance/en/*.rst en/
cp -rn ../../IATI-Guidance/en/*/ en/
cp ../combined_sitemap.rst en/sitemap.rst

git add .
git commit -a -m 'Auto'
git ls-tree -r --name-only HEAD | grep 'rst$' | while read filename; do
    echo $'\n\n\n'"*Last updated on $(git log -1 --format="%ad" --date=short -- $filename)*" >> $filename
done

cd .. || exit 1
./gen_html.sh || exit $?

echo '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' > docs/en/_build/dirhtml/sitemap.xml
find docs/en/_build/dirhtml | grep -v _static | grep index.html$ | sed 's|index.html$|</loc></url>|' | sed 's|docs/en/_build/dirhtml|<url><loc>http://dev.iatistandard.org|' >> docs/en/_build/dirhtml/sitemap.xml
echo '</urlset>' >> docs/en/_build/dirhtml/sitemap.xml

rm -rf docs-copy
cp -r docs docs-copy

