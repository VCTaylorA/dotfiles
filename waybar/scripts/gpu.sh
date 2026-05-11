#!/bin/bash
nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | \
  awk '{printf "%d\n%.2f/%.2f", $1, $2, $3}'
