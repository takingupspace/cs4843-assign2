#!/bin/bash
aws --region us-west-2 cloudformation create-stack \
--stack-name $1 \
--template-body file://$2