#!/bin/bash
aws cloudformation --region us-west-2 \
create-stack \
--stack-name $1 \
--template-body file://$2 \
--parameters file://$3