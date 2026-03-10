#!/bin/bash

mkdir -p /root/.trice/cache/
trice insert -src ./Project/ -src ./Tests -cache
