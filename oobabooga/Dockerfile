ARG BASE_IMAGE=runpod/pytorch:cuda12
FROM ${BASE_IMAGE} as dev-base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive SHELL=/bin/bash

RUN cd /workspace && git clone https://github.com/oobabooga/text-generation-webui.git && cd /workspace/text-generation-webui && pip install -r requirements.txt
RUN cd /workspace && git clone https://github.com/PanQiWei/AutoGPTQ.git && cd /workspace/AutoGPTQ && pip install .
RUN cd /workspace && git clone https://github.com/timdettmers/bitsandbytes.git && cd /workspace/bitsandbytes && CUDA_VERSION=120 make cuda12x && python setup.py install && cp /workspace/bitsandbytes/bitsandbytes/libbitsandbytes_cuda120.so /usr/local/lib/python3.10/dist-packages/bitsandbytes/libbitsandbytes_cpu.so

COPY start.sh /workspace
RUN chmod +x /workspace/start.sh

CMD [ "/workspace/start.sh" ]
