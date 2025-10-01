#!/bin/bash

source .env

gdcloud organizations add-iam-policy-binding $ORGANIZATION --role=ai-platform-admin
