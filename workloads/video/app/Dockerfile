FROM alpine AS data-downloader
WORKDIR /videos

RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/caf-training.mp4
RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/caf-training.mp4-1748034693.4847867.json
RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/test_video.mp4
RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/test_json.json
RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/JaneGoodall.mp4
RUN wget -P /videos https://storage.googleapis.com/tackaberry-video-intelligence-videos/JaneGoodall.json

FROM nginx
WORKDIR /usr/share/nginx/html
COPY . ./
COPY --from=data-downloader /videos ./videos


