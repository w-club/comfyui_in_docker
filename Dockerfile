FROM pytorch/pytorch:2.9.0-cuda13.0-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget gosu libgl1 libglib2.0-0 build-essential ffmpeg libportaudio2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/Comfy-Org/ComfyUI/refs/heads/master/requirements.txt && \
    pip install -r requirements.txt && \
    wget https://raw.githubusercontent.com/Comfy-Org/ComfyUI-Manager/refs/heads/main/requirements.txt -O manager_requirements.txt && \
    pip install -r manager_requirements.txt && \
    wget https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt -O controlnet_aux_reqs.txt && \
    pip install -r controlnet_aux_reqs.txt && \
    wget https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt -O kjnodes_reqs.txt && \
    pip install -r kjnodes_reqs.txt && \
    wget https://raw.githubusercontent.com/un-seen/comfyui-tensorops/main/requirements.txt -O tensorops_reqs.txt && \
    pip install -r tensorops_reqs.txt && \
    wget https://raw.githubusercontent.com/ltdrdata/was-node-suite-comfyui/refs/heads/main/requirements.txt -O was_reqs.txt && \
    pip install -r was_reqs.txt && \
    wget https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/refs/heads/main/requirements.txt -O mon_reqs.txt && \
    pip install -r mon_reqs.txt && \
    wget https://raw.githubusercontent.com/nicofdga/DZ-FaceDetailer/refs/heads/main/requirements.txt -O detailer_reqs.txt && \
    pip install -r detailer_reqs.txt && \
    wget https://raw.githubusercontent.com/yolain/ComfyUI-Easy-Use/refs/heads/main/requirements.txt -O easy_use_reqs.txt && \
    pip install -r easy_use_reqs.txt && \
    pip install flask-restx py-cord[voice] browser-use && \
    pip install torchcodec && \
    pip install onnxruntime-gpu
    
# RUN --mount=type=cache,target=/root/.cache/pip \
#    wget https://raw.githubusercontent.com/heshengtao/comfyui_LLM_party/refs/heads/main/requirements_fixed.txt -O llm_reqs.txt && \
#    pip install -r llm_reqs.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    echo "Installing LLM Party Full Requirements..." && \
    pip install \
    beautifulsoup4 docx2txt langchain langchain_community langchain_text_splitters \
    "openai>=1.57.4" openpyxl pandas pytz Requests xlrd faiss-cpu websocket-client \
    streamlit virtualenv tiktoken "transformers>=4.41.1" transformers_stream_generator \
    optimum pdfplumber wikipedia arxiv "bitsandbytes==0.43.1" "accelerate==0.30.1" \
    fastapi py-cpuinfo diskcache requests_toolbelt tabulate charset_normalizer \
    "tenacity>=8.1.0,<8.4.0" cpm_kernels pydub keyboard sounddevice neo4j soundfile \
    langchain_openai sentence_transformers uvicorn llama_index "html2image==2.0.3" \
    markdown selenium librosa ffmpeg-python "moviepy==1.0.3" html5lib easyocr \
    feedparser psutil verovio mdtex2html markdownify srt peft scipy json-repair \
    redis fish_audio_sdk "httpx<=0.27.2" mcp "qwen-vl-utils[decord]" attrdict \
    docstring_parser langchain_ollama timm \
    # [關鍵修正] 使用 aisuite 核心版
    aisuite


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
