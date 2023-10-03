#!/bin/bash
source ./function_urls
curl -H "Content-Type: application/json" -d @storage_instance_insert.json $SII
