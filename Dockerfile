FROM pytorch/pytorch:2.9.0-cuda13.0-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget gosu && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt && \
    pip install -r requirements.txt

COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod u+x /workspace/entrypoint.sh

COPY run_comfy.sh /workspace/run_comfy.sh
RUN chmod u+x /workspace/run_comfy.sh

ENV NVIDIA_VISIBLE_DEVICES=all 
ENV PIP_USER=true
ENV PIP_ROOT_USER_ACTION=ignore
ENV PATH="/root/.local/bin:$PATH"
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD ["python", "-u", "/comfyui/main.py", "--listen", "0.0.0.0"]
