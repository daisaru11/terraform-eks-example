#!/usr/bin/env bash

terraform output config_map_aws_auth | kubectl apply -f -