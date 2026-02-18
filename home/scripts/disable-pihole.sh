#!/bin/sh

curl 'http://pi.hole/admin/api.php?disable=7200&token=rGfKCGI%2Fj2qPxr%2FaGpyi3fysgCUvo9ACjOAuGT%2FbpX4%3D' \
-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0' \
-H 'Accept: application/json, text/javascript, */*; q=0.01' \
-H 'Accept-Language: en-US,en;q=0.9' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Referer: http://pi.hole/admin/settings.php' \
-H 'X-Requested-With: XMLHttpRequest' \
-H 'Connection: keep-alive' \
-H 'Cookie: PHPSESSID=rtpug5mfplhfpthievt6sj2tfu' \
-H 'Priority: u=0'

