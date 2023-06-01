#!/bin/bash

echo 'syncing to workspace, please wait'
rsync -au --remove-source-files /text-generation-webui/* /workspace/text-generation-webui

if [[ $PUBLIC_KEY ]]
then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cd ~/.ssh
    echo $PUBLIC_KEY >> authorized_keys
    chmod 700 -R ~/.ssh
    cd /
    service ssh start
fi

cd /workspace/text-generation-webui/

if [ ! -z "$LOAD_MODEL" ]; then
    python /workspace/text-generation-webui/download-model.py $LOAD_MODEL
fi

if [[ $JUPYTER_PASSWORD ]]
then
  echo "Launching Jupyter Lab"
  cd /
  nohup jupyter lab --allow-root --no-browser --port=8888 --ip=* --ServerApp.token=$JUPYTER_PASSWORD --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace &
fi

if [ "$WEBUI" == "chatbot" ]; then
    OOBA_ARGS="$OOBA_ARGS --chat"
fi

cd /workspace/text-generation-webui
# runs Oobabooga text generation webui on port 7860, and api on port 5000
echo "Launching Server"
echo "python server.py --listen $OOBA_ARGS"
python server.py --listen $OOBA_ARGS
