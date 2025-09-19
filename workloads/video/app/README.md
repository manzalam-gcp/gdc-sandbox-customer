# Video Intelligence API Visualiser

Adapted from: https://zackakil.github.io/video-intelligence-api-visualiser/

An app that visualises annotations from the [Google Cloud Video Intelligence API](https://cloud.google.com/video-intelligence).

Use [this script](./run_video_intelligence.py) to generate your own json outputs.

![](assets/vid_intel_demo.gif)

## Uses
- See all of the capabilities of the [Video Intelligence API](https://cloud.google.com/video-intelligence).
- Upload your own data files to quickly visulise your own annotations.
- Play with the interactive confidence threshold to find the right one for your usecase.


## Notes

```bash

gcloud storage buckets update gs://tackaberry-video-intelligence-videos --cors-file=cors-file.json

```

```
# .env file
SERVICE_NAME=video-intelligence-demo
REPO=us-docker.pkg.dev/tackaberry-vertex-demos/cloudrun
PROJECT_ID=tackaberry-vertex-demos
REGION=us-central1


```