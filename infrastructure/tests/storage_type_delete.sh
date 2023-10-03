#!/bin/bash
source ./function_urls
curl -H "Content-Type: application/json" -d @storage_type_delete.json  $STD

