#!/bin/bash

if [ "$1" = "ragent" ]; then
  exec gosu usr1cv8 /opt/1cv8/x86_64/8.3.21.1644/ragent  
fi

/opt/1cv8/x86_64/8.3.21.1644/ras cluster --daemon

exec "$@"
