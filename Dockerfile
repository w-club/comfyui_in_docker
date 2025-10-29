FROM pytorch/pytorch:2.9.0-cuda13.0-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget

WORKDIR /workspace

RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt && \
    pip install -r requirements.txt


RUN wget https://raw.githubusercontent.com/feickoo/docker-comfyui/refs/heads/master/entrypoint.sh \
    && chmod u+x entrypoint.sh

ENV NVIDIA_VISIBLE_DEVICES=all 
ENV PIP_USER=true
ENV PIP_ROOT_USER_ACTION=ignore
ENV PATH="/root/.local/bin:$PATH"
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD ["python", "-u", "/comfyui/main.py", "--listen", "0.0.0.0"]
