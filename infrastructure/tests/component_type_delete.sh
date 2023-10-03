#!/bin/bash
source ./function_urls

curl -H "Content-Type: application/json" -d @component_type_delete.json $CTD
