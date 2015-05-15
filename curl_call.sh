#!/bin/bash

curl -vvv  https://tap-nexus.appspot.com/api/kahunalogs?env=s --user $KAHUNA_SECRET:$KAHUNA_API_SECRET -d '{"number_of_records" : 10, "categories_to_return" : [ "push" ], "timestamp" : "05/06/2015" }'
